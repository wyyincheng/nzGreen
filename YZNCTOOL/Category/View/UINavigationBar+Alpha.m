//
//  UINavigationBar+Alpha.m
//  Shipper
//
//  Created by heng wu on 17/8/9.
//  Copyright © 2017年 上海细微信息咨询有限公司. All rights reserved.
//

#import "UINavigationBar+Alpha.h"
#import <objc/runtime.h>

static NSString *alphaBgViewKey;

static NSString * const kBackgroundBefore = @"_UINavigationBarBackground";
static NSString * const kBackgroundAfter = @"_UIBarBackground";

@implementation UINavigationBar (Alpha)

- (UIView *)alphaBgView {
    return objc_getAssociatedObject(self, &alphaBgViewKey);
}

- (void)setAlphaBgView:(UIView *)alphaBgView {
    objc_setAssociatedObject(self, &alphaBgViewKey, alphaBgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setAlphaBackgroundColor:(UIColor *)backgroundColor {
    if (!self.alphaBgView) {
        UIImage *image = [[UIImage alloc] init];
        [self setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:image];
        UIView *backgroundView = [self navigationBarBackground];
        self.alphaBgView = [[UIView alloc] initWithFrame:backgroundView.bounds];
        self.alphaBgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [backgroundView insertSubview:self.alphaBgView atIndex:0];
    }
    [self.alphaBgView setBackgroundColor:backgroundColor];
}

- (void)resetBackgroundColor {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.alphaBgView removeFromSuperview];
    self.alphaBgView = nil;
    [self setTranslucent:NO];
}

- (BOOL)bgAlpha {
    if (self.alphaBgView) {
        return YES;
    }
    return NO;
}

/**
 *  获取显示navigationBar背景view
 *
 *  iOS10之前_UINavigationBarBackground, iOS10之后_UIBarBackground
 *  @return return value description
 */
- (UIView *)navigationBarBackground {
    UIView *background = nil;  // navigationBar呈现背景view
    NSString *className = kBackgroundBefore;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        className = kBackgroundAfter;
    }
    
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[NSClassFromString(className) class]]) {
            background = subview;
            break;
        }
    }
    return background;
}

@end
