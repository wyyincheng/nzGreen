//
//  YZAgentViewController.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAgentViewController.h"

#import "YZOrderManagerModel.h"

#import "YZShopCarTableCell.h"
#import "YZOrderListTableCell.h"
#import "YZOrderStatusTableCell.h"
#import "YZOrderMangerTableCell.h"
#import "YZOrderSelectTableCell.h"
#import "YZOrderMangerStatusTableCell.h"

#import "YZShopCarViewController.h"
#import "YZBuyNowViewController.h"

@interface YZAgentViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *orderListArray;
@property (nonatomic, strong) NSMutableArray *passListArray;
@property (nonatomic, strong) NSMutableArray *mergeListArray;
@property (nonatomic, assign) BOOL isPassAction;
@property (nonatomic, assign) BOOL isMergeAction;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *passBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomGap;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mergeItem;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBt;
@property (weak, nonatomic) IBOutlet UILabel *allPriceLb;
@property (weak, nonatomic) IBOutlet UIButton *managerBt;

@end

@implementation YZAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    
    self.title = @"订单管理";
    
    self.tableView.backgroundColor = kYZBackViewColor;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshGoods:YES passAction:weakSelf.isPassAction finish:nil];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshGoods:NO passAction:weakSelf.isPassAction finish:nil];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderMangerTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderMangerTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderMangerStatusTableCell class]) bundle:nil] forCellReuseIdentifier:[YZOrderMangerStatusTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderSelectTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderSelectTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZShopCarTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZShopCarTableCell yz_cellIdentifiler]];
    
    self.allPriceLb.hidden = NO;
    self.bottomGap.constant = kSafeAreaBottomHeight;
    
    
    self.passBt = [[UIBarButtonItem alloc] initWithTitle:@"通过"
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(passOrdersAction:)];
    self.mergeItem = [[UIBarButtonItem alloc] initWithTitle:@"合并"
                                                      style:UIBarButtonItemStyleDone
                                                     target:self
                                                     action:@selector(mergeOrdersAction:)];
    self.navigationItem.rightBarButtonItems = @[self.passBt,self.mergeItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshGoods:YES passAction:self.isPassAction finish:nil];
    self.allPriceLb.text = @"¥0";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshGoods:(BOOL)isRefresh passAction:(BOOL)isPassAction finish:(void (^)(void))finishBlock {
    if (self.isMergeAction) {
        [self refreshMergeList:isRefresh];
        return;
    }
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].productAPI getOrderManagerListWithPageIndex:pageIndex
                                                                   type:(isPassAction ? 1 : 0)
                                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                    [MBProgressHUD hideHUD];
                                                                    [weakSelf.tableView.mj_header endRefreshing];
                                                                    [weakSelf.tableView.mj_footer endRefreshing];
                                                                    NSArray *userArray = [YZOrderManagerModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                    if (isRefresh) {
                                                                        if (isPassAction) {
                                                                            weakSelf.passListArray = [userArray mutableCopy];
                                                                        } else { weakSelf.orderListArray = [userArray mutableCopy];}
                                                                    } else {
                                                                        if (isPassAction) { [weakSelf.passListArray addObjectsFromArray:userArray]; } else {
                                                                            [weakSelf.orderListArray  addObjectsFromArray:userArray];}
                                                                    }
                                                                    if ([responseObject yz_integerForKey:@"hasNext"] == 0 && isPassAction == weakSelf.isPassAction) {
                                                                        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                    }
                                                                    [weakSelf.tableView reloadData];
                                                                    if (finishBlock) {
                                                                        finishBlock();
                                                                    }
                                                                } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                    [MBProgressHUD hideHUD];
                                                                    [weakSelf.tableView.mj_header endRefreshing];
                                                                    [weakSelf.tableView.mj_footer endRefreshing];
                                                                    [MBProgressHUD showMessageAuto:error.msg];
                                                                }];
}
- (IBAction)passOrdersAction:(id)sender {
    //    [self caculateAllGoodsPrice];
    if (self.isPassAction) {
        return;
    }
    
    self.selectAllBt.selected = NO;
    
    self.isPassAction = !self.isPassAction;
    __weak typeof(self) weakSelf = self;
    
    if ((self.isPassAction && self.passListArray.count > 0) ||
        (!self.isPassAction && self.orderListArray.count > 0)) {
        
        if (self.isPassAction) {
            self.passBt.title = @"";
            self.allPriceLb.text = @"¥0";
            self.mergeItem.title = @"取消";
            [self.managerBt setTitle:@"通过" forState:UIControlStateNormal];
        } else {
            self.passBt.title = @"通过";
            self.mergeItem.title = @"合并";
        }
        
        weakSelf.allPriceLb.text = @"¥0.00";
        //        weakSelf.passBt.title = self.isPassAction ? @"取消" : @"通过";
        self.bottomGap.constant = self.isPassAction ? -49 : kSafeAreaBottomHeight;
        
        [self refreshGoods:YES passAction:self.isPassAction finish:nil];
        
    } else {
        [MBProgressHUD showMessage:([YZUserCenter shared].showLoadScreen ? @"正在加载" : @"")];
        [self refreshGoods:YES passAction:self.isPassAction finish:^{
            //            weakSelf.passBt.title = self.isPassAction ? @"取消" : @"通过";
            //            weakSelf.bottomGap.constant = self.isPassAction ? -49 : 0;
            if (weakSelf.isPassAction) {
                [self caculateAllGoodsPrice];
                weakSelf.passBt.title = @"";
                weakSelf.mergeItem.title = @"取消";
                [weakSelf.managerBt setTitle:@"通过" forState:UIControlStateNormal];
            } else {
                weakSelf.passBt.title = @"通过";
                weakSelf.mergeItem.title = @"合并";
            }
            
            weakSelf.allPriceLb.text = @"¥0.00";
            //        weakSelf.passBt.title = self.isPassAction ? @"取消" : @"通过";
            weakSelf.bottomGap.constant = weakSelf.isPassAction ? -49 : kSafeAreaBottomHeight;
        }];
    }
}

