//
//  YZUserChongViewController.m
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserChongViewController.h"

@interface YZUserChongViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *chongTitleLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *actionLb;
@property (weak, nonatomic) IBOutlet UITextField *balanceTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBT;

@end

@implementation YZUserChongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = (self.mangerType == MangerType_Chong ? @"充值" : @"退款");
    self.chongTitleLb.text = (self.mangerType == MangerType_Chong ? @"充值至" : @"退款至");
    self.actionLb.text = (self.mangerType == MangerType_Chong ? @"充值金币" : @"退款金币");
    
    self.confirmBT.layer.masksToBounds = YES;
    self.confirmBT.layer.cornerRadius = 25;
    self.confirmBT.layer.borderWidth = 1;
    self.confirmBT.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    
    [self.confirmBT setTitle:(self.mangerType == MangerType_Chong ? @"充值" : @"退款") forState:UIControlStateNormal];
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar]
                     placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
    self.nameLb.text = self.user.nickname;
    
    self.balanceTF.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0"] && string.length > 0 && ![string isEqualToString:@"."]) {
        textField.text = @"";
    } else if ([textField.text isEqualToString:@""] && [string isEqualToString:@"."]) {
        textField.text = @"0";
    }
    
    if ([textField.text containsString:@"."] &&
        string.length > 0 &&
        (([textField.text rangeOfString:@"."].location == (textField.text.length - 2)) || [string isEqualToString:@"."])) {
        return NO;
    }
    return YES;
}

- (IBAction)confirmAction:(id)sender {
    
    [self.balanceTF resignFirstResponder];
    
    NSString *str = (self.mangerType == MangerType_Chong ? @"充值" : @"退款");
    if ([self.balanceTF.text integerValue] == 0) {
        [MBProgressHUD showMessageAuto:[NSString stringWithFormat:@"请输入您的%@金额",str]];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI chongBalanceWithAmount:[self.balanceTF.text floatValue]
                                                    userId:self.user.userId
                                                      type:(self.mangerType + 1)
                                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%@成功",str]];
                                                       [weakSelf.navigationController popViewControllerAnimated:YES];
                                                   } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                       [MBProgressHUD showError:error.msg];
                                                   }];
}


@end
