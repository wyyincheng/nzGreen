//
//  NZUserTableViewCell.m
//  nzGreens
//
//  Created by yc on 2018/5/26.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "NZUserTableViewCell.h"
#import "YZAccountModel.h"

@interface NZUserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avartIconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *tuiBt;
@property (weak, nonatomic) IBOutlet UIButton *chongBt;
@property (nonatomic, strong) YZAccountModel *user;

@end

@implementation NZUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tuiBt.layer.masksToBounds = YES;
    self.tuiBt.layer.cornerRadius = 16;
    self.tuiBt.layer.borderWidth = 1;
    self.tuiBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    
    self.chongBt.layer.masksToBounds = YES;
    self.chongBt.layer.cornerRadius = 16;
    self.chongBt.layer.borderWidth = 1;
    self.chongBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 76.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZAccountModel class]]) {
        self.user = model;
        [self.avartIconView sd_setImageWithURL:[NSURL URLWithString:self.user.avatar]
                              placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
        self.nameLb.text = self.user.nickname;
    }
}

- (IBAction)chongAction:(id)sender {
    if (self.chongBlock) {
        self.chongBlock(self.user);
    }
}

- (IBAction)tuiAction:(id)sender {
    if (self.tuiBlock) {
        self.tuiBlock(self.user);
    }
}


@end
