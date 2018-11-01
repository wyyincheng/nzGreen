//
//  YZBaseCollectionView.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZBaseCollectionView : UICollectionReusableView

+ (NSString *)yz_cellIdentifiler;

- (void)yz_configWithModel:(id)model;

+ (CGSize)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
