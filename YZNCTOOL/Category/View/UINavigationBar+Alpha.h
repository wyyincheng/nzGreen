//
//  UINavigationBar+Alpha.h
//  Shipper
//
//  Created by heng wu on 17/8/9.
//  Copyright © 2017年 上海细微信息咨询有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Alpha)

/**
 *  设置UINavigationBar Color alpha
 *
 *  @param backgroundColor backgroundColor description
 */
- (void)setAlphaBackgroundColor:(UIColor *)backgroundColor;

/**
 *  返回设置的UINavigationBar Color alpha
 */
- (void)resetBackgroundColor;

/**
 *  背景view是否存在
 *
 *  @return return value description
 */
- (BOOL)bgAlpha;

@end
