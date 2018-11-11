//
//  YZRegisterViewController.m
//  zycProject
//
//  Created by yc on 2018/11/8.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZRegisterViewController.h"

#import "YZSMSConfirmViewController.h"
#import "YZMainViewController.h"
#import "NSString+NZCheck.h"
#import "NZTipView.h"

@interface YZRegisterViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;

@property (weak, nonatomic) IBOutlet UIButton *registerBt;
@property (weak, nonatomic) IBOutlet UIButton *backBt;

@end

static NSInteger kYZTextFieldTag_Phone = 8000;
static NSInteger kYZTextFieldTag_Pwd = 8001;

@implementation YZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTextField.tag = kYZTextFieldTag_Phone;
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号"
                                                                                attributes:@{NSForegroundColorAttributeName:kTextColorNormal}];
    self.pwdTextField.tag = kYZTextFieldTag_Pwd;
    self.pwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"密码"
                                                                              attributes:@{NSForegroundColorAttributeName:kTextColorNormal}];
    
    self.phoneTextField.delegate = self;
    self.pwdTextField.delegate = self;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

#pragma mark - action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
- (IBAction)registerAction:(UIButton *)sender {
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
    
    [MBProgressHUD showMessage:@"加载中…"];
    AVUser* user = [[AVUser alloc] init];
    user.username = self.phoneTextField.text;
    user.password = self.pwdTextField.text;
    user.mobilePhoneNumber = self.phoneTextField.text;
    
    //TODO:带上随机分配的token
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            switch (error.code) {
                case 202:
                case 214:
                    [MBProgressHUD showError:@"手机号已存在"];
                    break;
                    
                default:
                    [MBProgressHUD showError:error.localizedDescription];
                    break;
            }
        } else {
            // 注册成功
            YZSMSConfirmViewController *verifyVC = [[YZSMSConfirmViewController alloc] init];
            verifyVC.targetUser = user;
            verifyVC.isLaunchLogin = self.isLaunchLogin;
            [self.navigationController pushViewController:verifyVC animated:YES];
        }
    }];
}

@end
