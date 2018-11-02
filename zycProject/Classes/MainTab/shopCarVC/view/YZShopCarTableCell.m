
//
//  YZShopCarTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZShopCarTableCell.h"

#import "YZProductModel.h"
#import "YZOrderManagerModel.h"

@interface YZShopCarTableCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *jianBt;
@property (weak, nonatomic) IBOutlet UILabel *countLB;

@property (weak, nonatomic) IBOutlet UIButton *jiaBt;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIconView;
@property (weak, nonatomic) IBOutlet UIButton *selectedBt;
@property (weak, nonatomic) IBOutlet UIImageView *goodsIconView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsWeightLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UITextField *goodsCountTF;

@property (nonatomic, strong) id goodsModel;

@end

static NSInteger maxCount = 999;

@implementation YZShopCarTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //    self.goodsIconView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    [self.selectedBt setImage:[UIImage yz_imageWithNamed:@"btn_radio_default"
                                                backSize:CGSizeMake(38, 38)]
                     forState:UIControlStateNormal];
    [self.selectedBt setImage:[UIImage yz_imageWithNamed:@"btn_radio_selected"
                                                backSize:CGSizeMake(38, 38)]
                     forState:UIControlStateSelected];
    self.selectedBt.adjustsImageWhenHighlighted = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hiddenKeyBoard)
                                                 name:kYZNotification_HiddenKeyBoard
                                               object:nil];
    self.goodsCountTF.delegate = self;
    
    self.contentView.clipsToBounds = YES;
    self.clipsToBounds = YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)hiddenKeyBoard {
    [self.goodsCountTF resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0"] && string.length > 0) {
        textField.text = @"";
    } else if (textField.text.length == 1 && string.length == 0) {
        textField.text = @"00";
    }
    NSString *countStr = string.length > 0 ? [NSString stringWithFormat:@"%@%@",textField.text,string] : [textField.text substringToIndex:(textField.text.length - 1)];
    if ([self.goodsModel isKindOfClass:[YZProductModel class]]) {
        ((YZProductModel *)self.goodsModel).productNumber = [countStr integerValue];
        YCLog(@"选择商品数量 ： %ld",(long)(((YZProductModel *)self.goodsModel).productNumber = [countStr integerValue]));
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if (model) {
        return 120.0f;
    }
    return 128.0f;
}

- (void)yz_configWithModel:(id)model {
    self.goodsModel = model;
    if ([model isKindOfClass:[YZProductModel class]]) {
        YZProductModel *product = model;
        self.selectedBt.selected = product.selected;
        [self.goodsIconView sd_setImageWithURL:[NSURL URLWithString:product.image]
                              placeholderImage:[UIImage placeHolderImage]];
        self.goodsNameLb.text = product.title;
        self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[product.sellingPrice floatValue]];
        self.goodsWeightLb.text = [NSString stringWithFormat:@"商品重量：%ld",(long)product.weight];
        self.goodsCountTF.text = [NSString stringWithFormat:@"%ld",(long)product.productNumber];
        self.countLB.hidden = YES;
        self.jiaBt.userInteractionEnabled = YES;
        self.jianBt.userInteractionEnabled = YES;
    } else if ([model isKindOfClass:[YZOrderManagerItemModel class]]) {
        YZOrderManagerItemModel *product = model;
        self.selectedBt.selected = product.selected;
        [self.goodsIconView sd_setImageWithURL:[NSURL URLWithString:product.image]
                              placeholderImage:[UIImage placeHolderImage]];
        self.goodsNameLb.text = product.title;
#warning 缺少 价格
        self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[product.productTotalPrice floatValue]];
        self.goodsWeightLb.text = [NSString stringWithFormat:@"商品重量：%ld",(long)product.weight];
#warning  for yc price ??  productTotalPrice ??
        self.goodsCountTF.text = [NSString stringWithFormat:@"%.2f",[product.productTotalPrice floatValue]];
        self.jiaBt.hidden = YES;
        self.jianBt.hidden = YES;
        self.jiaBt.userInteractionEnabled = NO;
        self.jianBt.userInteractionEnabled = NO;
        self.goodsCountTF.hidden = YES;
        self.countLB.text = [NSString stringWithFormat:@"x%ld",(long)product.productNumber];
        //        self.countLB.hidden = YES;
    }
}

#pragma mark - action
- (IBAction)additionAction:(id)sender {
    if ([self.goodsModel isKindOfClass:[YZOrderManagerItemModel class]]) {
        return;
    }
    NSString *countStr = self.goodsCountTF.text;
    if ([countStr respondsToSelector:@selector(integerValue)]) {
        NSInteger count = [countStr integerValue];
        if (count < maxCount + 1) {
            count = count + 1;
            self.goodsCountTF.text = [NSString stringWithFormat:@"%ld",(long)count];
            
            if ([self.goodsModel isKindOfClass:[YZOrderManagerItemModel class]]) {
                ((YZOrderManagerItemModel *)self.goodsModel).productNumber = count;
            } else if ([self.goodsModel isKindOfClass:[YZProductModel class]]) {
                ((YZProductModel *)self.goodsModel).productNumber = count;
            }
            
            if (self.refreshPriceBlock) {
                self.refreshPriceBlock();
            }
        } else {
            [MBProgressHUD showMessageAuto:@"数量超出范围"];
        }
    }
}

- (IBAction)reduceAction:(id)sender {
    if ([self.goodsModel isKindOfClass:[YZOrderManagerItemModel class]]) {
        return;
    }
    NSString *countStr = self.goodsCountTF.text;
    if ([countStr respondsToSelector:@selector(integerValue)]) {
        NSInteger count = [countStr integerValue];
        if (count > 0) {
            count = count - 1;
            if ([self.goodsModel isKindOfClass:[YZOrderManagerItemModel class]]) {
                ((YZOrderManagerItemModel *)self.goodsModel).productNumber = count;
            } else if ([self.goodsModel isKindOfClass:[YZProductModel class]]) {
                ((YZProductModel *)self.goodsModel).productNumber = count;
            }
            self.goodsCountTF.text = [NSString stringWithFormat:@"%ld",(long)count];
            if (self.refreshPriceBlock) {
                self.refreshPriceBlock();
            }
        }
    }
}

- (IBAction)selectedGoodsAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.selectedIconView.image = sender.selected ? [UIImage imageNamed:@"btn_radio_selected"] : [UIImage imageNamed:@"btn_radio_default"];
    if ([self.goodsModel isKindOfClass:[YZOrderManagerItemModel class]]) {
        ((YZOrderManagerItemModel *)self.goodsModel).selected = sender.selected;
    } else if ([self.goodsModel isKindOfClass:[YZProductModel class]]) {
        ((YZProductModel *)self.goodsModel).selected = sender.selected;
    }
    if (self.refreshPriceBlock) {
        self.refreshPriceBlock();
    }
}

- (IBAction)tapAction:(id)sender {
    [self selectedGoodsAction:self.selectedBt];
}

@end
