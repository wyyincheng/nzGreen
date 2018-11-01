//
//  UIColor+IMHelper.m
//  YMMIMCenter
//
//  Created by jaderyang on 2017/10/26.
//  Copyright © 2017年 YMM. All rights reserved.
//

#import "UIColor+IMHelper.h"

@implementation UIColor (IMHelper)

+ (UIColor* )colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor* )colorWithHex:(NSInteger)hexValue{
    return [self colorWithHex:hexValue alpha:1.F];
}

@end
