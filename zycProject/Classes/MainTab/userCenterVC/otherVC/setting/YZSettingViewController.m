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
#import <MessageUI/MFMailComposeViewController.h>

static NSString * const kYZSettingUserTableCellIdentifiler = @"YZSettingUserTableCellForSettingVC";

@interface YZSettingViewController () <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate>

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
         forCellReuseIdentifier:kYZSettingUserTableCellIdentifiler];
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
        YZSettingUserTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kYZSettingUserTableCellIdentifiler];
        cell.rightArrowIcon.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    switch (indexPath.section) {
        case 1:
            //先清除内存中的图片缓存
            [[SDImageCache sharedImageCache] clearMemory];
            //清除磁盘的缓存
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
//        case 2:
//
//            break;
        case 2:
            [self sendByEmail];
            break;
            
        default:
            break;
    }
    NSDictionary *item = [[self.itemArray yz_arrayAtIndex:indexPath.section - 1] yz_dictAtIndex:indexPath.row];
    [self gotoViewController:[item yz_stringForKey:kYZVCClassName]];
}

- (void)logoutAction {
    [[YZUserCenter shared] custom_logOut];
    [(YZMainViewController *)self.tabBarController gotoIndexVC:YZVCIndex_UserCenter];
}

- (void)sendByEmail{
    MFMailComposeViewController *mailSender = [[MFMailComposeViewController alloc]init];
    mailSender.mailComposeDelegate = self;
    [mailSender setSubject:@"意见反馈"];
    [mailSender setMessageBody:@"" isHTML:NO];
    [mailSender setToRecipients:[NSArray arrayWithObjects:@"wyyincheng@yeah.net", nil]];
//    [mailSender addAttachmentData:datamimeType:mimeTypefileName:fileName];
    [self presentViewController:mailSender animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    NSString *string = nil;
    switch(result) {
        case MFMailComposeResultCancelled:
        {
            string = @"发送取消";
        }
            break;
        case MFMailComposeResultSaved:
        {
            string = @"存储成功";
        }
            break;
        case MFMailComposeResultSent:
        {
            string = @"发送成功";
        }
            break;
        case MFMailComposeResultFailed:
        {
            string = @"发送失败";
        }
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:^{
        if (string) {
            [MBProgressHUD showMessageAuto:string];
        }
    }];
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
    
    CGFloat cacheSize = [[SDImageCache sharedImageCache] getSize] / 1024 / 1024;
    NSString *size = cacheSize > 0 ? [NSString stringWithFormat:@"%.2fM",cacheSize] : @" ";
    
    return @[
             @[@{kYZDictionary_TitleKey:@"清除缓存",kYZDictionary_InfoKey:size}],
//             @[@{kYZDictionary_TitleKey:@"修改密码"}],
             @[@{kYZDictionary_TitleKey:@"联系我们"}]
             ];
}

@end
