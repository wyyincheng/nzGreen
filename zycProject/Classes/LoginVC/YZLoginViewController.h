//
//  YZLoginViewController.h
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZLoginViewController : YZBaseViewController

/**
 是否是启动登录
 启动登录无法后退，登录成功后跳转主页；
 非启动登录可后退，登录成功后dismiss；
 */
@property (nonatomic, assign) BOOL isLaunchLogin;
//
//@property (nonatomic, assign) BOOL hiddenBackBt;
//
//@property (nonatomic, assign) BOOL dissMissLoginVC;

@end

NS_ASSUME_NONNULL_END