- (void)gotoPingjiaVC:(YZOrderManagerModel *)itemModel {
    //    NZPingjiaViewController *pingjiaVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"pingjiaVC"];
    //    pingjiaVC.orderModel = itemModel;
    //    [self.navigationController pushViewController:pingjiaVC animated:YES];
}
- (IBAction)mergeOrdersAction:(id)sender {
    //    [self caculateAllGoodsPrice];
    self.selectAllBt.selected = NO;
    
    __weak typeof(self) weakSelf = self;
    if (self.isPassAction) {
        self.isPassAction = NO;
        [MBProgressHUD showMessage:([YZUserCenter shared].showLoadScreen ? @"加载中" : @"")];
        [self refreshGoods:YES passAction:NO finish:^{
            weakSelf.passBt.title = @"通过";
            weakSelf.mergeItem.title = @"合并";
            weakSelf.bottomGap.constant = kSafeAreaBottomHeight;
        }];
    } else if (self.isMergeAction) {
        self.isMergeAction = NO;
        [self refreshGoods:YES passAction:NO finish:^{
            weakSelf.passBt.title = @"通过";
            weakSelf.mergeItem.title = @"合并";
            weakSelf.bottomGap.constant = kSafeAreaBottomHeight;
        }];
    } else {
        self.isMergeAction = YES;
        self.passBt.title = @"";
        self.mergeItem.title = @"取消";
        [self.managerBt setTitle:@"合并" forState:UIControlStateNormal];
        self.bottomGap.constant = -49;
        self.allPriceLb.text = @"¥0";
        [self refreshMergeList:YES];
    }
    
    //    [self performSegueWithIdentifier:@"mergeVC" sender:nil];
}

