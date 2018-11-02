//
//  YMMBorderLineProvider.m
//  LeakTestDemo
//
//  Created by jaderyang on 2017/9/19.
//  Copyright © 2017年 yunmm. All rights reserved.
//

#import "YMMBorderLineProvider.h"

#define DefaultFillColor        [UIColor clearColor]
#define DefaultStrokeColor      [UIColor grayColor]

#define DefaultBorderWidth      1.f/[UIScreen mainScreen].scale

@implementation YMMBorderLineProvider{
    YMMBorderPosition _borderPosition;
    YMMBorderStyle    _borderStyle;
}



- (instancetype)initWithPosition:(YMMBorderPosition)position andBorderStyle:(YMMBorderStyle)borderStyle
{
    self = [super init];
    if (self) {
        _borderStyle = borderStyle;
        _borderPosition = position;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    YMMBorderPosition positions = (YMMBorderPositionNone | YMMBorderPositionTop | YMMBorderPositionLeft | YMMBorderPositionRight | YMMBorderPositionBottom | YMMBorderPositionAll);
    NSAssert((_borderPosition & positions) != 0, @"You pass wrong position.");
    if (_borderPosition & YMMBorderPositionNone) [self clearAllBorders:ctx];
    if (_borderPosition & YMMBorderPositionAll) [self addAllBorders:ctx inRect:rect];
    else {
        if (_borderPosition & YMMBorderPositionTop) [self addTopBorder:ctx inRect:rect];
        if (_borderPosition & YMMBorderPositionLeft) [self addLeftBorder:ctx inRect:rect];
        if (_borderPosition & YMMBorderPositionRight) [self addRightBorder:ctx inRect:rect];
        if (_borderPosition & YMMBorderPositionBottom) [self addBottomBorder:ctx inRect:rect];
    }
    
    [self updateAllBorders:ctx];
}

- (void)addTopBorder:(CGContextRef)ctx inRect:(CGRect)rect{
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
}

- (void)addLeftBorder:(CGContextRef)ctx inRect:(CGRect)rect{
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, 0, rect.size.height);
}

- (void)addRightBorder:(CGContextRef)ctx inRect:(CGRect)rect{
    CGContextMoveToPoint(ctx, rect.size.width, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
}

- (void)addBottomBorder:(CGContextRef)ctx inRect:(CGRect)rect{
    CGContextMoveToPoint(ctx, 0, rect.size.height);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
}

- (void)addAllBorders:(CGContextRef)ctx inRect:(CGRect)rect{
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(ctx,  0, rect.size.height);
    CGContextAddLineToPoint(ctx,  0, 0);
}

- (void)updateAllBorders:(CGContextRef)ctx{
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(ctx, self.strokColor.CGColor);
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetLineWidth(ctx, self.borderWidth);
    if (_borderStyle == YMMBorderStyleDotted) {
        CGFloat length[] = {5, 5};
        CGContextSetLineDash(ctx, 0, length, 2);
    }
    
    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);
}

- (void)clearAllBorders:(CGContextRef)ctx{
    CGContextBeginPath(ctx);
}


#pragma mark - getter
- (UIColor *)strokColor{
    return _strokColor ?: DefaultStrokeColor;
}

- (UIColor *)fillColor{
    return _fillColor ?: DefaultFillColor;
}

- (CGFloat)borderWidth{
    return _borderWidth ?: DefaultBorderWidth;
}

@end
