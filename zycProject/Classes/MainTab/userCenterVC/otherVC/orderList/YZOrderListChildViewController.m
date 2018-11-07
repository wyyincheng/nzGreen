//
//  YZOrderListChildViewController.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderListChildViewController.h"

#import "YZOrderModel.h"
#import "YZOrderManagerModel.h"
#import "YZOrderListTableCell.h"
#import "YZOrderStatusTableCell.h"

#import "YZWuliuViewController.h"
#import "YZBuyNowViewController.h"
#import "YZCommentViewController.h"
#import "YZOrderDetailViewController.h"

@interface YZOrderListChildViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderListArray;

@end

@implementation YZOrderListChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshGoods:YES];
}

- (void)initViews {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderListTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderStatusTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderStatusTableCell yz_cellIdentifiler]];
}

- (void)refreshGoods:(BOOL)isRefresh {
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI getOrderListWithPageIndex:pageIndex
                                                     orderStatus:self.status
                                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                             [weakSelf.tableView.mj_header endRefreshing];
                                                             [weakSelf.tableView.mj_footer endRefreshing];
                                                             NSArray *userArray = [YZOrderModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                             if (isRefresh) {
                                                                 weakSelf.orderListArray = [userArray mutableCopy];
                                                             } else {
                                                                 [weakSelf.orderListArray  addObjectsFromArray:userArray];
                                                             }
                                                             if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.orderListArray.count > 0) {
                                                                 [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                             }
                                                             [weakSelf.tableView reloadData];
                                                         } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                             [weakSelf.tableView.mj_header endRefreshing];
                                                             [weakSelf.tableView.mj_footer endRefreshing];
                                                             [MBProgressHUD showMessageAuto:error.msg];
                                                         }];
}

- (void)gotoPingjiaVC:(YZOrderItemModel *)itemModel {
    YZCommentViewController *pingjiaVC = [[YZCommentViewController alloc] init];
    pingjiaVC.orderModel = itemModel;
    pingjiaVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pingjiaVC animated:YES];
}

- (void)reSubmitOrder:(id)order {
    
    if ([order isKindOfClass:[YZOrderModel class]]) {
        YZOrderModel *orderModel = order;
        
        if (orderModel.canResend) {
            YZBuyNowViewController *buynowVC = [YZBuyNowViewController new];
            NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
            [mdict setValue:orderModel.orderNumber forKey:@"orderNumber"];
            [mdict setValue:@(BuyType_ReSubmit) forKey:@"type"];
            [self gotoViewController:NSStringFromClass([YZBuyNowViewController class])
                         lauchParams:@{kYZLauchParams_GoodsDict:mdict}];
            return;
        }
        if ([YZUserCenter shared].userInfo.userType == UserType_Agent && orderModel.userOrderStatus == 2) {
            
            YZWuliuViewController *wuliuVC = [YZWuliuViewController new];
            wuliuVC.orderNumber = orderModel.orderNumber;
            wuliuVC.logisticsCompany = orderModel.logisticsCompany;
            wuliuVC.logisticsNumber = orderModel.logisticsNumber;
            [self.navigationController pushViewController:wuliuVC animated:YES];

            return;
#warning for yc 如何展示物流信息 ？？？
            [[YZNCNetAPI sharedAPI].orderAPI getDeliveInfoWithOrderNumber:orderModel.orderNumber
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                      [MBProgressHUD showSuccess:@"查看物流信息成功"];
                                                                  } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                      [MBProgressHUD showError:error.msg];
                                                                  }];
        }
    } else if ([order isKindOfClass:[YZOrderManagerModel class]]) {
        YZOrderManagerModel *model = order;
        __weak typeof(self) weakSelf = self;
        if (model.canAdopt) {
            NSMutableArray *marray = [NSMutableArray array];
            for (YZOrderItemModel *item in model.orderItemList) {
                [marray addObject:item.orderId];
            }
            [[YZNCNetAPI sharedAPI].orderAPI adoptOrderWithOrderList:marray
                                                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                 model.userOrderStatus = [responseObject yz_integerForKey:@"userOrderStatus"];
                                                                 model.orderNumber = [responseObject yz_stringForKey:@"orderNumber"];
                                                                 [weakSelf.tableView reloadData];
                                                             } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                 [MBProgressHUD showError:error.msg];
                                                             }];
        } else {
            [[YZNCNetAPI sharedAPI].orderAPI rejectOrderWithOrderNumber:model.orderNumber
                                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                    model.userOrderStatus = [responseObject yz_integerForKey:@"userOrderStatus"];
                                                                    [weakSelf.tableView reloadData];
                                                                } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                    [MBProgressHUD showError:error.msg];
                                                                }];
        }
    }
    
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.orderListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YZOrderModel *orderModel = [self.orderListArray yz_objectAtIndex:section];
    return orderModel.orderItemList.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHex:0xF4F4F4];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZOrderModel *orderModel = [self.orderListArray yz_objectAtIndex:indexPath.section];
    if (indexPath.row < orderModel.orderItemList.count) {
        id model = [orderModel.orderItemList yz_objectAtIndex:indexPath.row];
        return [YZOrderListTableCell yz_heightForCellWithModel:model
                                                  contentWidth:kScreenWidth];
    }
    return [YZOrderStatusTableCell yz_heightForCellWithModel:orderModel
                                                contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZOrderModel *orderModel = [self.orderListArray yz_objectAtIndex:indexPath.section];
    if (indexPath.row < orderModel.orderItemList.count) {
        YZOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
        [cell yz_configWithModel:[orderModel.orderItemList yz_objectAtIndex:indexPath.row]];
        __weak typeof(self) weakSelf = self;
        cell.pingjiaBlock = ^(YZOrderItemModel *itemModel) {
            [weakSelf gotoPingjiaVC:itemModel];
        };
        return cell;
    }
    YZOrderStatusTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderStatusTableCell yz_cellIdentifiler]];
    [cell yz_configWithModel:orderModel];
    __weak typeof(self) weakSelf = self;
    cell.reSubmitBlock = ^(id orderItem) {
        [weakSelf reSubmitOrder:orderItem];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 3)  else if (indexPath.section == 0) {
    //        [self performSegueWithIdentifier:@"addressVC" sender:nil];
    //    }
    YZOrderModel *orderModel = [self.orderListArray objectAtIndex:indexPath.section];
    if (orderModel) {
        YZOrderDetailViewController *detailVC = [YZOrderDetailViewController new];
        detailVC.orderNumber = orderModel.orderNumber;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:kYZVCDefaultEmptyIcon];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀，订单竟然是空的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (NSMutableArray *)orderListArray {
    if (!_orderListArray) {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
}

@end
