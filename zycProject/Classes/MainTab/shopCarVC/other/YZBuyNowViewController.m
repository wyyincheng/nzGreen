//
//  YZBuyNowViewController.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBuyNowViewController.h"

#import <WXApi.h>

#import "YZGoodsModel.h"
#import "YZAccountModel.h"
#import "YZAddressModel.h"
#import "YZProductModel.h"
#import "YZUserOrderDTOModel.h"
#import "YZOrderManagerModel.h"
#import "YZReSubmitOrderModel.h"

#import "YZProductTableCell.h"
#import "YZAddressTableCell.h"
#import "YZProductPayTableCell.h"
#import "YZDeliverTypeTableCell.h"
#import "YZDeliverPriceTableCell.h"
#import "YZProductAddressTableCell.h"

#import "YZAddressViewController.h"
#import "YZBuySuccessViewController.h"

/*
 支付：内购，第三方支付（微信，支付宝，银联 applepay）
 第三方流程：总之一句话将一些参数加密签名以后发送给第三方支付app发起支付
 
 当用户触发购买按钮-app向webserver发送相应支付参数（微信支付参数等）
 获取appserver支付参数--跳转到相应支付平台调用发起支付
 第三方支付平台向支付服务器发起支付请求
 第三方支付服务器通知第三方客户端支付结果，也会将支付结果通知给appserver
 第三方支付客户端将回调结果发送给app（第三方支付回调有时候不准我们必须要向我们支付的服务器询问本次结果）
 步骤包含服务器
 
 第一步：配置项目
 第二步：统一下单包含二次签名（服务器）
 第三步：客户端接收服务器参数发起微信支付
 第四步：支付完成客户端向服务器询问支付结果
 
 */
#define MCH_ID @"1509799731"//商户号
#define API_KEY @"69045bee05427d9497e346dd9db916c9"//密钥

//统一下单接口
#define HTTP @"https://api.mch.weixin.qq.com/pay/unifiedorder"//

@interface YZBuyNowViewController () <UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource> {
    NSArray * _DeliveTypes;
    //    BOOL isOrderMerge;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UIButton *buyAction;
@property (assign, nonatomic) NSInteger deliveTypeCode;
@property (nonatomic, strong) YZAddressModel *addressModel;
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, assign) NSInteger deliverPrice;
@property (nonatomic, assign) CGFloat allPrice;
@property (nonatomic, strong) NSMutableArray *mergeList;
@property (nonatomic, assign) BuyType buyType;
@property (nonatomic, strong) YZReSubmitOrderModel *reSubmitOrder;
@property (nonatomic, strong) YZGoodsFreightModel *freightModel;
@property (nonatomic, strong) NSMutableArray *payGoodsArray;

@property (nonatomic, strong) NSDictionary *goodsDict;
@property (nonatomic, strong) YZGoodsModel *goodsModel;

@end

