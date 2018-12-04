//
//  YZUserManagerViewController.m
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserManagerViewController.h"

#import "YZAccountModel.h"
#import "NZUserTableViewCell.h"
#import "YZUserChongViewController.h"

@interface YZUserManagerViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *userArray;

@end

static NSString * const kNZUserTableViewCellIdentifiler = @"kNZUserTableViewCellIdentifiler";

@implementation YZUserManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户管理";
    
    self.tableView.backgroundColor = kYZBackViewColor;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshGoods:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshGoods:NO];
    }];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NZUserTableViewCell" bundle:nil] forCellReuseIdentifier:kNZUserTableViewCellIdentifiler];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshGoods:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshGoods:(BOOL)isRefresh {
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].userAPI getUserListWithPage:pageIndex
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                    [weakSelf.tableView.mj_header endRefreshing];
                                                    [weakSelf.tableView.mj_footer endRefreshing];
                                                    NSArray *userArray = [YZAccountModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                    if (isRefresh) {
                                                        weakSelf.userArray = [userArray mutableCopy];
                                                    } else {
                                                        [weakSelf.userArray  addObjectsFromArray:userArray];
                                                    }
                                                    if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.userArray.count > 0) {
                                                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                    }
                                                    [weakSelf.tableView reloadData];
                                                } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                    [weakSelf.tableView.mj_header endRefreshing];
                                                    [weakSelf.tableView.mj_footer endRefreshing];
                                                    [MBProgressHUD showMessageAuto:error.msg];
                                                }];
}

- (void)managerUser:(BOOL)isChong userId:(YZAccountModel *)user {
    YZUserChongViewController *vc = [YZUserChongViewController new];
    vc.mangerType = isChong ? 0 : 1;
    vc.user = user;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - action
//- (void)deleteAccountLog:(NZAccountLogModel *)model {
//    __weak typeof(self) weakSelf = self;
//    [[BaseAPI sharedAPI].userService delAccountLogWithLogId:model.logId
//                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                                                        [weakSelf.array removeObject:model];
//                                                        [weakSelf.tableView reloadData];
//                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
//                                                        [MBProgressHUD showError:error.msg];
//                                                    }];
//}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [NZUserTableViewCell yz_heightForCellWithModel:nil  contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NZUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNZUserTableViewCellIdentifiler];
    __weak typeof(self) weakSelf = self;
    [cell yz_configWithModel:[self.userArray yz_objectAtIndex:indexPath.row]];
    [cell setChongBlock:^(YZAccountModel *user) {
        [weakSelf managerUser:YES userId:user];
    }];
    [cell setTuiBlock:^(YZAccountModel *user) {
        [weakSelf managerUser:NO userId:user];
    }];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//
////    switch (self.type) {
////        case ShoppingCartType_Pass:
////        case ShoppingCartType_Merge: {
////            NZOrderManagerItemModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
////            [(NZShopCarTableViewCell *)cell yz_configWithModel:model];
////            ((NZShopCarTableViewCell *)cell).refreshPriceBlock = ^{
////                [weakSelf caculateAllGoodsPrice];
////            };
////        }
////        default: {
////            NZProductModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
////            [(NZShopCarTableViewCell *)cell yz_configWithModel:model];
////            ((NZShopCarTableViewCell *)cell).refreshPriceBlock = ^{
////                [weakSelf caculateAllGoodsPrice];
////            };
////        }
////            break;
////    }
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (self.type == ShoppingCartType_Default) {
    //        NZProductModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
    //        [self performSegueWithIdentifier:@"detailVC" sender:model.productId];
    //    }
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    __weak typeof(self) weakSelf = self;
//    NZProductModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
//                                                                            title:@"删除"
//                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//                                                                              [weakSelf deleteShoppingCarGoods:model];
//                                                                          }];
//    return @[deleteAction];
//}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
#warning for yc
    return [UIImage imageNamed:@"icon_shoppingcar_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀，用户列表竟然是空的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//jump
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"buynowVC"]) {
//        NZBuyNowViewController *vc = segue.destinationViewController;
//        vc.goodsDict = sender;
//    } else if ([segue.identifier isEqualToString:@"detailVC"]) {
//        NZGoodsDetailViewController *vc = segue.destinationViewController;
//        vc.goodsId = sender;
//    }
//}

#pragma mark - property
- (NSMutableArray *)userArray {
    if (!_userArray) {
        _userArray = [NSMutableArray array];
    }
    return _userArray;
}

@end
