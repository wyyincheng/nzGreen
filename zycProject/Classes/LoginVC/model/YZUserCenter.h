//
//  YZUserCenter.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZUserModel.h"
#import "YZAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZUserCenter : NSObject

+ (YZUserCenter *)shared;

+ (void)saveAppStatus:(NSInteger)hasReviewed;

@property (nonatomic, strong) YZUserModel *userInfo;
@property (nonatomic, strong) YZAccountModel *accountInfo;
//@property (nonatomic, assign) BOOL normalUser;
//@property (nonatomic, assign) BOOL canShowChongzhi;
//@property (nonatomic, assign) BOOL forceLogin;
//@property (nonatomic, assign) BOOL normalLogin;

/**
 AppStore是否审核通过
 */
@property (nonatomic, assign) BOOL hasReviewed;

/**
 是否展示loading场景
 */
@property (nonatomic, assign) BOOL showLoadScreen;

- (void)logOut;

- (void)gotoLogin;

/**
 用户手动退出登录
 */
- (void)custom_logOut;

@end

NS_ASSUME_NONNULL_END
