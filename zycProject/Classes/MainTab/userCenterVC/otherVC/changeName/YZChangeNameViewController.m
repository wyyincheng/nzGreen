//
//  YZChangeNameViewController.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZChangeNameViewController.h"

@interface YZChangeNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (nonatomic, strong) UIButton *saveBt;

@end

@implementation YZChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelItem;
    
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBt];
    self.navigationItem.rightBarButtonItem = saveItem;
    self.nameTF.text = [self.lauchParams yz_stringForKey:kYZLauchParams_NickName];
}

- (void)cancelAction {
    if (self.nameTF.text.length > 0) {
        __weak typeof(self) weakSelf = self;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前输入尚未保存，确定取消吗？" preferredStyle:UIAlertControllerStyleAlert];
        //    __weak typeof(self) weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)saveAction {
    //    if (self.canSave) {
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI updateUserInfoWithAvart:nil
                                                  avartName:nil
                                                   nickName:self.nameTF.text
                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#warning for yc  未返回约定字段
                                                        [MBProgressHUD showSuccess:@"修改成功"];
                                                        [YZUserCenter shared].accountInfo.nickname = weakSelf.nameTF.text;
                                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                        [MBProgressHUD showError:error.msg];
                                                    }];
    //    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *str = textField.text.length > 0 ? textField.text : @"";
    if (string.length > 0) {
        str = [NSString stringWithFormat:@"%@%@",str,string];
    } else {
        if (str.length > 0) {
            str = [str substringToIndex:(str.length - 1)];
        }
    }
    
    if (str.length > 0) {
        self.saveBt.userInteractionEnabled = YES;
        self.saveBt.selected = NO;
        //        self.canSave = YES;
        //        self.saveItem.tintColor = [UIColor colorWithHex:0x4CC36A];
    } else {
        self.saveBt.userInteractionEnabled = NO;
        self.saveBt.selected = YES;
        //        self.canSave = NO;
        //        self.saveItem.tintColor = [UIColor colorWithHex:0x999999];
    }
    
    if (str.length > 16) {
        return NO;
    }
    
    return YES;
}

- (UIButton *)saveBt {
    if (!_saveBt) {
        _saveBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveBt setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBt setTitleColor:[UIColor colorWithHex:0x62aa60] forState:UIControlStateNormal];
        [_saveBt setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateSelected];
        _saveBt.selected = YES;
        _saveBt.userInteractionEnabled = NO;
        [_saveBt addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [_saveBt sizeToFit];
    }
    return _saveBt;
}


@end
