//
//  AppDelegate.m
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import "AppDelegate.h"

#import <Bugly/Bugly.h>
#import "YZStaticString.h"
#import <WechatOpenSDK/WXApi.h>

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate

#pragma mark - delegate
#pragma mark WXPay delegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case 0:
                YCLog(@"支付成功！");
                [[NSNotificationCenter defaultCenter] postNotificationName:kYZWeixinPaySuccessPushFlag object:nil];
                break;
            default:
                YCLog(@"支付失败！");
                [[NSNotificationCenter defaultCenter] postNotificationName:kYZWeixinPayFaliurePushFlag object:nil];
                break;
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Bugly startWithAppId:kYZBugly_AppId];
    [WXApi registerApp:kYZWeixinPay_AppId];
    
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
