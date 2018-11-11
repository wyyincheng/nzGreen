//
//  YZChangePwdViewController.m
//  zycProject
//
//  Created by yc on 2018/11/8.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZChangePwdViewController.h"

@interface YZChangePwdViewController (){
    NSTimer *counterDownTimer;
    int freezeCounter;
}

@property (nonatomic, strong) IBOutlet UITextField *mobilePhoneText;
@property (nonatomic, strong) IBOutlet UITextField *verifyCodeText;
@property (nonatomic, strong) IBOutlet UIButton *requestCodeButton;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UIButton *resetPasswordButton;

@end

@implementation YZChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [AVUser logOut];
//    [self.mobilePhoneText setText:[AVUser currentUser].mobilePhoneNumber];
}

- (void)freezeMoreRequest {
    // 一分钟内禁止再次发送
    [self.requestCodeButton setEnabled:NO];
    freezeCounter = 60;
    counterDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownRequestTimer) userInfo:nil repeats:YES];
    [counterDownTimer fire];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"验证码已发送"
                                                        message:@"验证码已发送到你请求的手机号码。如果没有收到，可以在一分钟后尝试重新发送。"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil,
                              nil];
    [alertView show];
}

- (void)countDownRequestTimer {
    static NSString *counterFormat = @"%d 秒后再获取";
    --freezeCounter;
    if (freezeCounter<= 0) {
        [counterDownTimer invalidate];
        counterDownTimer = nil;
        [self.requestCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.requestCodeButton setEnabled:YES];
    } else {
        [self.requestCodeButton setTitle:[NSString stringWithFormat:counterFormat, freezeCounter] forState:UIControlStateNormal];
    }
}

- (IBAction)requestSMSCode:(id)sender {
    if (self.mobilePhoneText.text.length == 11) {
        [AVUser requestPasswordResetWithPhoneNumber:self.mobilePhoneText.text
                                              block:^(BOOL succeeded, NSError *error) {
                                                  if (error) {
                                                      [MBProgressHUD showError:error.localizedFailureReason];
                                                  } else {
                                                      [self freezeMoreRequest];
                                                  }
                                              }];
    } else {
        [MBProgressHUD showError:@"请输入正确手机号"];
    }
}

- (IBAction)resetPassword:(id)sender {
    NSString *newPassword = self.passwordText.text;
    NSString *smsCode = self.verifyCodeText.text;
    if (newPassword.length < 6) {
        [MBProgressHUD showError:@"密码长度必须在 6 位（含）以上。"];
        return;
    }
    if (smsCode.length < 6) {
        [MBProgressHUD showError:@"验证码无效。"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    
    [AVUser resetPasswordWithSmsCode:smsCode
                         newPassword:newPassword
                               block:^(BOOL succeeded, NSError *error) {
                                   [MBProgressHUD hideHUD];
                                   if (error) {
                                       [MBProgressHUD showError:error.localizedDescription];
                                   } else {
                                       [MBProgressHUD showSuccess:@"密码修改成功，请重新登录"];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }
                               }];
}

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
