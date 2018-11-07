//
//  YZSettingUserTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZSettingUserTableCell.h"

@interface YZSettingUserTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *userNumberLb;

@end

@implementation YZSettingUserTableCell

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
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar]
                         placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
        self.nameLb.text = user.nickname;
        self.userNumberLb.text = [NSString stringWithFormat:@"ID：%@",user.userId];
    }
}

@end
