//
//  YZGoodsSpecificationsTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsSpecificationsTableCell.h"

@implementation YZGoodsSpecificationsTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return [YZUserCenter shared].hasReviewed ? 47.0f : 0.0f;
}

- (void)yz_configWithModel:(id)model {
    self.contentView.hidden = ![YZUserCenter shared].hasReviewed;
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goods = model;
        
    }
}

@end
