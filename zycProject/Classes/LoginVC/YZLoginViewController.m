//
//  YZLoginViewController.m
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZLoginViewController.h"

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
}

#pragma mark - action
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    
    AVUser *user = [AVUser user];// 新建 AVUser 对象实例
    user.username = @"Tom";// 设置用户名
    user.password =  @"cat!@#123";// 设置密码
    user.email = @"tom@leancloud.cn";// 设置邮箱
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // 注册成功
        } else {
            // 失败的原因可能有多种，常见的是用户名已经存在。
        }
    }];
    
    
    
    //    self.isRegister = !self.isRegister;
    //    [self.loginBt setTitle:(self.isRegister ? @"注册" : @"登录")
    //                  forState:UIControlStateNormal];
    //    [self.registerBt setTitle:(self.isRegister ? @"登录" : @"注册")
    //                     forState:UIControlStateNormal];
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
        
    }
    
    //    if (self.isRegister) {
    //        if ([self.phoneTextField.text isEqualToString:@"11111111111"]) {
    //            [self performSelector:@selector(showRegisterError)
    //                       withObject:nil
    //                       afterDelay:(arc4random() % 5 + 1)];
    //            return;
    //        }
    //
    //        [[YZNCNetAPI sharedAPI].userAPI loginWithPhone:@"11111111111"
    //                                              password:@"11111111111"
    //                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //                                                   [NZUserCenter shared].normalLogin = YES;
    //                                                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"_normalLogin"];
    //                                                   [[NSUserDefaults standardUserDefaults] synchronize];
    //                                                   [NZUserCenter shared].userInfo = [UserModel yc_objectWithKeyValues:responseObject];
    //                                                   AccountModel *demo = [[AccountModel alloc] init];
    //                                                   demo.nickname = self.phoneTextField.text;
    //                                                   demo.telephone = self.phoneTextField.text;
    //                                                   [NZUserCenter shared].demoUserInfo = demo;
    //                                                   [weakSelf hiddenHUD];
    //                                                   [MBProgressHUD showSuccess:@"注册成功"];
    //                                               } failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
    //                                                   [MBProgressHUD hideHUD];
    //                                                   [NZTipView showError:error.msg onScreen:weakSelf.view];
    //                                               }];
    //    }
    
    //FIXME: network
    

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
