//
//  YZCommentViewController.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZCommentViewController.h"

NSString *placeHolder = @"描述一下您购买的商品吧！";
#define MAX_LIMIT_NUMS     500

@interface YZCommentViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *start1;
@property (weak, nonatomic) IBOutlet UIButton *start2;
@property (weak, nonatomic) IBOutlet UIButton *start3;
@property (weak, nonatomic) IBOutlet UIButton *start4;
@property (weak, nonatomic) IBOutlet UIButton *start5;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, strong) NSNumber *scroeNumber;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *startBtArray;
@property (weak, nonatomic) IBOutlet UILabel *textViewCountLb;

@end

@implementation YZCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    self.textView.text = placeHolder;
    self.textView.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    self.textView.delegate = self;
    
    self.textViewCountLb.text = [NSString stringWithFormat:@"%ld/%ld字",(long)MAX_LIMIT_NUMS,(long)MAX_LIMIT_NUMS];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布"
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(publishPingjia:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#warning for yc 订单的数据结构有问题
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:self.orderModel.image]
                     placeholderImage:[UIImage imageNamed:@"goodsDefaultIcon"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)yz_goBack {
    if (self.textView.text.length > 0 && ![self.textView.text isEqualToString:placeHolder]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定取消发布吗？" preferredStyle:UIAlertControllerStyleAlert];
        //    __weak typeof(self) weakSelf = self;
        [alert addAction:[UIAlertAction actionWithTitle:@"继续发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [super yz_goBack];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [super yz_goBack];
}

- (IBAction)clickStart:(UIButton *)sender {
    
    NSInteger index = 1;
    for (UIButton *bt in self.startBtArray) {
        if (bt.tag == sender.tag && index == 1) {
            sender.selected = YES;
            for (NSInteger x = 1; x < self.startBtArray.count; x ++) {
                UIButton *bt = [self.startBtArray yz_objectAtIndex:x];
                bt.selected = NO;
            }
            break;
        } else if (bt.tag == sender.tag) {
            sender.selected = !sender.selected;
            for (NSInteger x = index; x < self.startBtArray.count; x ++) {
                UIButton *bt = [self.startBtArray yz_objectAtIndex:x];
                bt.selected = NO;
            }
            for (NSInteger x = 0; x < index; x ++) {
                UIButton *bt = [self.startBtArray yz_objectAtIndex:x];
                bt.selected = YES;
            }
            break;
        }
        index ++ ;
    }
    
    if (sender.selected) {
        self.scroeNumber = @(sender.tag);
    } else {
        self.scroeNumber = @(sender.tag - 1);
    }
    NSLog(@"评分 ： %@",self.scroeNumber);
}

- (IBAction)publishPingjia:(id)sender {
    if ([self.scroeNumber integerValue] == 0) {
        [MBProgressHUD showMessageAuto:@"请选择评分"];
        return;
    }
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:placeHolder]) {
        [MBProgressHUD showMessageAuto:@"请输入您的评价"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].orderAPI yc_addCommentWithOrderId:self.orderModel.orderId
                                                      comment:self.textView.text
                                                        score:self.scroeNumber
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          if ([responseObject boolValue]) {
                                                              [weakSelf.navigationController popViewControllerAnimated:YES];
                                                          }
                                                      } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                          [MBProgressHUD showMessageAuto:error.msg];
                                                      }];
}

#pragma mark textViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:placeHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length<1) {
        textView.text = placeHolder;
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
            self.textViewCountLb.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
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
    
    //不让显示负数 口口日
    self.textViewCountLb.text = [NSString stringWithFormat:@"%ld/%d字",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}

@end
