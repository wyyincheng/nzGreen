//
//  YZCategoryCollectionCell.m
//  zycProject
//
//  Created by yc on 2018/11/11.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZCategoryCollectionCell.h"

@interface YZCategoryCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *categoryIconView;
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLb;

@end

@implementation YZCategoryCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGSize)yz_sizeForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return CGSizeMake((kScreenWidth - 120)/ 3, (kScreenWidth - 120)/ 3 + 12+16+12);
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSDictionary class]]) {
        [self.categoryIconView sd_setImageWithURL:[NSURL URLWithString:[model yz_stringForKey:@"icon"]]];
        self.categoryTitleLb.text = [model yz_stringForKey:@"title"];
    }
}

@end
