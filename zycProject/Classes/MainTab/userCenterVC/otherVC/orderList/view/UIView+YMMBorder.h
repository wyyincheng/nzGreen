//
//  UIView+YMMBorder.h
//  LeakTestDemo
//
//  Created by jaderyang on 2017/9/19.
//  Copyright © 2017年 yunmm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMMBorderLineProvider.h"

@interface UIView (YMMBorder)

//添加边框线
- (void)addBorderInPosition:(YMMBorderPosition)position;
//添加边框线，指定粗线还是实线
- (void)addBorderInPosition:(YMMBorderPosition)position style:(YMMBorderStyle)style;

/**
 add borders for view.

 @param position top | left | bottom | right  
 @param style solid or dotted
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)addBorderInPosition:(YMMBorderPosition)position style:(YMMBorderStyle)style borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;



/**
 if you want redraw border , please perform this method first , then add borders.
 * 清空现有边框
 */
- (void)clearBorder;

@property (nonatomic, strong) UIColor *ymm_borderColor; //边框颜色
@property (nonatomic, assign) CGFloat ymm_borderWidth; //边框宽度

@end