@implementation YZBuyNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    _DeliveTypes = [YZUserCenter shared].userInfo.userType == UserType_Normal ? @[@"自收",@"代收"] : @[@"购买",@"合并"];
    
    _deliveTypeCode = 1;
    
    self.view.backgroundColor = [UIColor colorWithHex:0xF4F4F4];
    self.tableView.backgroundColor = [UIColor colorWithHex:0xF4F4F4];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZProductAddressTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZProductAddressTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZProductPayTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZProductPayTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZProductTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZProductTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZDeliverTypeTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZDeliverTypeTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZDeliverPriceTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZDeliverPriceTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZAddressTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZAddressTableCell yz_cellIdentifiler]];
    
    self.tableView.tableFooterView = [UIView new];
    
    //    if (self.productArray.count == 0 && self.goodsModel) {
    //        self.productArray = [NSMutableArray arrayWithObject:self.goodsModel];
    //    }
    
    self.productArray = [[self.goodsDict yz_arrayForKey:@"list"] mutableCopy];
    //    isOrderMerge = ([self.goodsDict yz_integerForKey:@"type"] == BuyType_Merge);
    self.buyType = (BuyType)[self.goodsDict yz_integerForKey:@"type"];
    if (self.buyType == BuyType_ReSubmit) {
        [MBProgressHUD showMessage:@""];
        [[YZNCNetAPI sharedAPI].orderAPI getReSubmitOrderInfoWithOrderNumber:[self.goodsDict yz_stringForKey:@"orderNumber"] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.reSubmitOrder = [YZReSubmitOrderModel yz_objectWithKeyValues:responseObject];
            self.addressModel = self.reSubmitOrder.userAddress;
            self.freightModel = self.reSubmitOrder.productFreight;
            self.productArray = [self.reSubmitOrder.productOrderList mutableCopy];
            [self caculateAllGoodsPrice];
            [self.tableView reloadData];
        } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
            [MBProgressHUD showError:error.msg];
        }];
    } else {
        if (self.buyType == BuyType_Merge) {
            self.mergeList = [[self.goodsDict yz_arrayForKey:@"list"] mutableCopy];
            [self.productArray removeAllObjects];
            for (YZOrderManagerModel *order in self.mergeList) {
                for (YZOrderManagerItemModel *item in order.orderItemList) {
                    [self.productArray addObject:item];
                }
            }
        }
        [self getDefaultAddress];
    }
    
    if (self.buyType == BuyType_Merge) {
        _DeliveTypes = @[@"自收"];
    }
    
    //    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    //    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithHex:0x141414];
    //
    //    [self setStatusBarBackgroundColor:[UIColor colorWithHex:0x141414]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weixinpaySuccess) name:kYZWeixinPaySuccessPushFlag
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weixinpayFaliure) name:kYZWeixinPayFaliurePushFlag
                                               object:nil];
}

- (void)weixinpaySuccess {
    //    [MBProgressHUD hideHUD];
    [self payOrderAction:self.payGoodsArray];
    //    [MBProgressHUD showSuccess:@"支付成功"];
}

- (void)weixinpayFaliure {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"支付失败"];
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

//- (BOOL)prefersStatusBarHidden {
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.buyType != BuyType_ReSubmit) {
        [self caculateAllGoodsPrice];
        [self.tableView reloadData];
    }
    
    [[YZNCNetAPI sharedAPI].userAPI getUserInfoWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [YZUserCenter shared].accountInfo = [YZAccountModel yz_objectWithKeyValues:responseObject];
    } failure:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)getDefaultAddress {
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI getDefaultAddressWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (!weakSelf.addressModel) {
            weakSelf.addressModel = [YZAddressModel yz_objectWithKeyValues:responseObject];
            if (weakSelf.addressModel) {
                [weakSelf.tableView reloadData];
            }
        }
    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
        NSLog(@"获取默认地址失败 ： %@",error);
    }];
}

- (IBAction)buyNowAction:(id)sender {
    if (!self.addressModel) {
        [MBProgressHUD showMessageAuto:@"请选择收货地址"];
        return;
    }

    NSMutableArray *mArray = [NSMutableArray array];
    
    switch (self.buyType) {
        case BuyType_Merge: {
            for (YZOrderManagerModel *orderModel in self.mergeList) {
                if (orderModel.orderNumber) {
                    [mArray addObject:orderModel.orderNumber];
                }
            }
        }
            break;
            
        case BuyType_ReSubmit: {
            for (YZProductModel *model in self.productArray) {
                if (model.productId && model.productNumber) {
                    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
                    [mdict setValue:model.productId forKey:@"productId"];
                    [mdict setValue:@(model.productNumber) forKey:@"productNumber"];
                    [mArray addObject:mdict];
                }
            }
        }
            break;
            
        case BuyType_GoodsDetail: {
            if (self.goodsModel.goodsId && self.goodsModel.count) {
                NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
                [mdict setValue:self.goodsModel.goodsId forKey:@"productId"];
                [mdict setValue:@(self.goodsModel.count) forKey:@"productNumber"];
                [mArray addObject:mdict];
            }
        }
            
        default: {
            for (YZProductModel *model in self.productArray) {
                if (model.shoppingCartId) {
                    [mArray addObject:model.shoppingCartId];
                }
            }
        }
            break;
    }
    
    if (mArray.count == 0) {
        [MBProgressHUD showMessageAuto:@"请选择你要支付的商品"];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    
    
    if (![YZUserCenter shared].hasReviewed) {
        if ([WXApi isWXAppInstalled]) {
#warning for yc 发起微信支付
            self.payGoodsArray = [NSMutableArray arrayWithArray:mArray];
            [self WxPay];
        } else {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"本App需使用微信支付"];
        }
        return;
    }
    
    [self payOrderAction:mArray];
    
}

