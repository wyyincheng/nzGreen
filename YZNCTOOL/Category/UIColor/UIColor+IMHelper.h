//
//  UIColor+IMHelper.h
//  YMMIMCenter
//
//  Created by jaderyang on 2017/10/26.
//  Copyright © 2017年 YMM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (IMHelper)

+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor*)colorWithHex:(NSInteger)hexValue;
@end
