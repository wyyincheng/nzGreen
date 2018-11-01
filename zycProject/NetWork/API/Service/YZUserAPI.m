//
//  YZUserAPI.m
//  IBZApp
//
//  Created by 尹成 on 16/6/12.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "YZUserAPI.h"
#import "YCNetworkManager.h"
#import "Security.h"

static NSString *LoginAction                    = @"/user/login";
static NSString *LogoutAction                   = @"/user/loginOut";

@implementation YZUserAPI

- (void)loginWithPhone:(NSString *)phone password:(NSString *)password success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:phone forKey:@"userName"];
    [dictionary setValue:password forKey:@"password"];
    [dictionary setValue:[[NSUUID UUID] UUIDString] forKey:@"deviceId"];
    
    [[YCNetworkManager shared] post:LoginAction
                         parameters:dictionary
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getUserInfoWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [[YCNetworkManager shared] get:@"/user/info"
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)logoutWithSuccess:(SuccessBlock)success failure:(FailureBlock)failure {
    [[YCNetworkManager shared] post:LogoutAction
                         parameters:nil
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)changePwdWithOldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(SuccessBlock)success failure:(FailureBlock)failure {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:oldPassword forKey:@"oldPassword"];
    [dictionary setValue:newPassword forKey:@"newPassword"];
    
    [[YCNetworkManager shared] put:@"/password"
                        parameters:dictionary
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)addAddressWithAddress:(NSString *)address contact:(NSString *)contact telephone:(NSString *)telephone isDefault:(NSInteger)isDefault success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:address forKey:@"address"];
    [dictionary setValue:contact forKey:@"contact"];
    [dictionary setValue:telephone forKey:@"telephone"];
    [dictionary setValue:@(isDefault) forKey:@"isDefault"];
    
    [[YCNetworkManager shared] post:@"/address"
                         parameters:dictionary
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getDefaultAddressWithSuccess:(SuccessBlock)success Failure:(FailureBlock)failure {
    [[YCNetworkManager shared] get:@"/address/default"
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getAddressListWithPage:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:@"/address"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

//- (void)setAddressDefaultWithAddressId:(NSNumber *)addressId isDefault:(NSInteger)isDefault success:(SuccessBlock)success Failure:(FailureBlock)failure {
//    NSString *url = [NSString stringWithFormat:@"/address/%@",addressId];
//    
//    [[YCNetworkManager shared] put:url
//                        parameters:@{@"isDefault":@(isDefault)}
//                          progress:nil
//                           success:success
//                           failure:failure];
//}

- (void)updateAddressWithAddressId:(NSNumber *)addressId address:(NSString *)address contact:(NSString *)contact telephone:(NSString *)telephone isDefault:(NSInteger)isDefault success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:address forKey:@"address"];
    [dictionary setValue:contact forKey:@"contact"];
    [dictionary setValue:telephone forKey:@"telephone"];
    [dictionary setValue:@(isDefault) forKey:@"isDefault"];
    
    [[YCNetworkManager shared] put:[NSString stringWithFormat:@"/address/%@",addressId]
                         parameters:dictionary
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)delAddressWithAddressId:(NSNumber *)addressId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"/address/%@",addressId];
    [[YCNetworkManager shared] delete:url
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)delAccountLogWithLogId:(NSNumber *)logId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"/coins/%@",logId];
    [[YCNetworkManager shared] delete:url
                           parameters:nil
                             progress:nil
                              success:success
                              failure:failure];
}

- (void)getUserListWithPage:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:@"/user/manage"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)chongBalanceWithAmount:(CGFloat)amount userId:(NSNumber *)userId type:(NSInteger)type success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(amount) forKey:@"amount"];
    [dict setValue:@(type) forKey:@"type"];
    
    [[YCNetworkManager shared] post:[NSString stringWithFormat:@"/coins/%@",userId]
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getAboutInfoWithSuccess:(SuccessBlock)success Failure:(FailureBlock)failure {
    [[YCNetworkManager shared] get:@"/about"
                         parameters:nil
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)updateUserInfoWithAvart:(NSString *)avartData avartName:(NSString *)avartName nickName:(NSString *)nickName success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:nickName forKey:@"nickname"];
    [dict setValue:avartData forKey:@"avatar"];
    [dict setValue:avartName forKey:@"avatarName"];
    
    [[YCNetworkManager shared] put:@"/user/update"
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getStoreInfoWithPageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    [[YCNetworkManager shared] get:@"/products/manage"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)changeSalePriceWithProductId:(NSString *)productId agentPrice:(NSString *)agentPrice success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:agentPrice forKey:@"agentPrice"];
    
    [[YCNetworkManager shared] put:[NSString stringWithFormat:@"/products/manage/%@",productId]
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)updateStoreInfoWithShopName:(NSString *)shopName shopImage:(NSString *)shopImage imageName:(NSString *)imageName success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:shopName forKey:@"shopName"];
    [dict setValue:shopImage forKey:@"shopImage"];
    [dict setValue:imageName forKey:@"imageName"];
    
    [[YCNetworkManager shared] put:@"/shop"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getShopInfoWithSuccess:(SuccessBlock)success Failure:(FailureBlock)failure {
    [[YCNetworkManager shared] get:@"/shop"
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

@end
