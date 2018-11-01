//
//  YZBaseCollectionViewCell.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseCollectionViewCell.h"

@implementation YZBaseCollectionViewCell

+ (instancetype)yc_createCellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self yz_cellIdentifiler]
                                                     forIndexPath:indexPath];
}

+ (CGSize)yz_sizeForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return CGSizeMake(0, 0);
}

+ (NSString *)yz_cellIdentifiler {
    return [NSString stringWithFormat:@"kYZ%@Identifiler",NSStringFromClass([self class])];
}

- (void)yz_configWithModel:(id)model {
    
}

@end
