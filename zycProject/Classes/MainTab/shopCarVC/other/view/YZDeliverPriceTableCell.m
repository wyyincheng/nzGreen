//
//  YZDeliverPriceTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZDeliverPriceTableCell.h"

@interface YZDeliverPriceTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *delivePriceLb;

@end

@implementation YZDeliverPriceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 48.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSNumber class]]) {
#warning for yc test
        self.delivePriceLb.text = [NSString stringWithFormat:@"¥%.2f",[model floatValue]];
    }
}

@end
