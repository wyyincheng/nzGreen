//
//  YZProductTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZProductTableCell.h"

#import "YZGoodsModel.h"
#import "YZProductModel.h"
#import "YZOrderManagerModel.h"

static NSInteger maxCount = 999;

@interface YZProductTableCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *productIconView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLb;
@property (weak, nonatomic) IBOutlet UILabel *productWieght;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *productCountLb;

@property (weak, nonatomic) IBOutlet UILabel *productAllPriceLb;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
@property (weak, nonatomic) IBOutlet UIButton *jianBt;
@property (weak, nonatomic) IBOutlet UIButton *jiaBt;

@property (nonatomic, strong) YZProductModel *productModel;
@property (nonatomic, strong) YZGoodsModel *goodsModel;

@end

@implementation YZProductTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenKeyBoard)
                                                 name:kYZNotification_HiddenKeyBoard
                                               object:nil];
    self.countTF.delegate = self;
    
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiddenKeyBoard {
    [self.countTF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0"] && string.length > 0) {
        textField.text = @"";
    } else if (textField.text.length == 1 && string.length == 0) {
        textField.text = @"00";
    }
    NSString *countStr = string.length > 0 ? [NSString stringWithFormat:@"%@%@",textField.text,string] : [textField.text substringToIndex:(textField.text.length - 1)];
    if ([self.productModel isKindOfClass:[YZProductModel class]]) {
        ((YZProductModel *)self.productModel).productNumber = [countStr integerValue];
        NSLog(@"选择商品数量 ： %ld",(long)(((YZProductModel *)self.productModel).productNumber = [countStr integerValue]));
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.refreshPriceBlock) {
        self.refreshPriceBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 120.0f;
}

- (void)yz_configWithModel:(id)model {
    self.countTF.hidden = !self.canChangeCount;
    self.jianBt.hidden = self.countTF.hidden;
    self.jiaBt.hidden = self.countTF.hidden;
    self.productCountLb.hidden = !self.countTF.hidden;
    
    if ([model isKindOfClass:[YZProductModel class]]) {
        self.productModel = (YZProductModel *)model;
        [self.productIconView sd_setImageWithURL:[NSURL URLWithString:self.productModel.image]
                                placeholderImage:[UIImage placeHolderImage]];
        self.productNameLb.text = self.productModel.title;
        self.productPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[self.productModel.sellingPrice floatValue]];
        self.productWieght.text = [NSString stringWithFormat:@"商品重量：%ld",(long)self.productModel.weight];
        self.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.productModel.productNumber];
        self.productCountLb.text = [NSString stringWithFormat:@"x%ld",(long)self.productModel.productNumber];
        self.productAllPriceLb.text = [NSString stringWithFormat:@"¥%.2f",([self.countTF.text integerValue] * [self.productModel.sellingPrice floatValue])];
    } else if ([model isKindOfClass:[YZGoodsModel class]]) {
        self.goodsModel = model;
        [self.productIconView sd_setImageWithURL:[NSURL URLWithString:self.goodsModel.image]
                                placeholderImage:[UIImage placeHolderImage]];
        self.productNameLb.text = self.goodsModel.title;
        self.productPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[self.goodsModel.sellingPrice floatValue]];
#warning for yc weight vs goodsWeight
        self.productWieght.text = [NSString stringWithFormat:@"商品重量：%ld",(long)self.goodsModel.weight];
        self.countTF.text = [NSString stringWithFormat:@"%ld",(long)self.goodsModel.count];
        self.productCountLb.text = [NSString stringWithFormat:@"x%ld",(long)self.goodsModel.count];
        self.productAllPriceLb.text = [NSString stringWithFormat:@"¥%.2f",([self.countTF.text integerValue] * [self.goodsModel.sellingPrice floatValue])];
    } else if ([model isKindOfClass:[YZOrderManagerItemModel class]]) {
        //        self.goodsModel = model;
        YZOrderManagerItemModel *item = model;
        [self.productIconView sd_setImageWithURL:[NSURL URLWithString:item.image]
                                placeholderImage:[UIImage placeHolderImage]];
        self.productNameLb.text = item.title;
        self.productPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[item.productTotalPrice floatValue]];
#warning for yc weight vs goodsWeight
        self.productWieght.text = [NSString stringWithFormat:@"商品重量：%ld",(long)item.weight];
        self.countTF.text = [NSString stringWithFormat:@"%ld",(long)item.productNumber];
        self.productCountLb.text = [NSString stringWithFormat:@"x%ld",(long)item.productNumber];
#warning for yc 这里使用 productTotalPrice ？？？ 上一页面使用 price ？？？
        self.productAllPriceLb.text = [NSString stringWithFormat:@"¥%.2f", [item.productTotalPrice floatValue]];
    }
}

- (IBAction)jianAction:(id)sender {
    if (!self.canChangeCount) {
        return;
    }
    NSString *countStr = self.countTF.text;
    if ([countStr respondsToSelector:@selector(integerValue)]) {
        NSInteger count = [countStr integerValue];
        if (count < maxCount + 1) {
            count = count + 1;
            self.countTF.text = [NSString stringWithFormat:@"%ld",(long)count];
            self.productCountLb.text = [NSString stringWithFormat:@"x%@",self.countTF.text];
            if (self.goodsModel) {
                self.goodsModel.count = count;
            } else {
                self.productModel.productNumber = count;
            }
            if (self.refreshPriceBlock) {
                self.refreshPriceBlock();
            }
        } else {
            [MBProgressHUD showMessageAuto:@"数量超出范围"];
        }
    }
}

- (IBAction)jiaAction:(id)sender {
    if (!self.canChangeCount) {
        return;
    }
    NSString *countStr = self.countTF.text;
    if ([countStr respondsToSelector:@selector(integerValue)]) {
        NSInteger count = [countStr integerValue];
        if (count > 0) {
            count = count - 1;
            if (self.goodsModel) {
                self.goodsModel.count = count;
            } else {
                self.productModel.productNumber = count;
            }
            self.countTF.text = [NSString stringWithFormat:@"%ld",(long)count];
            self.productCountLb.text = [NSString stringWithFormat:@"x%@",self.countTF.text];
            if (self.refreshPriceBlock) {
                self.refreshPriceBlock();
            }
        }
    }
}

@end
