//
//  YZGoodsSearchTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/20.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsSearchTableCell.h"

@interface YZGoodsSearchTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *searchLb;

@end

@implementation YZGoodsSearchTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 42.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSString class]]) {
        self.searchLb.text = model;
    }
}

@end
