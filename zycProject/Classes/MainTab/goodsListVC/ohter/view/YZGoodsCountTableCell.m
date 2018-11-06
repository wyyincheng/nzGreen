//
//  YZGoodsCountTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsCountTableCell.h"

static NSInteger maxCount = 999;

@interface YZGoodsCountTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *countTF;

@end

@implementation YZGoodsCountTableCell

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(hiddenKeyBoard)
                                                     name:kYZNotification_HiddenKeyBoard
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiddenKeyBoard {
    [self.countTF resignFirstResponder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenKeyBoard)
                                                 name:kYZNotification_HiddenKeyBoard
                                               object:nil];
    self.countTF.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0"] && string.length > 0) {
        textField.text = @"";
    } else if (textField.text.length == 1 && string.length == 0) {
        textField.text = @"00";
    }
    NSString *countStr = string.length > 0 ? [NSString stringWithFormat:@"%@%@",textField.text,string] : [textField.text substringToIndex:(textField.text.length - 1)];
    self.goodsModel.count = [countStr integerValue];
    NSLog(@"选择商品数量 ： %ld",(long)self.goodsModel.count);
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 24 * 2 + 20;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        self.goodsModel = model;
        self.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.goodsModel.count];
    }
}

- (IBAction)jianAction:(id)sender {
    NSString *countStr = self.countTF.text;
    if ([countStr respondsToSelector:@selector(integerValue)]) {
        NSInteger count = [countStr integerValue];
        if (count > 0) {
            count = count - 1;
            if (self.changCountBlock) {
                self.changCountBlock(count);
            }
            self.goodsModel.count = count;
            self.countTF.text = [NSString stringWithFormat:@"%ld",(long)count];
        }
    }
}

- (IBAction)jiaAction:(id)sender {
    NSString *countStr = self.countTF.text;
    if ([countStr respondsToSelector:@selector(integerValue)]) {
        NSInteger count = [countStr integerValue];
        if (count < maxCount + 1) {
            count = count + 1;
            if (self.changCountBlock) {
                self.changCountBlock(count);
            }
            self.countTF.text = [NSString stringWithFormat:@"%ld",(long)count];
            self.goodsModel.count = count;
        } else {
            [MBProgressHUD showMessageAuto:@"数量超出范围"];
        }
    }
}

@end
