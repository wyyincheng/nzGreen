//
//  YMMBorderLineProvider.h
//  LeakTestDemo
//
//  Created by jaderyang on 2017/9/19.
//  Copyright © 2017年 yunmm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, YMMBorderPosition) {
    YMMBorderPositionNone                   = 1 << 0,   //
    YMMBorderPositionTop                    = 1 << 1,
    YMMBorderPositionLeft                   = 1 << 2,
    YMMBorderPositionBottom                 = 1 << 3,
    YMMBorderPositionRight                  = 1 << 4,
    YMMBorderPositionAll                    = 1 << 5
};

//分割线样式
typedef NS_ENUM(NSUInteger, YMMBorderStyle) {
    YMMBorderStyleSolid                     = 1,         //实线
    YMMBorderStyleDotted                                 //虚线
};

@interface YMMBorderLineProvider : UIView

@property (nonatomic, strong) UIColor *strokColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) CGFloat borderWidth;

- (instancetype)initWithPosition:(YMMBorderPosition)position andBorderStyle:(YMMBorderStyle)borderStyle;

@end
