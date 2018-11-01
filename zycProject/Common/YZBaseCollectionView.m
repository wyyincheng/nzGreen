//
//  YZBaseCollectionView.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseCollectionView.h"

@implementation YZBaseCollectionView

+ (NSString *)yz_cellIdentifiler {
    return [NSString stringWithFormat:@"kYZ%@Identifiler",NSStringFromClass([self class])];
}

- (void)yz_configWithModel:(id)model {
    
}

+ (CGSize)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return CGSizeMake(0, 0);
}

@end
