//
//  YZBaseViewController.h
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const kYZVCClassName = @"kYZVCClassName";
static NSString * const kYZVCDefaultEmptyIcon = @"icon_vcdefault_empty";

@interface YZBaseViewController : UIViewController

/**
 初始化参数
 */
@property (nonatomic, strong) NSDictionary *lauchParams;

/**
 页面跳转

 @param vcName 目标页面xib类名
 */
- (void)gotoViewController:(NSString *)vcName;

- (void)gotoViewController:(NSString *)vcName
               lauchParams:(nullable NSDictionary *)lauchParams;

@end

NS_ASSUME_NONNULL_END
