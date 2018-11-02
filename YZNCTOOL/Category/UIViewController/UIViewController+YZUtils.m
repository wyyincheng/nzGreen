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
    return [self currentViewController:[UIApplication sharedApplication].keyWindow];
}

+ (UIViewController*)topMostWindowController:(UIWindow *)window
{
    UIViewController *topController = [window rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])    topController = [topController presentedViewController];
    
    //  Returning topMost ViewController
    return topController;
}

+ (UIViewController*)currentViewController:(UIWindow *)window
{
    UIViewController *currentViewController = [self topMostWindowController:window];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}

@end