- (void)payOrderAction:(NSMutableArray *)mArray {
    __weak typeof(self) weakSelf = self;
    
    switch (self.buyType) {
        case BuyType_Merge: {
#warning for yc 下单接口要不要调整
            [[YZNCNetAPI sharedAPI].orderAPI mergeOrdersByAgentWithOrders:mArray
                                                                addressId:self.addressModel.addressId
                                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                      YZUserOrderDTOModel *userOrder = [YZUserOrderDTOModel yz_objectWithKeyValues:responseObject];
                                                                      [weakSelf gotoViewController:NSStringFromClass([YZBuySuccessViewController class])
                                                                                       lauchParams:@{kYZLauchParams_UserOrder:userOrder}];
                                                                  } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                      [MBProgressHUD showError:error.msg];
                                                                  }];
            
            return;
        }
            break;
            
        case BuyType_ReSubmit:
        case BuyType_GoodsDetail: {
            [[YZNCNetAPI sharedAPI].productAPI payOrderWithProductOrderList:mArray
                                                               deliveryMode:self.deliveTypeCode
                                                                    address:self.addressModel.addressId
                                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                        YZUserOrderDTOModel *userOrder = [YZUserOrderDTOModel yz_objectWithKeyValues:responseObject];
                                                                        [weakSelf gotoViewController:NSStringFromClass([YZBuySuccessViewController class])
                                                                                         lauchParams:@{kYZLauchParams_UserOrder:userOrder}];
                                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                        [MBProgressHUD showError:error.msg];
                                                                    }];
            return;
        }
            break;
            
        default: {
            [[YZNCNetAPI sharedAPI].productAPI payShoppingCartWithList:mArray
                                                          deliveryMode:self.deliveTypeCode
                                                               address:self.addressModel.addressId
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                   YZUserOrderDTOModel *userOrder = [YZUserOrderDTOModel yz_objectWithKeyValues:responseObject];
                                                                   [weakSelf gotoViewController:NSStringFromClass([YZBuySuccessViewController class])
                                                                                    lauchParams:@{kYZLauchParams_UserOrder:userOrder}];
                                                               } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                   [MBProgressHUD showError:error.msg];
                                                               }];
            return;
        }
            break;
    }
}

- (NSInteger)allGoodsRowCount {
    return (self.goodsModel ? 1 : 0 + self.productArray.count);
}

