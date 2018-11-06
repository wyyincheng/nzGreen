//
//  YZGoodsIconTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsIconTableCell.h"

@interface YZGoodsIconTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsIconView;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;

@end

@implementation YZGoodsIconTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return kScreenWidth * 200 / 375 + 100;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goodsModel = model;
        self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.sellingPrice floatValue]];
        [self.goodsIconView sd_setImageWithURL:[NSURL URLWithString:goodsModel.image]
                              placeholderImage:[UIImage imageNamed:kCargoDetailBannerPlaceholder]];
    }
}

@end
