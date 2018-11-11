//
//  YZCategoryTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/11.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZCategoryTableCell.h"

@interface YZCategoryTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLb;

@end

@implementation YZCategoryTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 40;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSString class]]) {
        self.categoryTitleLb.text = model;
    }
}

@end