- (NSString *)caculateAllGoodsPrice {
    CGFloat price = 0;
    NSInteger allWeight = 0;
    
    switch (self.buyType) {
        case BuyType_Merge: {
            for (YZOrderManagerItemModel *item in self.productArray) {
                self.freightModel = item.productFreight;
                price = price + item.productNumber * [item.productTotalPrice floatValue];
                allWeight = allWeight + item.productNumber * item.weight;
            }
            break;
        }
            
        case BuyType_ReSubmit: {
#warning for yc 重新发起订单字段于下单界面对不起来，无价格信息
            for (YZProductModel *goodsModel in self.productArray) {
                price = price + goodsModel.productNumber * [goodsModel.sellingPrice floatValue];
                allWeight = allWeight + goodsModel.productNumber * goodsModel.weight;
            }
            break;
        }
            
        case BuyType_GoodsDetail: {
            self.freightModel = self.goodsModel.productFreight;
            price = self.goodsModel.count * [self.goodsModel.sellingPrice floatValue];
            allWeight = allWeight + self.goodsModel.count * self.goodsModel.weight;
            break;
        }
            
        default: {
            for (YZProductModel *goodsModel in self.productArray) {
                self.freightModel = goodsModel.productFreight;
                price = price + goodsModel.productNumber * [goodsModel.sellingPrice floatValue];
                allWeight = allWeight + goodsModel.productNumber * goodsModel.weight;
            }
        }
            break;
    }
    
    if (self.deliveTypeCode == 1) {
        if (self.freightModel.productWeight > 0) {
#warning for yc 重量 = 0 于 价格的关系 ？
            //            if (allWeight > 0) {
            self.deliverPrice = (allWeight < self.freightModel.productWeight ? self.freightModel.freight : allWeight * self.freightModel.freight / self.freightModel.productWeight);
            //            }
            price = price + self.deliverPrice;
        }
    } else {
        if (self.freightModel.productWeight > 0) {
            self.deliverPrice = (allWeight * self.freightModel.freight / self.freightModel.productWeight);
            price = price + self.deliverPrice;
        }
    }
    
    self.allPrice = price;
    self.priceLb.text = [NSString stringWithFormat:@"合计：¥%.2f",price];
    [self.tableView reloadData];
    return self.priceLb.text;
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return ([self allGoodsRowCount] + 1);
        case 2:
            return 1;
        case 3:
            return 1;
        default:
            return 0;
    }
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
    switch (indexPath.section) {
        case 0:
            return [YZProductAddressTableCell yz_heightForCellWithModel:self.addressModel contentWidth:kScreenWidth];
            break;
        case 1: {
            id model = self.goodsModel ? self.goodsModel : [self.productArray yz_objectAtIndex:indexPath.row];
            if (indexPath.row < [self allGoodsRowCount]) {
                return [YZProductTableCell yz_heightForCellWithModel:model contentWidth:kScreenWidth];
            }
            return [YZDeliverPriceTableCell yz_heightForCellWithModel:@[] contentWidth:kScreenWidth];
        }
        case 2:
            return [YZProductPayTableCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
        case 3:
            return [YZDeliverTypeTableCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
        default:
            return 0.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (self.addressModel) {
                YZAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZAddressTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.addressModel];
                return cell;
            } else {
                YZProductAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZProductAddressTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.addressModel];
                return cell;
            }
        }
        case 1: {
            id model = self.goodsModel ? self.goodsModel : [self.productArray yz_objectAtIndex:indexPath.row];
            if (indexPath.row < [self allGoodsRowCount]) {
                __weak typeof(self) weakSelf = self;
                YZProductTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZProductTableCell yz_cellIdentifiler]];
                cell.canChangeCount = (self.buyType == BuyType_ReSubmit);
                [cell yz_configWithModel:model];
                cell.refreshPriceBlock = ^{
                    [weakSelf caculateAllGoodsPrice];
                };
                return cell;
            } else {
                YZDeliverPriceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZDeliverPriceTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:@(self.deliverPrice)];
                return cell;
            }
        }
        case 2: {
             YZProductPayTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZProductPayTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:nil];
            return cell;
        }
        case 3: {
            YZDeliverTypeTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZDeliverTypeTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:[_DeliveTypes objectAtIndex:(_deliveTypeCode - 1)]];
            return cell;
        }
        default:
            return [UITableViewCell new];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alertView = [[UIAlertController alloc] init];
        [alertView addAction:[UIAlertAction actionWithTitle:[_DeliveTypes yz_stringAtIndex:0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.deliveTypeCode = 1;
            [weakSelf caculateAllGoodsPrice];
            [weakSelf.tableView reloadData];
        }]];
        if (_DeliveTypes.count > 1) {
            [alertView addAction:[UIAlertAction actionWithTitle:[_DeliveTypes yz_stringAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakSelf.deliveTypeCode = 2;
                [weakSelf caculateAllGoodsPrice];
                [weakSelf.tableView reloadData];
            }]];
        }
        [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    } else if (indexPath.section == 0) {
        YZAddressViewController *vc = [[YZAddressViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.needSelectAddress = YES;
        __weak typeof(self) weakSelf = self;
        vc.selectAddressBlock = ^(YZAddressModel *addressModel) {
            weakSelf.addressModel = addressModel;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (self.buyType == BuyType_ReSubmit);
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    YZProductModel *model = [self.productArray yz_objectAtIndex:indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              [weakSelf deleteShoppingCarGoods:model];
                                                                          }];
    return @[deleteAction];
}

- (void)deleteShoppingCarGoods:(YZProductModel *)model {
    [self.productArray removeObject:model];
    [self.tableView reloadData];
    [self caculateAllGoodsPrice];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"addressVC"]) {
//        YZAddressViewController *vc = segue.destinationViewController;
//        vc.needSelectAddress = YES;
//        __weak typeof(self) weakSelf = self;
//        vc.selectAddressBlock = ^(YZAddressModel *addressModel) {
//            weakSelf.addressModel = addressModel;
//        };
//    } else if ([segue.identifier isEqualToString:@"resultVC"]) {
//        NZBuySuccessViewController *vc = segue.destinationViewController;
//        vc.userOrder = sender;
//    }
//}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray array];
    }
    return _productArray;
}

