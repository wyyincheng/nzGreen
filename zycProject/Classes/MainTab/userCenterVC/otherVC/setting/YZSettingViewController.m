//
//  YZSettingViewController.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZSettingViewController.h"

#import "YZSettingItemTableCell.h"
#import "YZSettingUserTableCell.h"

#import "YZMainViewController.h"

@interface YZSettingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation YZSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    self.tableView.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    [self.view addSubview:self.logoutButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZSettingUserTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZSettingUserTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZSettingItemTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZSettingItemTableCell yz_cellIdentifiler]];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 + self.itemArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return [[self.itemArray yz_arrayAtIndex:section - 1] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [YZSettingUserTableCell yz_heightForCellWithModel:@[]
                                                    contentWidth:kScreenWidth];
    }
    NSDictionary *item = [[self.itemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
    return [YZSettingItemTableCell yz_heightForCellWithModel:item
                                                contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YZSettingUserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZSettingUserTableCell yz_cellIdentifiler]];
        [cell yz_configWithModel:[YZUserCenter shared].accountInfo];
        return cell;
    } else {
        NSDictionary *item = [[self.itemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
        YZSettingItemTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZSettingItemTableCell yz_cellIdentifiler]];
        [cell yz_configWithModel:item];
        return cell;
    }
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [[self.itemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
    [self gotoViewController:[item yz_stringForKey:kYZVCClassName]];
}

- (void)logoutAction {
    [[YZUserCenter shared] custom_logOut];
    [(YZMainViewController *)self.tabBarController gotoIndexVC:YZVCIndex_UserCenter];
}

#pragma mark - property
- (UIButton *)logoutButton {
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setTitle:@"退出当前账户" forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutButton.backgroundColor = [UIColor colorWithHex:0xCC36A];
        _logoutButton.layer.masksToBounds = YES;
        _logoutButton.layer.cornerRadius = 25;
        _logoutButton.frame = CGRectMake((kScreenWidth-284)/2, kScreenHeight-50-49-40, 284, 50);
        [_logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        //        _logoutButton.hidden = [NZUserCenter shared].canShowChongzhi;
    }
    return _logoutButton;
}

- (NSArray *)itemArray {
    return @[
             @[@{kYZDictionary_TitleKey:@"收货地址"}],
             @[@{kYZDictionary_TitleKey:@"修改密码"}],
             @[@{kYZDictionary_TitleKey:@"关于"}]
             ];

    //TODO:
//    switch (indexPath.section) {
//        case 0:
//            [self performSegueWithIdentifier:@"userInfoVC" sender:nil];
//            break;
//        case 1:
//            [self performSegueWithIdentifier:@"addressListVC" sender:nil];
//            break;
//        case 2:
//            [self performSegueWithIdentifier:@"changePwdVC" sender:nil];
//            break;
//        case 3:
//            [self performSegueWithIdentifier:@"aboutVC" sender:nil];
//            break;
//        default:
//            break;
//    }
}

@end
