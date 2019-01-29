#import "NZChangePwdViewController.h"
#import "YZNCNetAPI.h"
@interface NZChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *theOldPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *theNewPwdTF;
@property (weak, nonatomic) IBOutlet UITextField *theNewPwdConfirmTF;
@end
@implementation NZChangePwdViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)changePwdAction:(id)sender {
    if (self.theOldPwdTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入您的原密码"];
        return;
    }
    if (self.theNewPwdTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入您的新密码"];
        return;
    }
    if (self.theNewPwdConfirmTF.text.length == 0) {
        [MBProgressHUD showError:@"请再次输入您的新密码"];
        return;
    }
    if (![self.theNewPwdTF.text isEqualToString:self.theNewPwdConfirmTF.text]) {
        [MBProgressHUD showError:@"两次新密码必须输入一致"];
        return;
    }
    [[YZNCNetAPI sharedAPI].userAPI changePwdWithOldPassword:self.theOldPwdTF.text
                                                  newPassword:self.theNewPwdTF.text
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          [MBProgressHUD showSuccess:@"修改成功"];
                                                          [self.navigationController popViewControllerAnimated:YES];
                                                      } failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                          [MBProgressHUD showError:error.msg];
                                                      }];
}
- (IBAction)tapBackView:(id)sender {
    [self.theOldPwdTF resignFirstResponder];
    [self.theNewPwdTF resignFirstResponder];
    [self.theNewPwdConfirmTF resignFirstResponder];
}
@end

