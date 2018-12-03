//
//  YZLoginViewController.m
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZLoginViewController.h"

#import "YZSMSConfirmViewController.h"
#import "YZChangePwdViewController.h"
#import "YZRegisterViewController.h"
#import "YZPrivacyViewController.h"
#import "YZMainViewController.h"
#import "NSString+NZCheck.h"
#import "NZTipView.h"

@interface YZLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *contactServiceBt;
@property (weak, nonatomic) IBOutlet UIButton *changePwdBt;
@property (weak, nonatomic) IBOutlet UIButton *registerBt;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UIButton *backBt;
@property (weak, nonatomic) IBOutlet UIButton *privacyBt;

//hidden
@property (weak, nonatomic) IBOutlet UIButton *privacyInfoBt;
@property (weak, nonatomic) IBOutlet UILabel *speratorOneLb;
@property (weak, nonatomic) IBOutlet UILabel *speratorTwoLb;


@end

static NSInteger kYZTextFieldTag_Phone = 8000;
static NSInteger kYZTextFieldTag_Pwd = 8001;

@implementation YZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTextField.tag = kYZTextFieldTag_Phone;
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"账号"
                                                                                attributes:@{NSForegroundColorAttributeName:kTextColorNormal}];
    self.pwdTextField.tag = kYZTextFieldTag_Pwd;
    self.pwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
                                                                              attributes:@{NSForegroundColorAttributeName:kTextColorNormal}];
    
    self.phoneTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.backBt.hidden = self.isLaunchLogin;
    
    if ([YZUserCenter shared].hasReviewed) {
        self.contactServiceBt.hidden = YES;
        self.privacyInfoBt.hidden = YES;
        self.speratorOneLb.hidden = YES;
        self.speratorTwoLb.hidden = YES;
        self.changePwdBt.hidden = YES;
        self.registerBt.hidden = YES;
        self.privacyBt.hidden = YES;
        self.backBt.hidden = YES;
    }
}

#pragma mark - action
- (IBAction)backAction:(id)sender {
    [(YZMainViewController *)self.tabBarController gotoIndexVC:YZVCIndex_Home];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate
#pragma mark textfield delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    YCLog(@"textFeild change : %@ %@",textField.text,string);
    if (textField.tag == kYZTextFieldTag_Phone &&
        [NSString stringWithFormat:@"%@%@",textField.text,string].length > 11) {
        return NO;
    }
    if (textField.tag == kYZTextFieldTag_Pwd &&
        [NSString stringWithFormat:@"%@%@",textField.text,string].length > 16) {
        return NO;
    }
    return YES;
}

#pragma mark - private
- (void)showRegisterError {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"改账号已存在，可直接登录"];
}

#pragma mark - action
- (IBAction)loginAction:(UIButton *)sender {
    
    if (![YZUserCenter shared].hasReviewed && !self.privacyBt.selected) {
        [NZTipView showError:@"请先阅读并同意用户协议" onScreen:self.view];
        return;
    }
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        [NZTipView showError:@"请输入正确的账号" onScreen:self.view];
        [self.phoneTextField becomeFirstResponder];
        return;
    }
    
    if (![self.pwdTextField.text isPassword]) {
        [NZTipView showError:@"请输入正确的密码" onScreen:self.view];
        [self.pwdTextField becomeFirstResponder];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@"加载中…"];
    
    if ([YZUserCenter shared].hasReviewed || [self.phoneTextField.text isEqualToString:@"11111111111"]) {
        //走nzGreens后台
        [[YZNCNetAPI sharedAPI].userAPI loginWithPhone:self.phoneTextField.text
                                              password:self.pwdTextField.text
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   [YZUserCenter shared].userInfo = [YZUserModel yz_objectWithKeyValues:responseObject];
                                                   [weakSelf hiddenHUD];
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                   [MBProgressHUD hideHUD];
                                                   [NZTipView showError:error.msg onScreen:weakSelf.view];
                                               }];
    } else {
        //走云后台
        [AVUser logInWithMobilePhoneNumberInBackground:self.phoneTextField.text
                                              password:self.pwdTextField.text
                                                 block:^(AVUser * _Nullable user, NSError * _Nullable error) {
                                                     [MBProgressHUD hideHUD];
                                                     if (error) {
                                                         if (error.code == 215) {
                                                             AVUser *user = [[AVUser alloc] init];
                                                             user.mobilePhoneNumber = self.phoneTextField.text;
                                                             user.username = self.phoneTextField.text;
                                                             YZSMSConfirmViewController *smsVC = [[YZSMSConfirmViewController alloc] init];
                                                             smsVC.isLaunchLogin = self.isLaunchLogin;
                                                             smsVC.targetUser = user;
                                                             [self.navigationController pushViewController:smsVC animated:YES];
                                                         } else {
                                                             [MBProgressHUD showMessageAuto:error.localizedFailureReason];
//                                                             [MBProgressHUD showMessageAuto:@"账号密码错误"];
                                                         }
                                                     } else {
                                                         NSLog(@"userInfo:%@",user.description);
                                                         
                                                         YZUserModel *userModel = [[YZUserModel alloc] init];
                                                         userModel.token = [user objectForKey:@"token"];
                                                         userModel.userType = [[user objectForKey:@"userType"] integerValue];
                                                         
                                                         [YZUserCenter shared].userInfo = userModel;
                                                         [weakSelf hiddenHUD];
                                                     }
                                                 }];
    }
}

- (IBAction)registerAction:(id)sender {
    YZRegisterViewController *vc = [[YZRegisterViewController alloc] init];
    vc.isLaunchLogin = self.isLaunchLogin;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changePwdAction:(id)sender {
    YZChangePwdViewController *vc = [[YZChangePwdViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)contactUsAction:(id)sender {
    NSURL *telURL = [NSURL URLWithString:[@"tel://" stringByAppendingString:kServiceNumber]];
    if ([[UIApplication sharedApplication] canOpenURL:telURL]) {
        [[UIApplication sharedApplication] openURL:telURL];
    }
}

- (IBAction)privacyDetailAction:(id)sender {
    [self gotoViewController:NSStringFromClass([YZPrivacyViewController class])];
}

- (IBAction)privacyAction:(id)sender {
    self.privacyBt.selected = !self.privacyBt.selected;
}

- (void)hiddenHUD {
    [MBProgressHUD hideHUD];
    
    if (self.isLaunchLogin) {
        [self jumpToMainVC];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)jumpToMainVC {
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    window.rootViewController = [YZMainViewController new];
}

@end