- (NSMutableArray *)mergeList {
    if (!_mergeList) {
        _mergeList = [NSMutableArray array];
    }
    return _mergeList;
}

#pragma mark - weixinPay method
/**
 我们来做本地统一下单和二次签名工作
 如果正式项目还是在后台生成
 //统一下单 链接https://api.mch.weixin.qq.com/pay/unifiedorder
 
 
 这一步是服务器来做
 统一下单字端：
 以下是必填的
 appid:应用id
 mch_id：商户号
 device_info:设备号
 nonce_str:随机字符串
 sign:签名
 body:商品描述
 out_trade_no：商户订单号
 total_fee:总金额
 spbill_create_ip:终端ip
 notyfy_url:通知地址
 trade_trpe:交易类型
 ---------------------------
 
 */
-(void)WxPay{
    
    NSString *productId = @"";
    id item = [self.payGoodsArray firstObject];
    if ([item isKindOfClass:[NSDictionary class]]) {
        productId = [item yz_stringForKey:@"productId"];
    } else if ([item isKindOfClass:[YZProductModel class]]) {
        productId = ((YZProductModel *)item).productId;
    }
    
    [[YZNCNetAPI sharedAPI].productAPI payWeixinWithProductId:productId
                                                        price:[NSNumber numberWithFloat:self.allPrice]
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          //调起微信支付
                                                          PayReq* req             = [[PayReq alloc] init];
                                                          //                                                           req.openID              = Weixin_App_Id;
                                                          req.partnerId           = @"1509799731";
                                                          req.prepayId            = [responseObject objectForKey:@"prepay_id"];
                                                          req.package             = [responseObject objectForKey:@"packageStr"];
                                                          req.nonceStr            = [responseObject objectForKey:@"nonce_str"];
                                                          req.timeStamp           = (UInt32)[[responseObject objectForKey:@"timestamp"] intValue];
                                                          req.sign                = [responseObject objectForKey:@"sign"];
                                                          [WXApi sendReq:req];
                                                      } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                          [MBProgressHUD showError:error.msg];
                                                      }];
    
    
    //    //设备号
    //    NSString *device =[[UIDevice currentDevice] identifierForVendor].UUIDString;
    //    //价格 微信是按分来计算的比如商品300，那么就是300*100
    //    NSString *price = @"300000";
    //    //订单标题 展示给用户
    //    NSString *orderName = @"微信支付";
    //    //订单类型
    //    NSString *orderType = @"APP";
    //    //发起支付的设备ip地址
    //    NSString *ordeIp =  [self getIP:YES];
    //    NSLog(@"%@",ordeIp);
    //
    //    //生成随机数串
    //    //time(0)得到当前时间值
    //    //而srand()函数是种下随机种子数方便调用rand来得到随机数
    //    srand((unsigned)time(0));
    //    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()];
    //
    //    //订单号。(随机的可以直接用时间戳)
    //    NSString *orderNO   = [self timeStamp];
    //
    //
    //    NSMutableDictionary *packageParams = [NSMutableDictionary dictionary];
    //
    //    [packageParams setObject:APP_KEY  forKey:@"appid"];       //开放平台appid
    //    [packageParams setObject: MCH_ID  forKey:@"mch_id"];      //商户号
    //    [packageParams setObject: device  forKey:@"device_info"]; //支付设备号或门店号
    //    [packageParams setObject: noncestr     forKey:@"nonce_str"];   //随机串
    //    [packageParams setObject: orderType    forKey:@"trade_type"];  //支付类型，固定为APP
    //    [packageParams setObject: orderName    forKey:@"body"];        //订单描述，展示给用户
    //    NSString * str = @"www.baidu.com";//[NSString stringWithFormat:@"%@",[payDic objectForKey:@"notify_url"]];
    //    [packageParams setObject: str  forKey:@"notify_url"];  //支付结果异步通知
    //    [packageParams setObject: orderNO      forKey:@"out_trade_no"];//商户订单号
    //    [packageParams setObject: ordeIp      forKey:@"spbill_create_ip"];//发器支付的机器ip
    //    [packageParams setObject: price   forKey:@"total_fee"];       //订单金额，单位为分
    //
    //    //获取预支付订单
    //    NSString * prePayID = [self getPrePayId:packageParams];
    //
    //    /*----二次签名并且发起微信支付--------------------------*/
    //    NSString    *package, *time_stamp, *nonce_str;
    //    //设置支付参数
    //    time_t now;
    //    time(&now);
    //    time_stamp  = [NSString stringWithFormat:@"%ld", now];//时间戳
    //    nonce_str = [self md5:time_stamp];//随机字符串（直接用时间戳来生成就可以了）
    //
    //    package         = @"Sign=WXPay";
    //
    //    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];//用于二次签名的参数
    //    [signParams setObject: APP_KEY  forKey:@"appid"];
    //    [signParams setObject: MCH_ID  forKey:@"partnerid"];
    //    [signParams setObject: nonce_str    forKey:@"noncestr"];
    //    [signParams setObject: package      forKey:@"package"];
    //    [signParams setObject: time_stamp   forKey:@"timestamp"];
    //    [signParams setObject: prePayID     forKey:@"prepayid"];
    //
    //    //调起微信支付
    //    PayReq* req             = [[PayReq alloc] init];
    //    req.partnerId           = MCH_ID;
    //    req.prepayId            = prePayID;
    //    req.nonceStr            = nonce_str;
    //    req.timeStamp           = time_stamp.intValue;
    //    req.package             = package;
    //
    //    req.sign                = [self createMd5Sign:signParams];//二次签名
    //
    //    [WXApi sendReq:req];
    //
    //
    //
    //
    //#pragma mark---正式项目用下面这个
    //    //     */
    //    //    /*
    //    //      一般为了安全以下值都是服务器给你传过来的
    //    //     */
    //
    //
    //
}


