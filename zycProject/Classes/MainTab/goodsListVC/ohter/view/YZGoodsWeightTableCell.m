//
//  YZGoodsWeightTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsWeightTableCell.h"

@interface YZGoodsWeightTableCell ()

@property (weak, nonatomic) IBOutlet UIButton *weightBt;

@end

@implementation YZGoodsWeightTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.weightBt.layer.masksToBounds = YES;
    self.weightBt.layer.cornerRadius = 14;
    self.weightBt.layer.borderWidth = 1;
    self.weightBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+  (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goods = model;
        return goods.weight > 0 ? 96 : 0;
    }
    return 0.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goods = model;
        [self.weightBt setTitle:[NSString stringWithFormat:@"%ldg",(long)goods.weight] forState:UIControlStateNormal];
        self.contentView.hidden = (goods.weight == 0);
    } else {
        self.contentView.hidden = YES;
    }
}

@end
