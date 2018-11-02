//
//  YZUserCenterInfoTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserCenterInfoTableCell.h"

@interface YZUserCenterInfoTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *idLb;

@end

@implementation YZUserCenterInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = 6;
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 95;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZAccountModel class]]) {
        YZAccountModel *user = model;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:user.avatar]
                         placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
        self.nameLb.text = user.nickname;
        self.idLb.text = [NSString stringWithFormat:@"ID：%@",user.userId];
    }
}

@end
