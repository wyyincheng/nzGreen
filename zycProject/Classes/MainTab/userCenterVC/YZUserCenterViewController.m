//
//  YZUserCenterViewController.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserCenterViewController.h"

#import "YZOrderListViewController.h"
#import "YZUserCenterInfoTableCell.h"
#import "YZUserInfoViewController.h"
#import "YZBalanceViewController.h"
#import "YZAddressViewController.h"
#import "YZSettingViewController.h"
#import "YZAgentMangerTableCell.h"
#import "YZSettingItemTableCell.h"
#import "UINavigationBar+Alpha.h"
#import "YZAboutViewController.h"
#import "YZStoreViewController.h"

@interface YZUserCenterViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerBgView;
@property (nonatomic, strong) NSArray *settingItemArray;

@end

@implementation YZUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([YZUserCenter shared].userInfo) {
        __weak typeof(self) weakSelf = self;
        [[YZNCNetAPI sharedAPI].userAPI getUserInfoWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [YZUserCenter shared].accountInfo = [YZAccountModel yz_objectWithKeyValues:responseObject];
            [weakSelf.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
            
        }];
    } else {
        [self.tableView reloadData];
    }
}

- (void)initViews {
    
    self.tableView.backgroundColor = kYZBackViewColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZUserCenterInfoTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZUserCenterInfoTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZAgentMangerTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZAgentMangerTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZSettingItemTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZSettingItemTableCell yz_cellIdentifiler]];
    [self.tableView addSubview:self.headerBgView];
    
    [self.navigationController.navigationBar setAlphaBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.settingItemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        default:
            return [[self.settingItemArray yz_arrayAtIndex:section - 1] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [YZUserCenterInfoTableCell yz_heightForCellWithModel:[YZUserCenter shared].accountInfo
                                                           contentWidth:kScreenWidth];
        } else {
            return [YZAgentMangerTableCell yz_heightForCellWithModel:@[]
                                                        contentWidth:kScreenWidth];
        }
    }
    NSDictionary *settingItem = [[self.settingItemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
    return [YZSettingItemTableCell yz_heightForCellWithModel:settingItem
                                                contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                YZUserCenterInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZUserCenterInfoTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:[YZUserCenter shared].accountInfo];
                return cell;
            } else {
                YZAgentMangerTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZAgentMangerTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:@[]];
                __weak typeof(self) weakSelf = self;
                cell.agentMangerBlock = ^(AgentMangerType mangerType) {
                    switch (mangerType) {
                            //TODO:
                        case AgentMangerType_User:
                            [weakSelf performSegueWithIdentifier:@"userVC" sender:nil];
                            break;
                        case AgentMangerType_Order:
                            [weakSelf performSegueWithIdentifier:@"orderVC" sender:nil];
                            break;
                        case AgentMangerType_Sotre:
                            [weakSelf gotoViewController:NSStringFromClass([YZStoreViewController class])];
                            break;
                        default:
                            break;
                    }
                    NSLog(@"select : %lu",(unsigned long)mangerType);
                };
                return cell;
            }
        }
            break;
        default: {
            NSDictionary *settingItem = [[self.settingItemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
            YZSettingItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZSettingItemTableCell yz_cellIdentifiler]];
            [cell yz_configWithModel:settingItem];
            return cell;
        }
            break;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                if (![YZUserCenter shared].userInfo) {
                    [[YZUserCenter shared] gotoLogin];
                    return;
                }
                [self gotoViewController:NSStringFromClass([YZUserInfoViewController class])];
            }
        }
            break;
            
        default: {
            if (![YZUserCenter shared].userInfo) {
                [[YZUserCenter shared] gotoLogin];
                return;
            }
            NSDictionary *settingItem = [[self.settingItemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
            [self gotoViewController:[settingItem yz_stringForKey:kYZVCClassName]];
        }
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y < 0) {
        CGRect rect = self.headerBgView.frame;
        rect.origin.y = offset.y;
        rect.size.height = - offset.y;
        self.headerBgView.frame = rect;   // 下拉背景view
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

- (NSArray *)settingItemArray {
    
    NSString *balanceInfo = [NSString stringWithFormat:@"%.2f金币",[[YZUserCenter shared].accountInfo.balance floatValue]];
    NSArray *realSettingItems = @[
                                  @[@{kYZDictionary_TitleKey:@"我的金币",
                                      kYZDictionary_InfoKey:balanceInfo,
                                      kYZVCClassName:NSStringFromClass([YZBalanceViewController class])},
                                    @{kYZDictionary_TitleKey:@"我的订单",
                                      kYZVCClassName:NSStringFromClass([YZOrderListViewController class])}
                                    ],
                                  @[@{kYZDictionary_TitleKey:@"收货地址",
                                      kYZVCClassName:NSStringFromClass([YZAddressViewController class])}],
                                  @[@{kYZDictionary_TitleKey:@"设置",
                                      kYZVCClassName:NSStringFromClass([YZSettingViewController class])}],
                                  @[@{kYZDictionary_TitleKey:@"关于",
                                      kYZVCClassName:NSStringFromClass([YZAboutViewController class])}]
                                  ];
    
    NSArray *reviewSettingItems = @[
                                    @[@{kYZDictionary_TitleKey:@"我的订单",
                                        kYZVCClassName:NSStringFromClass([YZOrderListViewController class])}],
                                    @[@{kYZDictionary_TitleKey:@"收货地址",
                                        kYZVCClassName:NSStringFromClass([YZAddressViewController class])}],
                                    @[@{kYZDictionary_TitleKey:@"设置",
                                        kYZVCClassName:NSStringFromClass([YZSettingViewController class])}],
                                    @[@{kYZDictionary_TitleKey:@"关于",
                                        kYZVCClassName:NSStringFromClass([YZAboutViewController class])}]
                                    ];
    
    return [YZUserCenter shared].hasReviewed ? realSettingItems : reviewSettingItems;
}

@end
