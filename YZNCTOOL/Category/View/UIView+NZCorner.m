//
//  UIView+NZCorner.m
//  nzGreens
//
//  Created by yc on 2018/4/14.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "UIView+NZCorner.h"

@implementation UIView (NZCorner)

- (void)maskToCorners:(UIRectCorner)corner redius:(CGFloat)redius {
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                           byRoundingCorners:corner
                                                 cornerRadii:(CGSize){redius, redius}].CGPath;
    self.layer.masksToBounds = YES;
    self.layer.mask = maskLayer;
}

@end