- (void)refreshMergeList:(BOOL)isRefresh {
    {
        if (!self.isMergeAction) {
            return;
        }
        pageIndex = isRefresh ? 1 : pageIndex + 1;
        if (isRefresh) {
            [self.tableView.mj_footer resetNoMoreData];
        }
        __weak typeof(self) weakSelf = self;
        [[YZNCNetAPI sharedAPI].productAPI getOrderManagerListWithPageIndex:pageIndex
                                                                       type:2
                                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                        [weakSelf.tableView.mj_header endRefreshing];
                                                                        [weakSelf.tableView.mj_footer endRefreshing];
                                                                        NSArray *userArray = [YZOrderManagerModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                        if (isRefresh) {
                                                                            weakSelf.mergeListArray = [userArray mutableCopy];
                                                                        } else {
                                                                            [weakSelf.mergeListArray  addObjectsFromArray:userArray];
                                                                        }
                                                                        if ([responseObject yz_integerForKey:@"hasNext"] == 0) {
                                                                            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                        }
                                                                        [weakSelf.tableView reloadData];
                                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                        [weakSelf.tableView.mj_header endRefreshing];
                                                                        [weakSelf.tableView.mj_footer endRefreshing];
                                                                        [MBProgressHUD showMessageAuto:error.msg];
                                                                    }];
    }
    return;
    
    
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        //        [MBProgressHUD showMessage:@""];
    }
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI getOrderMergeListWithPageIndex:pageIndex
                                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                                  [weakSelf.tableView.mj_footer endRefreshing];
                                                                  NSArray *userArray = [YZOrderManagerItemModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                  weakSelf.mergeListArray = [userArray mutableCopy];
                                                                  if ([responseObject yz_integerForKey:@"hasNext"] == 0) {
                                                                      [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                  }
                                                                  [weakSelf.tableView reloadData];
                                                              } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                  [weakSelf.tableView.mj_header endRefreshing];
                                                                  [weakSelf.tableView.mj_footer endRefreshing];
                                                                  [MBProgressHUD showMessageAuto:error.msg];
                                                              }];
}

- (void)rejectOrder:(YZOrderManagerModel *)order {
    [MBProgressHUD showMessage:@""];
    YZOrderManagerModel *model = order;
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].orderAPI rejectOrderWithOrderNumber:model.orderNumber
                                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                            [MBProgressHUD hideHUD];
                                                            if ([responseObject respondsToSelector:@selector(integerValue)]) {
                                                                model.userOrderStatus = [responseObject integerValue];
                                                            }
                                                            [weakSelf.tableView reloadData];
                                                        } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                            [MBProgressHUD hideHUD];
                                                            [MBProgressHUD showError:error.msg];
                                                        }];
}

- (void)passOrder:(YZOrderManagerModel *)order {
    YZOrderManagerModel *model = order;
    __weak typeof(self) weakSelf = self;
    if (model.canAdopt) {
        [MBProgressHUD showMessage:@""];
        [[YZNCNetAPI sharedAPI].orderAPI adoptOrderWithOrderList:@[order.orderNumber]
                                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                             [MBProgressHUD hideHUD];
                                                             model.userOrderStatus = [[responseObject firstObject] yz_integerForKey:@"userOrderStatus"];
                                                             [weakSelf.tableView reloadData];
                                                         } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                             [MBProgressHUD hideHUD];
                                                             [MBProgressHUD showError:error.msg];
                                                         }];
    } else {
        [self mergeOrdersAction:nil];
        //        [self performSegueWithIdentifier:@"mergeVC" sender:nil];
    }
}

