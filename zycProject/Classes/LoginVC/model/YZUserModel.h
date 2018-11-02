//
//  YZUserModel.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UserType) {
    UserType_Normal = 1,
    UserType_Agent = 2
};

@interface YZUserModel : YZBaseModel

/**
 不包含token的用户信息字典
 */
@property (nonatomic, strong) NSDictionary *userInfoDict;

/**
 用户token
 */
@property (copy, nonatomic  ) NSString *token;

/**
 商店名称
 */
@property (copy, nonatomic  ) NSString *shopName;

/**
 商店banner
 */
@property (copy, nonatomic) NSString *shopImage;

/**
 用户类型,1:普通用户 2:代理
 */
@property (assign, nonatomic) UserType userType;

@property (assign, nonatomic) BOOL testMode;

- (void)saveUserInfo;

+ (void)clearUserInfo;

//+ (YZUserModel *)getUserInfo;

@end

NS_ASSUME_NONNULL_END
