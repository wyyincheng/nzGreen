//
//  YZBalanceViewController.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBalanceViewController.h"

#import "UINavigationBar+Alpha.h"
#import "YZBalanceTableCell.h"
#import "YZBalanceLogModel.h"

@interface YZBalanceViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerBgView;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) UIView *headerView;

@end

@implementation YZBalanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    
    self.tableView.backgroundColor = kYZBackViewColor;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshGoods:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshGoods:NO];
    }];
    
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZBalanceTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZBalanceTableCell yz_cellIdentifiler]];
    
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.tableView addSubview:self.headerBgView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    //去掉透明后导航栏下边的黑边
    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self refreshGoods:YES];
}

- (void)refreshGoods:(BOOL)isRefresh {
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI getAccountLogListWithPageIndex:pageIndex
                                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                                  [weakSelf.tableView.mj_footer endRefreshing];
                                                                  NSArray *userArray = [YZBalanceLogModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                  if (isRefresh) {
                                                                      weakSelf.array = [userArray mutableCopy];
                                                                  } else {
                                                                      [weakSelf.array  addObjectsFromArray:userArray];
                                                                  }
                                                                  if (weakSelf.array.count > 0) {
                                                                      weakSelf.tableView.tableHeaderView = self.headerView;
                                                                  }
                                                                  if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.array.count > 0) {
                                                                      [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                  }
                                                                  [weakSelf.tableView reloadData];
                                                              } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                                  [weakSelf.tableView.mj_footer endRefreshing];
                                                                  [MBProgressHUD showMessageAuto:error.msg];
                                                              }];
}

#pragma mark - action
- (void)deleteAccountLog:(YZBalanceLogModel *)model {
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI delAccountLogWithLogId:model.logId
                                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [weakSelf.array removeObject:model];
                                                       [weakSelf.tableView reloadData];
                                                   } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                       [MBProgressHUD showError:error.msg];
                                                   }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YZBalanceTableCell yz_heightForCellWithModel:[self.array yz_objectAtIndex:indexPath.row]
                                            contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZBalanceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZBaseTableViewCell yz_cellIdentifiler]];
    [cell yz_configWithModel:[self.array yz_objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    YZBalanceLogModel *model = [self.array yz_objectAtIndex:indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              [weakSelf deleteAccountLog:model];
                                                                          }];
    return @[deleteAction];
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:kYZVCDefaultEmptyIcon];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀，账户竟然是空的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//jump
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    if ([segue.identifier isEqualToString:@"buynowVC"]) {
    //        NZBuyNowViewController *vc = segue.destinationViewController;
    //        vc.productArray = sender;
    //    }
}

#pragma mark - property
- (NSMutableArray *)array {
    if (!_array) {
        NSMutableArray *marray = [NSMutableArray array];
        _array = marray;
    }
    return _array;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35+60)];
        _headerView.backgroundColor = [UIColor colorWithHex:0x000000];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        title.text = @"总账户（金币）";
        title.textAlignment = NSTextAlignmentCenter;
        title.textColor = [UIColor colorWithHex:0x999999];
        title.font = [UIFont systemFontOfSize:14];
        [_headerView addSubview:title];
        
        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 50)];
        priceLb.textAlignment = NSTextAlignmentCenter;
        priceLb.textColor = [UIColor whiteColor];
        priceLb.font = [UIFont systemFontOfSize:36];
        priceLb.text = [NSString stringWithFormat:@"%.2f",[[YZUserCenter shared].accountInfo.balance floatValue]];
        [_headerView addSubview:priceLb];
    }
    return _headerView;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y < 0) {
        CGRect rect = self.headerBgView.frame;
        rect.origin.y = offset.y;
        rect.size.height = - offset.y;
        self.headerBgView.frame = rect;   // 下拉背景view
    } else if (offset.y > 54) {
        //        self.title = @"liu"
    }
    // 显示完整的个人中心界面显示导航栏渐变
    if ([self.navigationController.navigationBar bgAlpha]) {
        CGFloat offsetY = offset.y;
        [self setNavigationBarAlpha:offsetY];
    }
}

// 设置NavigationBar alpha color
- (void)setNavigationBarAlpha:(CGFloat)offsetY {
    //    UIColor *color = [UIColor colorWithHex:0x7384A2];
    //    if (offsetY <= 0.0) {
    //        [self.navigationController.navigationBar setAlphaBackgroundColor:[color colorWithAlphaComponent:0]];
    //    } else {
    //        CGFloat alpha = MIN(1, 1 - ((64 - offsetY) / 64));
    //        [self.navigationController.navigationBar setAlphaBackgroundColor:[color colorWithAlphaComponent:alpha]];
    //    }
}

- (UIImageView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _headerBgView.contentMode = UIViewContentModeScaleToFill;
        [_headerBgView setBackgroundColor:[UIColor colorWithHex:0x000000]];
    }
    return _headerBgView;
}

@end
