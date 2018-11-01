//
//  UIImage+Placeholder.h
//  nzGreens
//
//  Created by yc on 2018/5/24.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Placeholder)

+ (UIImage *)placeHolderImage;
+ (UIImage *)placeHolderImageWithSize:(CGSize)size;
+ (UIImage *)yz_imageWithNamed:(NSString *)image backSize:(CGSize)size;
+ (UIImage *)yz_imageWithNamed:(NSString *)imageName backSize:(CGSize)size backColor:(UIColor *)color;

@end
