//
//  UIView+YMMBorder.m
//  LeakTestDemo
//
//  Created by jaderyang on 2017/9/19.
//  Copyright © 2017年 yunmm. All rights reserved.
//

#import "UIView+YMMBorder.h"
#import <objc/runtime.h>

@implementation UIView (YMMBorder)

#pragma mark - add method

- (void)addBorderInPosition:(YMMBorderPosition)position{
    [self addBorderInPosition:position style:YMMBorderStyleSolid];
}

- (void)addBorderInPosition:(YMMBorderPosition)position style:(YMMBorderStyle)style{
    [self addBorderInPosition:position style:style borderColor:self.ymm_borderColor borderWidth:self.ymm_borderWidth];
}

- (void)addBorderInPosition:(YMMBorderPosition)position style:(YMMBorderStyle)style borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    YMMBorderLineProvider *provider = [[YMMBorderLineProvider alloc] initWithPosition:position andBorderStyle:style];
    provider.userInteractionEnabled = NO;
    provider.backgroundColor = [UIColor clearColor];
    provider.borderWidth = borderWidth;
    provider.strokColor = borderColor;
    provider.frame = self.bounds;
    provider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:provider];
}


#pragma mark - clear method
- (void)clearBorder{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[YMMBorderLineProvider class]]) {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - getter and setter
- (void)setYmm_borderColor:(UIColor *)ymm_borderColor{
    objc_setAssociatedObject(self, @selector(ymm_borderColor), ymm_borderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)ymm_borderColor{
   return objc_getAssociatedObject(self, @selector(ymm_borderColor));
}

- (void)setYmm_borderWidth:(CGFloat)ymm_borderWidth{
    objc_setAssociatedObject(self, @selector(ymm_borderWidth), @(ymm_borderWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)ymm_borderWidth{
    return [objc_getAssociatedObject(self, @selector(ymm_borderWidth)) integerValue];
}

@end
