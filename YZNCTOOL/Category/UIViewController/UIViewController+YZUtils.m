//
//  UIViewController+YZUtils.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "UIViewController+YZUtils.h"

#import <IQKeyboardManager/IQUIView+Hierarchy.h>

@implementation UIViewController (YZUtils)

+ (UIViewController *)currentVC {
    return [[UIApplication sharedApplication].keyWindow currentViewController];
}

@end
