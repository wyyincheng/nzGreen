//
//  YZBaseCollectionViewCell.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZBaseCollectionViewCell : UICollectionViewCell

+ (instancetype)yz_createCellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

+ (CGSize)yz_sizeForCellWithModel:(id)model contentWidth:(CGFloat)width;

- (void)yz_configWithModel:(id)model;

+ (NSString *)yz_cellIdentifiler;

@end

NS_ASSUME_NONNULL_END
