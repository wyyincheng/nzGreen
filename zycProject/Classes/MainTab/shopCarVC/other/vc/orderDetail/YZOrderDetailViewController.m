//
//  YZOrderDetailViewController.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderDetailViewController.h"

#import "YZOrderModel.h"
#import "YZAgentOrderDetailModel.h"

#import "YZAddressTableCell.h"
#import "YZOrderListTableCell.h"
#import "YZOrderDetailInfoTableCell.h"
#import "YZOrderDetailCountTableCell.h"
#import "YZOrderDetailStatusTableCell.h"

#import "YZAgentViewController.h"
#import "YZWuliuViewController.h"
#import "YZBuyNowViewController.h"
#import "YZCommentViewController.h"

typedef NS_ENUM(NSUInteger, OrderAction) {
    OrderAction_CatDeliveInfo = 0,
    OrderAction_ReSubmit = 1,
    OrderAction_Pass = 2,
    OrderAction_Reject = 3
};

@interface YZOrderDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YZOrderModel *detailModel;
@property (nonatomic, strong) YZAgentOrderDetailModel *agentDetailModel;
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIButton *reSubmitBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomGap;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@end

static NSString * const kYZAddressTableCellIdentifiler = @"kYZAddressTableCellIdentifilerForOrderDetailVC";

@implementation YZOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderDetailStatusTableCell  class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderDetailStatusTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZAddressTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:kYZAddressTableCellIdentifiler];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderListTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderDetailCountTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderDetailCountTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZOrderDetailInfoTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZOrderDetailInfoTableCell yz_cellIdentifiler]];
    
    self.reSubmitBt.layer.masksToBounds = YES;
    self.reSubmitBt.layer.cornerRadius = 16;
    self.reSubmitBt.layer.borderWidth = 1;
    self.reSubmitBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    
    self.tableView.backgroundColor = kYZBackViewColor;
    self.tableView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    
    if (self.orderType == OrderTyp_Agent) {
        [[YZNCNetAPI sharedAPI].orderAPI getAgentOrderDetailWithOrderId:self.orderNumber
                                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                    weakSelf.agentDetailModel = [YZAgentOrderDetailModel yz_objectWithKeyValues:responseObject];
                                                                    [weakSelf dealOrderStatus];
                                                                    [weakSelf.tableView reloadData];
                                                                    weakSelf.tableView.hidden = NO;
                                                                } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                    [MBProgressHUD showMessageAuto:error.msg];
                                                                }];
        return;
    }
    
    [[YZNCNetAPI sharedAPI].orderAPI getOrderDetailWithOrderId:self.orderNumber
                                                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                           weakSelf.detailModel = [YZOrderModel yz_objectWithKeyValues:responseObject];
                                                           [weakSelf dealOrderStatus];
                                                           [weakSelf.tableView reloadData];
                                                           weakSelf.tableView.hidden = NO;
                                                       } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                           [MBProgressHUD showMessageAuto:error.msg];
                                                       }];
}

- (void)dealOrderStatus {
    
    BOOL showBottomView = NO;
    OrderAction orderAction = OrderAction_Reject;
    NSString *title = @"";
    if (self.fromType == FromType_AgentManger) {
        showBottomView = (self.agentDetailModel.userOrderStatus == 0);
        
        BOOL adopt = (self.agentDetailModel.canAdopt == 1);
        title = @"通过";
        orderAction = OrderAction_Pass;
        showBottomView = showBottomView && adopt;
        
    } else {
        if ([YZUserCenter shared].userInfo.userType == UserType_Agent) {
            BOOL reject = (self.detailModel.canResend);
            BOOL catDelive = (self.detailModel.userOrderStatus == UserOrderStatus_Finished);
            showBottomView = reject || catDelive;
            if (reject) {
                title = @"重新发起交易";
                orderAction = OrderAction_ReSubmit;
            } else {
                title = @"查看物流";
                orderAction = OrderAction_CatDeliveInfo;
            }
        } else {
            showBottomView = (self.detailModel.canResend);
            title = @"重新发起交易";
            orderAction = OrderAction_ReSubmit;
        }
    }
    
    self.reSubmitBt.tag = orderAction;
    if (title) {
        [self.reSubmitBt setTitle:[NSString stringWithFormat:@"   %@   ",title] forState:UIControlStateNormal];
    }
    
    self.bottomGap.constant = (showBottomView ? 49 : 0);
    self.reSubmitBt.hidden = !showBottomView;
    
    self.cancelBt.hidden = YES;
    self.statusLb.hidden = YES;
    
    return;
}

- (void)yz_goBack {
    switch (self.backType) {
        case BackType_Home:
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
        case BackType_From: {
            NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
            if (index != NSNotFound && index > 2) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index - 3)] animated:YES];
            } else {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }
            break;
        default:
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)reSubmitAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case OrderAction_Reject:
            
            break;
            
        case OrderAction_CatDeliveInfo:{
            YZWuliuViewController *wuliuVC = [[YZWuliuViewController alloc] init];
            wuliuVC.orderNumber = self.detailModel.orderNumber;
            wuliuVC.logisticsCompany = self.detailModel.logisticsCompany;
            wuliuVC.logisticsNumber = self.detailModel.logisticsNumber;
            [self.navigationController pushViewController:wuliuVC animated:YES];
            
        }
            break;
            
        case OrderAction_Pass:{
            __weak typeof(self) weakSelf = self;
            [MBProgressHUD showMessage:@""];
            [[YZNCNetAPI sharedAPI].orderAPI adoptOrderWithOrderList:@[self.agentDetailModel.orderNumber]
                                                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                 [MBProgressHUD hideHUD];
                                                                 weakSelf.agentDetailModel.userOrderStatus = [[responseObject firstObject] yz_integerForKey:@"userOrderStatus"];
                                                                 [weakSelf.tableView reloadData];
                                                             } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                 [MBProgressHUD hideHUD];
                                                                 [MBProgressHUD showError:error.msg];
                                                             }];
        }
            break;
            
        case OrderAction_ReSubmit: {
            NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
            [mdict setValue:sender forKey:@"orderNumber"];
            [mdict setValue:@(BuyType_ReSubmit) forKey:@"type"];
            [self gotoViewController:NSStringFromClass([YZBuyNowViewController class])
                         lauchParams:@{kYZLauchParams_GoodsDict:mdict}];
        }
            break;
            
        default:
            break;
    }
}

