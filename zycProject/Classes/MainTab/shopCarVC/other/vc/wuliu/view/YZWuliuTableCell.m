//
//  YZWuliuTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZWuliuTableCell.h"

@interface YZWuliuTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation YZWuliuTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[NSDictionary class]]) {
        CGFloat width = [[model yz_numberForKey:@"width"] floatValue];
        CGFloat height = [[model yz_numberForKey:@"height"] floatValue];
        if (width > 0 && height > 0) {
            CGFloat cellHeight = kScreenWidth * height / width;
            if (!isnan(cellHeight)) {
                return cellHeight;
            }
        }
    }
    return kScreenWidth * 184 / 320;
}

- (void)yz_configWithModel:(id)model {
    __weak typeof(self) weakSelf = self;
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSString *iconUrl = [model yz_stringForKey:@"iconUrlStr"];
        
        if ([[model yz_numberForKey:@"width"] floatValue] > 0) {
            self.iconView.contentMode = UIViewContentModeScaleToFill;
        } else {
            self.iconView.contentMode = UIViewContentModeCenter;
        }
        
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:[iconUrl imageUrlString]]
                         placeholderImage:[UIImage imageNamed:@"icon_wuliu_placeholder"]
                                completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                    if (image && image.size.width > 0) {
                                        if ([[model yz_numberForKey:@"width"] floatValue] == 0) {
                                            if (weakSelf.refreshIconBlock) {
                                                weakSelf.refreshIconBlock(iconUrl,image.size.width,image.size.height);
                                            }
                                        }
                                    }
                                }];
    }
}

@end
