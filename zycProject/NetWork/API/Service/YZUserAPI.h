//
//  YZUserAPI.h
//  IBZApp
//
//  Created by 尹成 on 16/6/12.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YNCZBaseService.h"

@interface YZUserAPI : YNCZBaseService

- (void)registerWithPhone:(NSString *)phone
                 password:(NSString *)password
                  success:(SuccessBlock)success
                  failure:(FailureBlock)failure;

/**
 用户登录
 
 @param phone 手机号
 @param password 密码
 @param success 成功回调
 @param failure 失败回调
 */
- (void)loginWithPhone:(NSString *)phone
              password:(NSString *)password
               success:(SuccessBlock)success
               failure:(FailureBlock)failure;

/**
 用户退出
 
 @param success 成功回调
 @param failure 失败回调
 */
- (void)logoutWithSuccess:(SuccessBlock)success
                  failure:(FailureBlock)failure;

- (void)changePwdWithOldPassword:(NSString *)oldPassword
                     newPassword:(NSString *)newPassword
                         success:(SuccessBlock)success
                         failure:(FailureBlock)failure;

- (void)getUserInfoWithSuccess:(SuccessBlock)success
                       failure:(FailureBlock)failure;

- (void)addAddressWithAddress:(NSString *)address
                      contact:(NSString *)contact
                    telephone:(NSString *)telephone
                    isDefault:(NSInteger)isDefault
                      success:(SuccessBlock)success
                      Failure:(FailureBlock)failure;

- (void)getDefaultAddressWithSuccess:(SuccessBlock)success
                             Failure:(FailureBlock)failure;

- (void)getAddressListWithPage:(NSInteger)pageIndex
                       success:(SuccessBlock)success
                       Failure:(FailureBlock)failure;

- (void)updateAddressWithAddressId:(NSNumber *)addressId
                           address:(NSString *)address
                           contact:(NSString *)contact
                         telephone:(NSString *)telephone
                         isDefault:(NSInteger)isDefault
                           success:(SuccessBlock)success
                           Failure:(FailureBlock)failure;

//- (void)setAddressDefaultWithAddressId:(NSNumber *)addressId
//                             isDefault:(NSInteger)isDefault
//                               success:(SuccessBlock)success
//                               Failure:(FailureBlock)failure;

- (void)delAddressWithAddressId:(NSNumber *)addressId
                        success:(SuccessBlock)success
                        Failure:(FailureBlock)failure;

- (void)delAccountLogWithLogId:(NSNumber *)logId
                       success:(SuccessBlock)success
                       Failure:(FailureBlock)failure;

- (void)getUserListWithPage:(NSInteger)page
                    success:(SuccessBlock)success
                    Failure:(FailureBlock)failure;

- (void)chongBalanceWithAmount:(CGFloat)amount userId:(NSNumber *)userId type:(NSInteger)type success:(SuccessBlock)success Failure:(FailureBlock)failure;

- (void)getAboutInfoWithSuccess:(SuccessBlock)success Failure:(FailureBlock)failure;

- (void)updateUserInfoWithAvart:(NSString *)avartData
                      avartName:(NSString *)avartName
                       nickName:(NSString *)nickName
                        success:(SuccessBlock)success
                        Failure:(FailureBlock)failure;

- (void)getStoreInfoWithPageIndex:(NSInteger)pageIndex
                          success:(SuccessBlock)success
                          Failure:(FailureBlock)failure;

- (void)changeSalePriceWithProductId:(NSString *)productId
                          agentPrice:(NSString *)agentPrice
                             success:(SuccessBlock)success
                             Failure:(FailureBlock)failure;

- (void)updateStoreInfoWithShopName:(NSString *)shopName
                          shopImage:(NSString *)shopImage
                          imageName:(NSString *)imageName
                            success:(SuccessBlock)success
                            Failure:(FailureBlock)failure;

- (void)getShopInfoWithSuccess:(SuccessBlock)success
                       Failure:(FailureBlock)failure;

@end
