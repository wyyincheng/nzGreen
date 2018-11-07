//
//  YZDeliverTypeTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZDeliverTypeTableCell.h"

@interface YZDeliverTypeTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *deliveTypeLb;

@end

@implementation YZDeliverTypeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 54.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSString class]]) {
        self.deliveTypeLb.text = model;
    }
}

@end