- (void)gotoPingjiaVC:(YZOrderItemModel *)itemModel {
    YZCommentViewController *pingjiaVC = [[YZCommentViewController alloc] init];
    pingjiaVC.orderModel = itemModel;
    [self.navigationController pushViewController:pingjiaVC animated:YES];
}

- (void)mergeOrderItems {
    NSInteger index = [self.navigationController.viewControllers indexOfObject:self];
    id lastVC = [self.navigationController.viewControllers yz_objectAtIndex:(index - 1)];
    if ([lastVC isKindOfClass:[YZAgentViewController class]]) {
        YZAgentViewController *agentVC = lastVC;
        [agentVC mergeOrdersAction:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return (self.orderType == OrderTyp_Agent ? self.agentDetailModel.orderItemDetailList.count + 1 : self.detailModel.orderItemList.count + 1);
        default:
            return 1;
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [YZOrderDetailStatusTableCell yz_heightForCellWithModel:self.detailModel contentWidth:kScreenWidth];
        }
        YZAddressModel *address = (self.orderType == OrderTyp_Agent ? self.agentDetailModel.addressItem : self.detailModel.addressItem);
        return [YZAddressTableCell yz_heightForCellWithModel:address
                                           contentWidth:kScreenHeight];
    } else if (indexPath.section == 1) {
        if (self.orderType == OrderTyp_Agent) {
            if (indexPath.row < self.agentDetailModel.orderItemDetailList.count) {
                return [YZOrderListTableCell yz_heightForCellWithModel:[self.agentDetailModel.orderItemDetailList yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
            }
            return [YZOrderDetailCountTableCell yz_heightForCellWithModel:self.agentDetailModel
                                                        contentWidth:kScreenWidth];
        }
        if (indexPath.row < self.detailModel.orderItemList.count) {
            return [YZOrderListTableCell yz_heightForCellWithModel:[self.detailModel.orderItemList yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
        }
        return [YZOrderDetailCountTableCell yz_heightForCellWithModel:self.detailModel contentWidth:kScreenWidth];
    } else if (indexPath.section == 2) {
        if (self.orderType == OrderTyp_Agent) {
            return [YZOrderDetailInfoTableCell yz_heightForCellWithModel:self.agentDetailModel contentWidth:kScreenWidth];
        }
        return [YZOrderDetailInfoTableCell yz_heightForCellWithModel:self.detailModel contentWidth:kScreenWidth];
    }
    return 0.0F;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YZOrderDetailStatusTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderDetailStatusTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:(self.orderType == OrderTyp_Agent ? self.agentDetailModel : self.detailModel)];
            return cell;
        }
        YZAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kYZAddressTableCellIdentifiler];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell yz_configWithModel:(self.orderType == OrderTyp_Agent ? self.agentDetailModel.addressItem : self.detailModel.addressItem)];
        return cell;
    } else if (indexPath.section == 1) {
        if (self.orderType == OrderTyp_Agent && indexPath.row < self.agentDetailModel.orderItemDetailList.count) {
            YZOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:[self.agentDetailModel.orderItemDetailList yz_objectAtIndex:indexPath.row]];
            __weak typeof(self) weakSelf = self;
#warning for yc
            cell.pingjiaBlock = ^(YZAgentOrderItemModel *itemModel) {
                [weakSelf mergeOrderItems];
            };
            return cell;
        }
        
        if (indexPath.row < self.detailModel.orderItemList.count) {
            YZOrderListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderListTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:[self.detailModel.orderItemList yz_objectAtIndex:indexPath.row]];
            __weak typeof(self) weakSelf = self;
            cell.pingjiaBlock = ^(YZOrderItemModel *itemModel) {
                [weakSelf gotoPingjiaVC:itemModel];
            };
            return cell;
        }
        YZOrderDetailCountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderDetailCountTableCell yz_cellIdentifiler]];
        [cell yz_configWithModel:(self.orderType == OrderTyp_Agent ? self.agentDetailModel : self.detailModel)];
        return cell;
    } else if (indexPath.section == 2) {
        YZOrderDetailInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZOrderDetailInfoTableCell yz_cellIdentifiler]];
        [cell yz_configWithModel:(self.orderType == OrderTyp_Agent ? self.agentDetailModel : self.detailModel)];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (indexPath.section == 3)  else if (indexPath.section == 0) {
    //        [self performSegueWithIdentifier:@"addressVC" sender:nil];
    //    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"buynowVC"]) {
//        NZBuyNowViewController *buynowVC = segue.destinationViewController;
//        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
//        [mdict setValue:sender forKey:@"orderNumber"];
//        [mdict setValue:@(BuyType_ReSubmit) forKey:@"type"];
//        buynowVC.goodsDict = mdict;
//    }
//}

@end
