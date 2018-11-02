//
//  YZShopCarViewController.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZShopCarViewController.h"

#import "YZOrderManagerModel.h"
#import "YZShopCarTableCell.h"
#import "YZProductModel.h"

@interface YZShopCarViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBt;
@property (weak, nonatomic) IBOutlet UILabel *selectAllLb;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;
@property (nonatomic, strong) NSMutableArray *goodsArray;

@end

@implementation YZShopCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    
    self.title = @"购物车";
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZShopCarTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZShopCarTableCell yz_cellIdentifiler]];
    
    NSString *name = nil;
    switch (self.type) {
        case ShoppingCartType_Pass:
            name = @"订单通过";
            break;
        case ShoppingCartType_Merge:
            name = @"合并";
            self.title = @"订单合并";
            break;
        default:
            name = @"购买";
            break;
    }
    [self.confirmBt setTitle:name forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshGoods:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kYZNotification_HiddenKeyBoard
                                                        object:nil];
    if (self.type == ShoppingCartType_Default) {
        [self updateShoppingCart:nil];
    }
}

- (void)updateShoppingCart:(void(^)(BOOL success,NZError *error))finishBlock {
    
    __block NSInteger goodsCount = self.goodsArray.count;
    
    [[YZNCNetAPI sharedAPI].productAPI updateShoppingCarGoods:self.goodsArray
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          goodsCount = goodsCount - 1;
                                                          NSLog(@"更新购物车success: %@",responseObject);
                                                          if (finishBlock && goodsCount == 0) {
                                                              finishBlock(YES,nil);
                                                          }
                                                      } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                          goodsCount = goodsCount - 1;
                                                          NSLog(@"更新购物车error: %@",error);
                                                          if (finishBlock && goodsCount == 0) {
                                                              finishBlock(NO,error);
                                                          }
                                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealWithResult:(NSArray *)array isRefresh:(BOOL)isRefresh hasNext:(BOOL)hasNext {
    //#warning for yc 网络重试成本太大，无法确定到底需要请求几次，建议新增接口
    //    NSMutableArray *tempArray = [NSMutableArray array];
    //    for (NZOrderManagerModel *order in array) {
    //        if (self.type == ShoppingCartType_Pass && order.canAdopt) {
    //            [tempArray addObjectsFromArray:order.orderItemList];
    //        } else if (self.type == ShoppingCartType_Merge) {
    //            for (NZOrderManagerItemModel *item in order.orderItemList) {
    //                if (item.canMerge) {
    //                    [tempArray addObject:item];
    //                }
    //            }
    //        }
    //    }
    
    if (isRefresh) {
        self.goodsArray = array.count > 0 ? [array mutableCopy] : nil;
    } else {
        if (array.count > 0) {
            [self.goodsArray  addObjectsFromArray:array];
        }
    }
    if (!hasNext && self.goodsArray.count > 0) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}

- (void)refreshGoods:(BOOL)isRefresh {
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [MBProgressHUD showMessage:@""];
    }
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    if (self.type == ShoppingCartType_Pass) {
        
        [[YZNCNetAPI sharedAPI].productAPI getOrderManagerListWithPageIndex:pageIndex
                                                                       type:1
                                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                        [weakSelf.tableView.mj_header endRefreshing];
                                                                        [weakSelf.tableView.mj_footer endRefreshing];
                                                                        NSArray *userArray = [YZOrderManagerItemModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                        [weakSelf dealWithResult:userArray
                                                                                       isRefresh:isRefresh
                                                                                         hasNext:([[responseObject yz_numberForKey:@"hasNext"] boolValue])];
                                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                        [weakSelf.tableView.mj_header endRefreshing];
                                                                        [weakSelf.tableView.mj_footer endRefreshing];
                                                                        [MBProgressHUD showMessageAuto:error.msg];
                                                                    }];
        
        return;
    }
    
    if (self.type == ShoppingCartType_Merge) {
        [[YZNCNetAPI sharedAPI].productAPI getOrderMergeListWithPageIndex:pageIndex
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                      [weakSelf.tableView.mj_header endRefreshing];
                                                                      [weakSelf.tableView.mj_footer endRefreshing];
                                                                      NSArray *userArray = [YZOrderManagerItemModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                      [weakSelf dealWithResult:userArray
                                                                                     isRefresh:isRefresh
                                                                                       hasNext:([[responseObject yz_numberForKey:@"hasNext"] boolValue])];
                                                                  } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                      [weakSelf.tableView.mj_header endRefreshing];
                                                                      [weakSelf.tableView.mj_footer endRefreshing];
                                                                      [MBProgressHUD showMessageAuto:error.msg];
                                                                  }];
        return;
    }
    
    [[YZNCNetAPI sharedAPI].productAPI getShoppinCartListWithPageIndex:pageIndex
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                   [weakSelf.tableView.mj_header endRefreshing];
                                                                   [weakSelf.tableView.mj_footer endRefreshing];
                                                                   NSArray *userArray = [YZProductModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                                   if (isRefresh) {
                                                                       weakSelf.goodsArray = [userArray mutableCopy];
                                                                   } else {
                                                                       [weakSelf.goodsArray  addObjectsFromArray:userArray];
                                                                   }
                                                                   if ([responseObject yz_numberForKey:@"hasNext"] == 0 && weakSelf.goodsArray.count > 0) {
                                                                       [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                                   }
                                                                   [weakSelf caculateAllGoodsPrice];
                                                                   [weakSelf.tableView reloadData];
                                                               } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                   [weakSelf.tableView.mj_header endRefreshing];
                                                                   [weakSelf.tableView.mj_footer endRefreshing];
                                                                   [MBProgressHUD showMessageAuto:error.msg];
                                                               }];
}

