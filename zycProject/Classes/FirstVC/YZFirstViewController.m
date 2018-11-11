//
//  YZFirstViewController.m
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZFirstViewController.h"

#import "YZUserModel.h"
#import "YZMainViewController.h"
#import "YZLoginViewController.h"

@interface YZFirstViewController ()

//@property (nonatomic, assign) BOOL isRegister;

@end

@implementation YZFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /**
    本地记录当前版本已审核通过直接进入主页；
    否则查询当前版本审状态；
    查询到审核通过后本地记录；
    */
    if ([YZUserCenter shared].hasReviewed) {
        [self gotoNextVC];
    } else {
        [self checkAppReviewInfo];
    }
}

- (void)checkAppReviewInfo {
    AVQuery *query = [AVQuery queryWithClassName:kYZClass_AppStoreInfo];
    [query whereKey:kYZClassAppStore_AppVersion equalTo:kYZAppVersion];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [YZUserCenter shared].hasReviewed = [[objects firstObject] objectForKey:kYZClassAppStore_HasReviewed];
        }
        [self gotoNextVC];
    }];
}

- (void)gotoNextVC {
    YCLog(@"hasReview :%@",[YZUserCenter shared].hasReviewed ? @"hasReviewed" : @"notReview");
    
    /**
     读取本地存储用户信息：
     1.正在审核：读取Temp账号信息
     2.审核通过：读取用户真实信息
     本地信息读取不到时：
      跳转登录页面
     */
    
    id nextVC = nil;
    if ([YZUserCenter shared].hasReviewed && ![YZUserCenter shared].userInfo) {
        YZLoginViewController *loginVC = [YZLoginViewController new];
        loginVC.isLaunchLogin = YES;
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginVC.navigationController.navigationBar.hidden = YES;
        nextVC = nv;
    } else {
        nextVC = [YZMainViewController new];
    }
    
    UIWindow *window =  [[UIApplication sharedApplication].delegate window];
    window.rootViewController = nextVC;
}

@end
