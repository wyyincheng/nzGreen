//
//  YZAddressAddViewController.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAddressAddViewController.h"

#import <BRPickerView.h>
#import "YZAddressModel.h"

@interface YZAddressAddViewController () <UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneLb;
@property (weak, nonatomic) IBOutlet UITextField *nameLb;
@property (weak, nonatomic) IBOutlet UITextField *cityLb;
@property (weak, nonatomic) IBOutlet UITextView *addressLb;
@property (weak, nonatomic) IBOutlet UISwitch *defaultBt;

@property (nonatomic, strong) YZAddressModel *addressModel;

@end

NSString *AddressPlaceHolder = @"请输入详细地址信息，如道路、门牌号、小区";
#define MAX_LIMIT_NUMS     100

@implementation YZAddressAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    self.addressModel = [self.lauchParams yz_objectForKey:kYZLauchParams_AddressModel];
}

- (void)initViews {
    
    self.addressLb.text = AddressPlaceHolder;
    self.addressLb.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.addressLb.delegate = self;
    
    self.phoneLb.delegate = self;
}

#pragma mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:AddressPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = AddressPlaceHolder;
        textView.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            self.textViewCountLb.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //    //不让显示负数 口口日
    //    self.textViewCountLb.text = [NSString stringWithFormat:@"%ld/%d字",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.addressModel) {
        self.nameLb.text = self.addressModel.contact;
        self.phoneLb.text = self.addressModel.telephone;
        self.cityLb.text = [[self.addressModel.address componentsSeparatedByString:@"$"] firstObject];
        
        NSString *detailAddress = [[self.addressModel.address componentsSeparatedByString:@"$"] lastObject];
        if (detailAddress.length > 0) {
            self.addressLb.text = detailAddress;
            self.addressLb.textColor = [UIColor blackColor];
        }
        
        self.defaultBt.on = (self.addressModel.isDefault == 1);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCityAction:(id)sender {
    
    //    [BRAddressPickerView showAddressPickerWithDefaultSelected:@[@10, @0, @3]
    //                                                 isAutoSelect:YES
    //                                                  resultBlock:^(NSArray *selectAddressArr) {
    ////        weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@", selectAddressArr[0], selectAddressArr[1], selectAddressArr[2]];
    //    }];
    
    [self.phoneLb resignFirstResponder];
    [self.nameLb resignFirstResponder];
    [self.cityLb resignFirstResponder];
    [self.addressLb resignFirstResponder];
    
    __weak typeof(self) weakSelf = self;
    [BRAddressPickerView showAddressPickerWithShowType:BRAddressPickerModeProvince
                                            dataSource:nil
                                       defaultSelected:@[@10, @0, @3]
                                          isAutoSelect:NO
                                            themeColor:nil
                                           resultBlock:^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
                                               weakSelf.cityLb.text = [NSString stringWithFormat:@"%@%@%@", province.name, city.name, area.name];
                                           } cancelBlock:nil];
    return;
}

- (IBAction)saveAddress:(id)sender {
    if (self.nameLb.text.length == 0) {
        [MBProgressHUD showMessageAuto:@"请输入收货人姓名"];
        return;
    }
    if (self.phoneLb.text.length == 0) {
        [MBProgressHUD showMessageAuto:@"请输入联系方式"];
        return;
    }
    
#warning for yc 未做格式校验
    //    if (![self.phoneLb.text isPhoneNumber]) {
    //        [MBProgressHUD showMessageAuto:@"请输入正确的手机号"];
    //        return;
    //    }
    
    if (self.cityLb.text.length == 0 && !self.addressModel) {
        [MBProgressHUD showMessageAuto:@"请选择所在地区"];
        return;
    }
    if (self.addressLb.text.length == 0) {
        [MBProgressHUD showMessageAuto:@"请输入详细地址"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    if (self.addressModel) {
        [[YZNCNetAPI sharedAPI].userAPI updateAddressWithAddressId:self.addressModel.addressId
                                                           address:[NSString stringWithFormat:@"%@$ %@",self.cityLb.text,self.addressLb.text]
                                                           contact:self.nameLb.text telephone:self.phoneLb.text isDefault:self.defaultBt.isOn
                                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                               [MBProgressHUD showSuccess:@"保存成功"];
                                                               if (weakSelf.refreshAddressBlock) {
                                                                   weakSelf.refreshAddressBlock();
                                                               }
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                               [MBProgressHUD showMessageAuto:error.msg];
                                                           }];
        return;
    }
    
    [[YZNCNetAPI sharedAPI].userAPI addAddressWithAddress:[NSString stringWithFormat:@"%@$ %@",self.cityLb.text,self.addressLb.text]
                                                  contact:self.nameLb.text telephone:self.phoneLb.text
                                                isDefault:self.defaultBt.isOn
                                                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                      [MBProgressHUD showSuccess:@"保存成功"];
                                                      [weakSelf.navigationController popViewControllerAnimated:YES];
                                                  } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                      [MBProgressHUD showMessageAuto:error.msg];
                                                  }];
}

@end
