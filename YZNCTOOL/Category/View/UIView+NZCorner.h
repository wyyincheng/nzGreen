//
//  UIView+NZCorner.h
//  nzGreens
//
//  Created by yc on 2018/4/14.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NZCorner)

/**
 设置圆角
 
 @param corner 圆角位置
 @param redius 圆角弧度
 */
- (void)maskToCorners:(UIRectCorner)corner redius:(CGFloat)redius;

@end
