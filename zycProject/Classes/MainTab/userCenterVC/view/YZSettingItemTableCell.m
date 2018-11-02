//
//  YZSettingItemTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZSettingItemTableCell.h"

@interface YZSettingItemTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *itemTitle;
@property (weak, nonatomic) IBOutlet UILabel *extraLb;

@end

@implementation YZSettingItemTableCell

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[NSDictionary class]] &&
        ([model yz_stringForKey:kYZDictionary_TitleKey].length + [model yz_stringForKey:kYZDictionary_InfoKey].length > 0)) {
        return 47;
    }
    return 0.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSDictionary class]]) {
        self.itemTitle.text = [model yz_stringForKey:kYZDictionary_TitleKey];
        self.extraLb.text = [model yz_stringForKey:kYZDictionary_InfoKey];
    }
}

@end
