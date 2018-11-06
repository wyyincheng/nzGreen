//
//  YZGoodsServiceTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsServiceTableCell.h"

@interface YZGoodsServiceTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *serviceLb;

@end

@implementation YZGoodsServiceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 47.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goods = model;
        self.serviceLb.text = goods.service;
    }
}

@end
