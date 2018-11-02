//
//  YZMainViewController.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YZVCIndex) {
    YZVCIndex_Home = 0,
    YZVCIndex_ShopCar,
    YZVCIndex_UserCenter
};

@interface YZMainViewController : UITabBarController

- (void)gotoIndexVC:(YZVCIndex)vcIndex;

@end

NS_ASSUME_NONNULL_END
