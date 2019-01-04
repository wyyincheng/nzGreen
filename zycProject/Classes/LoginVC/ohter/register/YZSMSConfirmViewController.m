//
//  YZSMSConfirmViewController.m
//  zycProject
//
//  Created by yc on 2018/11/8.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZSMSConfirmViewController.h"

#import "YZMainViewController.h"

@interface YZSMSConfirmViewController () {
    NSTimer *counterDownTimer;
    int freezeCounter;
}

@property (nonatomic, strong) IBOutlet UIButton *requestCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *yzmTextField;
@property (nonatomic, strong) IBOutlet UIButton *verifyButton;

@end

@implementation YZSMSConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self freezeMoreRequest];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [counterDownTimer invalidate];
    counterDownTimer = nil;
}

#pragma mark - action
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - action
- (IBAction)confirmSMSAction:(UIButton *)sender {
    
}

- (void)freezeMoreRequest {
    // 一分钟内禁止再次发送
    [self.requestCodeButton setEnabled:NO];
    freezeCounter = 60;
    counterDownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                        target:self
                                                      selector:@selector(countDownRequestTimer)
                                                      userInfo:nil
                                                       repeats:YES];
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
    [AVUser requestMobilePhoneVerify:self.targetUser.mobilePhoneNumber withBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            [MBProgressHUD showError:error.localizedDescription];
        } else {
            [self freezeMoreRequest];
        }
    }];
}

- (IBAction)verifySMSCode:(id)sender {
    NSString *smsCode = self.yzmTextField.text;
    if (smsCode.length < 6) {
        [MBProgressHUD showError:@"验证码无效。"];
        return;
    }
    [MBProgressHUD showMessage:@""];
    [AVUser verifyMobilePhone:smsCode withBlock:^(BOOL succeeded, NSError *error) {
        [MBProgressHUD hideHUD];
        if (error) {
            [MBProgressHUD showError:error.localizedDescription];
        }
    }];
}

- (void)hiddenHUD {
    
    //TOOD: 获取用户信息
    NSString *token = [self.targetUser valueForKey:@"token"];
    NSDictionary *userInfo = @{@"token":token,@"userType":@(1)};
    [YZUserCenter shared].userInfo = [YZUserModel yz_objectWithKeyValues:userInfo];
    
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
