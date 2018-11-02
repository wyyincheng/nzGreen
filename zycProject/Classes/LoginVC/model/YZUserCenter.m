//
//  YZUserCenter.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserCenter.h"

#import "YZLoginViewController.h"

@interface YZUserCenter ()

@property (nonatomic, strong) YZUserModel *realUserInfo;
@property (nonatomic, strong) YZUserModel *reviewUserInfo;

@end

@implementation YZUserCenter

static YZUserCenter *userCenter;

+ (YZUserCenter *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userCenter = [[YZUserCenter alloc] init];
        
        //读取AppStore审核状态
        NSString *appReviewFlag = [NSString stringWithFormat:@"%@%@",kYZUserDefault_AppReviewed,kYZAppVersion];
        BOOL appHasReviewed = [[NSUserDefaults standardUserDefaults] boolForKey:appReviewFlag];
        userCenter.hasReviewed = appHasReviewed;
    });
    return userCenter;
}

- (YZUserModel *)userInfo {
    return self.hasReviewed ? self.realUserInfo : self.reviewUserInfo;
}

- (void)setUserInfo:(YZUserModel *)userInfo {
    if (userInfo) {
        NSDictionary *dict = [NSDictionary yy_modelWithJSON:[userInfo yy_modelToJSONObject]];
        if (self.hasReviewed) {
            self.realUserInfo = userInfo;
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kYZUserDefault_UserInfoReal];
        } else {
            self.reviewUserInfo = userInfo;
            [[NSUserDefaults standardUserDefaults] setObject:dict forKey:kYZUserDefault_UserInfoReview];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (YZUserModel *)realUserInfo {
    if (!_realUserInfo) {
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kYZUserDefault_UserInfoReal];
        _realUserInfo = [YZUserModel yz_objectWithKeyValues:userDict];
    }
    return _realUserInfo;
}

- (YZUserModel *)reviewUserInfo {
    if (!_reviewUserInfo) {
        NSDictionary *userDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kYZUserDefault_UserInfoReview];
        _reviewUserInfo = [YZUserModel yz_objectWithKeyValues:userDict];
    }
    return _reviewUserInfo;
}

- (void)setHasReviewed:(BOOL)hasReviewed {
    //存储AppStore审核状态
    NSString *appReviewFlag = [NSString stringWithFormat:@"%@%@",kYZUserDefault_AppReviewed,kYZAppVersion];
    [[NSUserDefaults standardUserDefaults] setBool:hasReviewed forKey:appReviewFlag];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (BOOL)normalUser {
//    return YES;
//    return !self.userInfo.testMode;
//}
//
////- (BOOL)canShowChongzhi {
////    return self.userInfo.testMode;
////}
//
//- (void)setUserInfo:(UserModel *)userInfo {
//    _userInfo = userInfo;
//    _forceLogin = NO;
//    if (userInfo) {
//        [[NSUserDefaults standardUserDefaults] setValue:userInfo.userInfoDict forKey:userInfoDict];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    if (userInfo.token) {
//        [[AMKeychainManager defaultManager] setKeychainValue:userInfo.token forKey:userToken];
//    }
//}
//
//- (BOOL)normalLogin {
//    if (_normalLogin) {
//        return _normalLogin;
//    }
//    return [[NSUserDefaults standardUserDefaults] boolForKey:@"_normalLogin"];
//}
//
//- (void)setCanShowChongzhi:(BOOL)canShowChongzhi {
//    _canShowChongzhi = canShowChongzhi;
//
//    if (_canShowChongzhi != [[NSUserDefaults standardUserDefaults] boolForKey:@"_canShowChongzhi"]) {
//        _normalLogin = NO;
//        [[NSUserDefaults standardUserDefaults] setBool:_normalLogin forKey:@"_normalLogin"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        _userInfo = nil;
//        _forceLogin = YES;
//        [[AMKeychainManager defaultManager] removeKeychainEntryForKey:userToken];
//    }
//    [[NSUserDefaults standardUserDefaults] setBool:_canShowChongzhi forKey:@"_canShowChongzhi"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (void)logOut {
    
    [self clearLocalnUserInfo];
    
    [MBProgressHUD showMessageAuto:@"当前登录失效，请重新登录"];
    
    //FIXME: 重复弹窗
    id topVC = [UIViewController currentVC];
    if (![topVC isKindOfClass:[YZLoginViewController class]]) {
        [topVC presentViewController:[YZLoginViewController new]
                            animated:YES
                          completion:nil];
    }
    
    
//    if (![topVC isKindOfClass:[YZLoginViewController class]]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
//                                                                       message:@"当前登录失效，请重新登录"
//                                                                preferredStyle:UIAlertControllerStyleAlert];
//        [alert addAction:[UIAlertAction actionWithTitle:@"好的"
//                                                  style:UIAlertActionStyleDefault
//                                                handler:^(UIAlertAction * _Nonnull action) {
//                                                    [topVC presentViewController:[YZLoginViewController new]
//                                                                        animated:YES
//                                                                      completion:nil];
//                                                }]];
//        [topVC presentViewController:alert animated:YES completion:nil];
//    }
    
}

- (void)clearLocalnUserInfo {
    //删除本地
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kYZUserDefault_UserInfoReview];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kYZUserDefault_UserInfoReal];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //删除内存
//    _userInfo = nil;
    _realUserInfo = nil;
    _reviewUserInfo = nil;
}

@end
