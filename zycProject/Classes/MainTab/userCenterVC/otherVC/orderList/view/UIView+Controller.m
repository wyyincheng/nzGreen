//
//  UIView+Controller.m
//  Shipper
//
//  Created by 曹昊 on 15/7/13.
//  Copyright (c) 2015年 上海细微信息咨询有限公司. All rights reserved.
//

#import "UIView+Controller.h"

@implementation UIView (Controller)

- (id)topViewController
{
    id next = [self nextResponder];
    if ([next isKindOfClass:[UIViewController class]]) {
        return next;
    }
    if (self.superview) {
        id sub = [self.superview topViewController];
        if ([sub isKindOfClass:[UIViewController class]]) {
            return sub;
        }
    }
    
//    for (UIView *iter in [self.subviews reverseObjectEnumerator]) {
//        id sub = [iter topViewController];
//        if ([sub isKindOfClass:[UIViewController class]]) {
//            return sub;
//        }
//    }
    return nil;
}

@end