#pragma mark - action
- (IBAction)buyAction:(id)sender {
    
    switch (self.type) {
        case ShoppingCartType_Pass: {
            NSMutableArray *mArray = [NSMutableArray array];
            for (YZOrderManagerItemModel *product in self.goodsArray) {
                if (product.selected) {
                    [mArray addObject:product];
                }
            }
            if (mArray.count == 0) {
                [MBProgressHUD showMessageAuto:@"请选择需要通过的商品"];
                return;
            }
            
            __weak typeof(self) weakSelf = self;
            [[YZNCNetAPI sharedAPI].orderAPI passOrdersByAgentWithOrders:mArray
                                                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                     [MBProgressHUD showSuccess:@"订单通过成功"];
                                                                     [weakSelf.goodsArray removeObjectsInArray:mArray];
                                                                     [weakSelf.tableView reloadData];
                                                                 } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                     [MBProgressHUD showError:error.msg];
                                                                 }];
        }
            break;
        case  ShoppingCartType_Merge: {
            NSMutableArray *mArray = [NSMutableArray array];
            for (YZOrderManagerItemModel *product in self.goodsArray) {
                if (product.selected) {
                    [mArray addObject:product];
                }
            }
            if (mArray.count == 0) {
                [MBProgressHUD showMessageAuto:@"请选择需要合并的商品"];
                return;
            }
            
#warning for yc
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
            [tempDict setValue:mArray forKey:@"list"];
            [tempDict setValue:@(ShoppingCartType_Merge) forKey:@"type"];
            [self performSegueWithIdentifier:@"buynowVC" sender:tempDict];
        }
            break;
        default: {
            
            [self updateShoppingCart:^(BOOL success, NZError *error) {
                if (success) {
                    NSMutableArray *mArray = [NSMutableArray array];
                    for (YZProductModel *product in self.goodsArray) {
                        if (product.selected && product.productNumber > 0) {
                            [mArray addObject:product];
                        }
                    }
                    if (mArray.count == 0) {
                        [MBProgressHUD showMessageAuto:@"请选择需要结算的商品"];
                        return;
                    }
                    NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
                    [tempDict setValue:mArray forKey:@"list"];
                    [tempDict setValue:@(ShoppingCartType_Default) forKey:@"type"];
                    [self performSegueWithIdentifier:@"buynowVC" sender:tempDict];
                } else if (error) {
                    [MBProgressHUD showError:error.msg];
                }
            }];
            
        }
            break;
    }
}

- (IBAction)selectAllAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.selectAllBt.selected = sender.selected;
    self.selectAllLb.textColor = sender.selected ? kTextColorGreen : kTextColor999;
    [self refreshAllGoodsSelectStatus:sender.selected];
    [self caculateAllGoodsPrice];
}