///**
// 获取到prepay_id预支付订单号
// 要和微信支付后台交互
// @param pakeParams 字典
// @return 返回预支付订单号
// 里面需求md5加密 排序等，微信支付后台交互 xml解析
// */
//-(NSString *)getPrePayId:(NSMutableDictionary *)pakeParams{
//
//
//    static NSString *aprepayid = nil;
//    //按照微信支付接口来进行排序和加密然后将该字段传送给微信支付后台
//    NSString *send = [self genPackage:pakeParams];
//
//    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
//    session.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    [session.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    [session.requestSerializer setValue:@"https://api.mch.weixin.qq.com/pay/unifiedorder" forHTTPHeaderField:@"SOAPAction"];
//
//    [session.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
//        return send;
//    }];
//
//    [session POST:@"https://api.mch.weixin.qq.com/pay/unifiedorder" parameters:send constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        XMLHelper *xml  = [[XMLHelper alloc] init];
//        //开始解析
//        [xml startParse:responseObject];
//        NSMutableDictionary *resParams = [xml getDict];
//        NSLog(@"%@",resParams);
//        //判断返回
//        NSString *return_code   = [resParams objectForKey:@"return_code"];
//        NSString *result_code   = [resParams objectForKey:@"result_code"];
//        if ([return_code isEqualToString:@"SUCCESS"]) {
//            //生成返回数据进行排序签名
//            NSString *sign      = [self createMd5Sign:resParams ];
//            NSString *send_sign =[resParams objectForKey:@"sign"];
//            if ([sign isEqualToString:send_sign]) {
//                if ([result_code isEqualToString:@"SUCCESS"]) {
//                    aprepayid = [resParams objectForKey:@"prepay_id"];
//                }
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
//
//    return aprepayid;
//}
//#pragma mark ---  获取package带参数的签名包
//-(NSString *)genPackage:(NSMutableDictionary*)packageParams
//{
//    NSString *sign;
//    NSMutableString *reqPars=[NSMutableString string];
//    //给字符串生成签名
//    sign = [self createMd5Sign:packageParams];
//    //生成xml的package
//    NSArray *keys = [packageParams allKeys];
//    [reqPars appendString:@"<xml>\n"];
//    for (NSString *categoryId in keys) {
//        [reqPars appendFormat:@"<%@>%@</%@>\n", categoryId, [packageParams objectForKey:categoryId],categoryId];
//    }
//    [reqPars appendFormat:@"<sign>%@</sign>\n</xml>", sign];
//
//    return [NSString stringWithString:reqPars];
//}
//#pragma mark ---  创建package签名
//-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
//{
//    NSMutableString *contentString  =[NSMutableString string];
//    NSArray *keys = [dict allKeys];
//    //按字母顺序排序
//    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    //拼接字符串
//    for (NSString *categoryId in sortedArray) {
//        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
//            && ![categoryId isEqualToString:@"sign"]
//            && ![categoryId isEqualToString:@"key"]
//            )
//        {
//            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
//        }
//
//    }
//    //添加key字段
//    [contentString appendFormat:@"key=%@", API_KEY];
//    NSLog(@"%@",contentString);
//    //得到MD5 sign签名
//    NSString *md5Sign =[self md5:contentString];
//
//    //输出Debug Info
//    //    [self.debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
//
//    return md5Sign;
//}
//#pragma mark ---  将字符串进行MD5加密，返回加密后的字符串
//-(NSString *) md5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
//
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02X", digest[i]];
//
//    return output;
//}
///**
// 订单号---我们是测试demo所以要生成随机的
// 正式项目不是
// @return
// */
//-(NSString *)timeStamp{
//    return [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970]];
//}
//#pragma mark ---  获取IP
//-(NSString *)getIP:(BOOL)preferIPv4{
//    NSArray *searchArray = preferIPv4 ?
//    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
//    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
//
//    NSDictionary *addresses = [self getIPAddresses];
//    //NSLog(@"addresses: %@", addresses);
//
//    __block NSString *address;
//    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
//     {
//         address = addresses[key];
//         if(address) *stop = YES;
//     } ];
//    return address ? address : @"0.0.0.0";
//    return nil;
//}
//- (NSDictionary *)getIPAddresses
//{
//    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
//
//    // retrieve the current interfaces - returns 0 on success
//    struct ifaddrs *interfaces;
//    if(!getifaddrs(&interfaces)) {
//        // Loop through linked list of interfaces
//        struct ifaddrs *interface;
//        for(interface=interfaces; interface; interface=interface->ifa_next) {
//            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
//                continue; // deeply nested code harder to read
//            }
//            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
//            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
//                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
//                char addrBuf[INET6_ADDRSTRLEN];
//                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
//                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
//                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
//                }
//            }
//        }
//        // Free memory
//        freeifaddrs(interfaces);
//    }
//    //     The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
//
//    return [addresses count] ? addresses : nil;
//}
//
//#pragma mark - test2
//-(void)touchPlayWXChat:(NSDictionary *)dict
//{
//    //传额外字符串attach
//    WXpayRequsestHandler *handle = [[WXpayRequsestHandler alloc]init];
//    if ( [handle  init:@"wx＊＊＊＊＊" mch_id:@"＊＊＊＊＊＊"]) {
//        NSLog(@"初始化成功");
//    }
//    //设置商户密钥
//    [handle setKey:@"＊＊＊＊＊＊＊"];
//    //提交预支付，获得prepape_id
//    NSString *order_name = dict[@"title"];   //订单标题
//    NSString * priceStr = [NSString stringWithFormat:@"%f",[dict[@"cost"] floatValue]*100];
//    NSString *order_price = [NSString stringWithFormat:@"%d",[priceStr intValue]];//测试价格 分为单位
//    NSString *nocify_URL = @"http://。。。。。。。";    //回调借口
//    NSString *noncestr  = [NSString stringWithFormat:@"%d", rand()]; //随机串
//    NSString *orderno   = [NSString stringWithFormat:@"%@",dict[@"order_num"]];
//    NSMutableDictionary *params = [@{@"appid":@"wx＊＊＊＊＊",
//                                     @"mch_id":@"＊＊＊＊＊",
//                                     @"device_info":[[[UIDevice currentDevice] identifierForVendor] UUIDString],
//                                     @"nonce_str":noncestr,
//                                     @"trade_type":@"APP",
//                                     @"body":order_name,
//                                     @"notify_url":nocify_URL,
//                                     @"out_trade_no":orderno,//商户订单号:这个必须用后台的订单号
//                                     @"spbill_create_ip":@"8.8.8.8",
//                                     @"attach":@"running",
//                                     @"total_fee":order_price}mutableCopy];
//
//    //提交预支付两次签名得到预支付订单的id（每次的请求得到的预支付订单id都不同）
//    NSString *prepate_id = [handle sendPrepay:params];
//    if (prepate_id != nil)
//    {
//        PayReq *request = [[PayReq alloc] init];
//        /** 商家向财付通申请的商家id */
//        request.partnerId = @"＊＊＊＊＊";
//        /** 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你 */
//        request.prepayId= prepate_id;
//        /** 这个比较特殊，是固定的，只能是即request.package = Sign=WXPay */
//        request.package = @"Sign=WXPay";
//        /** // 随机编码，为了防止重复的，在后台生成 */
//        request.nonceStr= noncestr;
//        /** 这个是时间戳，也是在后台生成的，为了验证支付的 */
//        request.timeStamp = (UInt32)[[NSDate date] timeIntervalSince1970];
//        /** 商家根据微信开放平台文档对数据做的签名wx＊＊＊＊＊ */
//        request.sign = [self createMD5SingForPay:@"wx＊＊＊＊"
//                                       partnerid:@"＊＊＊＊"
//                                        prepayid:request.prepayId
//                                         package:@"Sign=WXPay"
//                                        noncestr:request.nonceStr
//                                       timestamp:(UInt32)[[NSDate date] timeIntervalSince1970]];
//        /*! @brief 发送请求到微信，等待微信返回onResp
//         *
//         * 函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
//         * SendAuthReq、SendMessageToWXReq、PayReq等。
//         * @param req 具体的发送请求，在调用函数后，请自己释放。
//         * @return 成功返回YES，失败返回NO。
//         */
//        //带起微信支付
//        if ([WXApi sendReq:request]) {
//
//        }else{
//            //NSLog(@"走之类");
//            //未安装微信客户端
//            [[[UIAlertView alloc]initWithTitle:@"微信支付" message:@"微信支付出错" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil]show];
//        }
//    }
//    else
//    {
//        [OMGToast showWithText:@"该订单过期，请重新下单" bottomOffset:3 duration:2];
//    }
//}
//#pragma mark -  微信支付本地签名
//-(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key
//{
//    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
//    [signParams setObject:appid_key forKey:@"appid"];
//    [signParams setObject:noncestr_key forKey:@"noncestr"];
//    [signParams setObject:package_key forKey:@"package"];
//    [signParams setObject:partnerid_key forKey:@"partnerid"];
//    [signParams setObject:prepayid_key forKey:@"prepayid"];
//    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
//    NSMutableString *contentString  =[NSMutableString string];
//    NSArray *keys = [signParams allKeys];
//    //按字母顺序排序
//    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [obj1 compare:obj2 options:NSNumericSearch];
//    }];
//    //拼接字符串
//    for (NSString *categoryId in sortedArray) {
//        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
//            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
//            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
//            )
//        {
//            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
//        }
//    }
//    //添加商户密钥key字段
//    [contentString appendFormat:@"key=%@",@"＊＊＊＊＊＊＊＊＊＊＊＊＊"];
//    NSString *result = [self md5:contentString];
//    return result;
//
//}//创建发起支付时的sige签名
//
//
//-(NSString *)md5:(NSString *)str
//{
//    const char *cStr = [str UTF8String];
//    unsigned char result[16]= "0123456789abcdef";
//    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
//    //这里的x是小写则产生的md5也是小写，x是大写则md5是大写，这里只能用大写，微信的大小写验证很逗
//    return [NSString stringWithFormat:
//            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
//            result[0], result[1], result[2], result[3],
//            result[4], result[5], result[6], result[7],
//            result[8], result[9], result[10], result[11],
//            result[12], result[13], result[14], result[15]
//            ];
//}//MD5 加密

- (YZGoodsModel *)goodsModel {
    if (!_goodsModel) {
        _goodsModel = [self.lauchParams yz_objectForKey:kYZLauchParams_GoodsModel];
    }
    return _goodsModel;
}

- (NSDictionary *)goodsDict {
    if (!_goodsDict) {
        _goodsDict = [self.lauchParams yz_objectForKey:kYZLauchParams_GoodsDict];
    }
    return _goodsDict;
}

@end
