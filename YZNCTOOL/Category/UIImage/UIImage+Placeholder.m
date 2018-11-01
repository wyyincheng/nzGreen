//
//  UIImage+Placeholder.m
//  nzGreens
//
//  Created by yc on 2018/5/24.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "UIImage+Placeholder.h"

@implementation UIImage (Placeholder)

+ (UIImage *)yc_imageWithNamed:(NSString *)imageName backSize:(CGSize)size {
    return [UIImage yc_imageWithNamed:imageName backSize:size backColor:[UIColor whiteColor]];
}

+ (UIImage *)yc_imageWithNamed:(NSString *)imageName backSize:(CGSize)size backColor:(UIColor *)color {
    // 占位图的背景色
    UIColor *backgroundColor = color;
    // 中间LOGO图片
    UIImage *image = [UIImage imageNamed:imageName];
    // 根据占位图需要的尺寸 计算 中间LOGO的宽高
    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    // 打开上下文
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    // 绘图
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return resImage;
}

+ (UIImage *)placeHolderImage {
    return [UIImage placeHolderImageWithSize:CGSizeMake(80, 80)];
}

+ (UIImage *)placeHolderImageWithSize:(CGSize)size {
    return [UIImage yc_imageWithNamed:@"kCargoDetailBannerPlaceholder"
                             backSize:size
                            backColor:[UIColor colorWithHex:0xEEEEEE]];
}

@end