- (void)refreshAllGoodsSelectStatus:(BOOL)selected {
    
    switch (self.type) {
        case ShoppingCartType_Pass:
        case ShoppingCartType_Merge: {
            {
                for (YZOrderManagerItemModel *goodsModel in self.goodsArray) {
                    goodsModel.selected = selected;
                }
            }
        }
        default: {
            for (YZProductModel *goodsModel in self.goodsArray) {
                goodsModel.selected = selected;
            }
        }
            break;
    }
    
    [self caculateAllGoodsPrice];
    [self.tableView reloadData];
}

- (void)caculateAllGoodsPrice {
    CGFloat price = 0;
    BOOL allSelected = YES;
    
    switch (self.type) {
        case ShoppingCartType_Pass:
        case ShoppingCartType_Merge: {
            for (YZOrderManagerItemModel *goodsModel in self.goodsArray) {
                if (goodsModel.selected) {
                    price = price + (goodsModel.selected ? goodsModel.productNumber  * [goodsModel.price floatValue]: 0);
                }
                if (!goodsModel.selected) {
                    allSelected = NO;
                }
            }
        }
            break;
        default: {
            //            NSInteger allWeight = 0;
            for (YZProductModel *goodsModel in self.goodsArray) {
                price = price + (goodsModel.selected ? goodsModel.productNumber  * [goodsModel.sellingPrice floatValue] : 0);
                if (!goodsModel.selected) {
                    allSelected = NO;
                }
            }
        }
            break;
    }
    [self.tableView reloadData];
    self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",price];
    self.selectAllBt.selected = self.goodsArray.count == 0 ? NO : allSelected;
}

- (void)deleteShoppingCarGoods:(YZProductModel *)model {
    __weak typeof(self) weakSelf = self;
    NSArray *array = [NSArray arrayWithObject:model.shoppingCartId];
    [[YZNCNetAPI sharedAPI].productAPI delShoppingCarGoods:array
                                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [MBProgressHUD showSuccess:@"删除成功"];
                                                       [weakSelf.goodsArray removeObject:model];
                                                       [weakSelf.tableView reloadData];
                                                   } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                       [MBProgressHUD showError:error.msg];
                                                   }];
}

#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self.goodsArray yz_objectAtIndex:indexPath.row];
    id model = (indexPath.row == self.goodsArray.count - 1 ? object : nil);
    return [YZShopCarTableCell yz_heightForCellWithModel:model
                                            contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:[YZShopCarTableCell yz_cellIdentifiler]
                                           forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    
    switch (self.type) {
        case ShoppingCartType_Pass:
        case ShoppingCartType_Merge: {
            YZOrderManagerItemModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
            [(YZShopCarTableCell *)cell yz_configWithModel:model];
            ((YZShopCarTableCell *)cell).refreshPriceBlock = ^{
                [weakSelf caculateAllGoodsPrice];
            };
        }
        default: {
            YZProductModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
            [(YZShopCarTableCell *)cell yz_configWithModel:model];
            ((YZShopCarTableCell *)cell).refreshPriceBlock = ^{
                [weakSelf caculateAllGoodsPrice];
            };
        }
            break;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.type == ShoppingCartType_Default) {
        YZProductModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"detailVC" sender:model.productId];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    YZProductModel *model = [self.goodsArray yz_objectAtIndex:indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              [weakSelf deleteShoppingCarGoods:model];
                                                                          }];
    return @[deleteAction];
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_shoppingcar_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀，购物车竟然是空的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//jump
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //TODO:
//    if ([segue.identifier isEqualToString:@"buynowVC"]) {
//        YZBuyNowViewController *vc = segue.destinationViewController;
//        vc.goodsDict = sender;
//    } else if ([segue.identifier isEqualToString:@"detailVC"]) {
//        NZGoodsDetailViewController *vc = segue.destinationViewController;
//        vc.goodsId = sender;
//    }
}

#pragma mark - property
- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        NSMutableArray *marray = [NSMutableArray array];
        _goodsArray = marray;
    }
    return _goodsArray;
}

@end