- (void)caculateAllGoodsPrice {
    CGFloat price = 0;
    BOOL allSelected = YES;
    self.selectAllBt.selected = NO;
    
    if (self.isMergeAction) {
        for (YZOrderManagerModel *goodsModel in self.mergeListArray) {
            if (goodsModel.selected) {
                price = price + (goodsModel.selected ? [goodsModel.agentOrderPrice floatValue] : 0);
            }
            if (!goodsModel.selected) {
                allSelected = NO;
            }
        }
        self.selectAllBt.selected = self.mergeListArray.count == 0 ? NO : allSelected;
    } else if (self.isPassAction) {
        for (YZOrderManagerModel *goodsModel in self.passListArray) {
            if (goodsModel.selected) {
                price = price + (goodsModel.selected ? [goodsModel.agentOrderPrice floatValue] : 0);
            }
            if (!goodsModel.selected) {
                allSelected = NO;
            }
        }
        self.selectAllBt.selected = self.passListArray.count == 0 ? NO : allSelected;
    }
    
    [self.tableView reloadData];
    self.allPriceLb.text = [NSString stringWithFormat:@"¥%.2f",price];
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isPassAction) {
        return self.passListArray.count;
    }
    if (self.isMergeAction) {
        return self.mergeListArray.count;
    }
    return self.orderListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isMergeAction) {
        YZOrderManagerModel *orderModel = [self.mergeListArray yz_objectAtIndex:section];
        return orderModel.orderItemList.count + 1;
    }
    
    YZOrderManagerModel *orderModel = self.isPassAction ? [self.passListArray yz_objectAtIndex:section] : [self.orderListArray yz_objectAtIndex:section];
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
    
    if (self.isMergeAction) {
        YZOrderManagerModel *orderModel = [self.passListArray yz_objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            return  [YZOrderSelectTableCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
        } else if (indexPath.row < orderModel.orderItemList.count + 1) {
            return  [YZOrderListTableCell yz_heightForCellWithModel:[orderModel.orderItemList yz_objectAtIndex:(indexPath.row - 1)] contentWidth:kScreenWidth];
        }
    }
    
    YZOrderManagerModel *orderModel = self.isPassAction ? [self.passListArray yz_objectAtIndex:indexPath.section] : [self.orderListArray yz_objectAtIndex:indexPath.section];
    
    if (self.isPassAction) {
        if (indexPath.row == 0) {
            return  [YZOrderSelectTableCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
        } else if (indexPath.row < orderModel.orderItemList.count + 1) {
            return  [YZOrderListTableCell yz_heightForCellWithModel:[orderModel.orderItemList yz_objectAtIndex:(indexPath.row - 1)] contentWidth:kScreenWidth];
        }
    } else {
        if (indexPath.row < orderModel.orderItemList.count) {
            return  [YZOrderListTableCell yz_heightForCellWithModel:[orderModel.orderItemList yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
        }
        return [YZOrderStatusTableCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    if (self.isMergeAction) {
        YZShopCarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZShopCarTableCell yz_cellIdentifiler]];
        
        YZOrderManagerModel *orderModel = [self.mergeListArray yz_objectAtIndex:indexPath.section];
        if (indexPath.row == 0) {
            YZOrderSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderSelectTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:orderModel];
            cell.caculateBlock = ^(YZOrderManagerModel *order) {
                [weakSelf caculateAllGoodsPrice];
            };
            return cell;
        } else if (indexPath.row < orderModel.orderItemList.count + 1) {
            YZOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:[orderModel.orderItemList yz_objectAtIndex:(indexPath.row - 1)]];
            return cell;
        }
        
        return cell;
    }
    
    
    YZOrderManagerModel *orderModel = self.isPassAction ? [self.passListArray yz_objectAtIndex:indexPath.section] : [self.orderListArray yz_objectAtIndex:indexPath.section];
    
    if (self.isPassAction) {
        if (indexPath.row == 0) {
            YZOrderSelectTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderSelectTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:orderModel];
            cell.caculateBlock = ^(YZOrderManagerModel *order) {
                [weakSelf caculateAllGoodsPrice];
            };
            return cell;
        } else if (indexPath.row < orderModel.orderItemList.count + 1) {
            YZOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:[orderModel.orderItemList yz_objectAtIndex:(indexPath.row - 1)]];
            return cell;
        }
    } else {
        if (indexPath.row < orderModel.orderItemList.count) {
            YZOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:[orderModel.orderItemList yz_objectAtIndex:indexPath.row]];
            return cell;
        } else {
            YZOrderStatusTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderStatusTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:orderModel];
            
            cell.reSubmitBlock = ^(id orderItem) {
                [weakSelf passOrder:orderItem];
            };
            cell.rejectBlock = ^(id orderItem) {
                [weakSelf rejectOrder:orderItem];
            };
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YZOrderManagerModel *orderModel = self.isPassAction ? [self.passListArray yz_objectAtIndex:indexPath.section] : [self.orderListArray yz_objectAtIndex:indexPath.section];
    if (orderModel) {
        if (self.isMergeAction) {
            //            YZOrderManagerItemModel *item = [self.mergeListArray yz_objectAtIndex:indexPath.row];
            //            item.selected = !item.selected;
            //            [self caculateAllGoodsPrice];
            YZOrderManagerModel *orderModel = [self.mergeListArray yz_objectAtIndex:indexPath.section];
            orderModel.selected = !orderModel.selected;
            [self caculateAllGoodsPrice];
        } else if (self.isPassAction) {
            orderModel.selected = !orderModel.selected;
            [self caculateAllGoodsPrice];
        } else {
            return;
//            NZOrderDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"orderDetailVC"];
//            detailVC.orderNumber = orderModel.orderNumber;
//            detailVC.orderType = OrderTyp_Agent;
//            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_shoppingcar_empty"];
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

- (NSMutableArray *)passListArray {
    if (!_passListArray) {
        _passListArray = [NSMutableArray array];
    }
    return _passListArray;
}

- (NSMutableArray *)mergeListArray {
    if (!_mergeListArray) {
        _mergeListArray = [NSMutableArray array];
    }
    return _mergeListArray;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"buynowVC"]) {
//        YZBuyNowViewController *vc = segue.destinationViewController;
//        vc.goodsDict = sender;
//    } else if ([segue.identifier isEqualToString:@"passVC"]) {
//        YZShopCarViewController *vc = [[YZShopCarViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        //        NSMutableArray *array = [NSMutableArray array];
//        //        for (YZOrderManagerModel *order in self.orderListArray) {
//        //            if (order.canAdopt) {
//        //                for (YZOrderManagerItemModel *item in order.orderItemList) {
//        //                    [array addObject:item];
//        //                }
//        //            }
//        //        }
//        //        vc.goodsArray = [array mutableCopy];
//        vc.type = ShoppingCartType_Pass;
//    }
//}

- (IBAction)selectAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.isMergeAction) {
        for (YZOrderManagerModel *order in self.mergeListArray) {
            order.selected = sender.selected;
        }
    } else if (self.isPassAction) {
        for (YZOrderManagerModel *order in self.passListArray) {
            order.selected = sender.selected;
        }
    }
    self.selectAllBt.selected = sender.selected;
    [self caculateAllGoodsPrice];
}
- (IBAction)passAction:(id)sender {
    
    
    if (self.isMergeAction) {
        
        NSMutableArray *mArray = [NSMutableArray array];
        for (YZOrderManagerModel *order in self.mergeListArray) {
            if (order.selected) {
                [mArray addObject:order];
            }
        }
        if (mArray.count == 0) {
            [MBProgressHUD showMessageAuto:@"请选择需要合并的商品"];
            return;
        }
        
        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        [tempDict setValue:mArray forKey:@"list"];
        [tempDict setValue:@(ShoppingCartType_Merge) forKey:@"type"];
        [self gotoViewController:NSStringFromClass([YZBuyNowViewController class])
                     lauchParams:@{kYZLauchParams_GoodsDict:tempDict}];
        
        return;
    }
    
    NSMutableArray *marray = [NSMutableArray array];
    for (YZOrderManagerModel *order in self.passListArray) {
        if (order.selected) {
            [marray addObject:order];
        }
    }
    if (marray.count == 0 ) {
        [MBProgressHUD showError:@"请选择需要通过的订单"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].orderAPI passOrdersByAgentWithOrders:marray
                                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                             [MBProgressHUD hideHUD];
#warning for yc 通过后重新刷新列表还是仅将老数据移除
                                                             [weakSelf refreshGoods:YES passAction:YES finish:nil];
                                                             //                                                              for (YZOrderManagerModel *order in marray) {
                                                             //                                                                  [weakSelf.passListArray removeObject:order];
                                                             //                                                              }
                                                             //                                                              [weakSelf.tableView reloadData];
                                                         } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                             [MBProgressHUD hideHUD];
                                                             [MBProgressHUD showSuccess:error.msg];
                                                         }];
}

@end
