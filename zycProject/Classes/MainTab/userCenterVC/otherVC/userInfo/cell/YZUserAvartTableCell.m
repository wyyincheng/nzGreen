//
//  YZUserAvartTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserAvartTableCell.h"

#import "YZAccountModel.h"

@interface YZUserAvartTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avartView;

@end

@implementation YZUserAvartTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 100;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZAccountModel class]]) {
        YZAccountModel *user = model;
        [self.avartView sd_setImageWithURL:[NSURL URLWithString:user.avatar]
                          placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
    }
}

@end
