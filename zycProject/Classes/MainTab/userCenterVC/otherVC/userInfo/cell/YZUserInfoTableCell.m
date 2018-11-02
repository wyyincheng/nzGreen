//
//  YZUserInfoTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserInfoTableCell.h"

@interface YZUserInfoTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *infoLb;

@end

@implementation YZUserInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 47;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSDictionary class]]) {
        self.titleLb.text = [model yz_stringForKey:kYZDictionary_TitleKey];
        self.infoLb.text = [model yz_stringForKey:kYZDictionary_InfoKey];
    }
}

@end
