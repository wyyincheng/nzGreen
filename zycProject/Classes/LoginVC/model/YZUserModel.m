//
//  YZUserModel.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserModel.h"

#import "MJExtension.h"
#import "NSString+YZImageUrl.h"

@implementation YZUserModel

+ (id)yc_objectWithKeyValues:(id)keyValues {
    YZUserModel *mode = [YZUserModel mj_objectWithKeyValues:keyValues];
    if ([keyValues isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:keyValues];
        [mDict removeObjectForKey:@"token"];
        mode.userInfoDict = mDict;
    }
    return mode;
}

- (NSString *)shopImage {
    return [_shopName imageUrlString];
}

//+ (void)checkLoginStatu{
//    if ([UserModel getUserInfo]) {
//        UserModel *user = [UserModel getUserInfo];
//        [[BaseAPI sharedAPI].userService queryUserInfoWithUid:user.Uid
//                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                                                          if ((0 != [[responseObject yc_objectForKey:@"ErrorCode"] intValue]) ||
//                                                              [responseObject yc_objectForKey:@"Data"] == nil ||
//                                                              ([responseObject yc_objectForKey:@"Data"] == [NSNull null])) {
//
//                                                              return;
//                                                          }
//
//
//                                                          UserModel *tempModel = [self mj_objectWithKeyValues:[responseObject yc_objectForKey:@"Data"] context:nil];
//                                                          if (tempModel) {
//                                                              [tempModel saveUserInfo];
//                                                          }
//                                                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//                                                      }];
//    }
//}

//- (void)saveUserInfo{
//
//    [[BaseAPI sharedAPI].userService WriteAppTagWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"--------------------\n%@",responseObject);
//    } failure:nil];
//
//    NSData *UserData = [NSKeyedArchiver archivedDataWithRootObject:self];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:UserData forKey:@"UserData"];
//    [defaults synchronize];
//}
//
//+ (void)clearUserInfo{
//
//    [[BaseAPI sharedAPI].userService ClearAppTagWithSuccess:nil failure:nil];
//
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:@"UserData"];
//    [userDefaults synchronize];
//}

//+ (YZUserModel *)getUserInfo{
//    
//    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//    NSData *data = [user objectForKey:@"UserData"];
//    
//    if (!data) {
//        return nil;
//    }
//    
//    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
//}

//+ (instancetype)yc_objectWithKeyValues:(id)keyValues{
//
//    if ((0 != [[keyValues yc_objectForKey:@"ErrorCode"] intValue])) {
//
////    if ((0 != [[keyValues yc_objectForKey:@"ErrorCode"] intValue]) ||
////        [keyValues yc_objectForKey:@"Data"] == nil ||
////        ([keyValues yc_objectForKey:@"Data"] == [NSNull null])) {
//
//        [MBProgressHUD showMessageAuto:[NSString stringWithFormat:@"%@",[keyValues yc_objectForKey:@"ErrorMsg"]]];
//        return nil;
//    }
//
//    return [self mj_objectWithKeyValues:[keyValues yc_objectForKey:@"Data"] context:nil];
//}

//- (NSString *)Mobile{
//    return [[NSString stringWithFormat:@"%@",_Mobile] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//}

//- (NSString *)UserName{
//
//    if (self.Mobile) {
//        return _UserName ? _UserName : [[NSString stringWithFormat:@"%@",self.Mobile] stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
//    }
//    return _UserName;
//}
//
//- (NSString *)getTureUserName{
//    return _UserName;
//}


@end
