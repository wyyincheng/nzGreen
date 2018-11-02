//
//  YZUserCenter.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YZUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZUserCenter : NSObject

+ (YZUserCenter *)shared;

@property (nonatomic, strong) YZUserModel *userInfo;
//@property (nonatomic, strong) AccountModel *demoUserInfo;
//@property (nonatomic, strong) AccountModel *accountInfo;
//@property (nonatomic, assign) BOOL normalUser;
//@property (nonatomic, assign) BOOL canShowChongzhi;
//@property (nonatomic, assign) BOOL forceLogin;
//@property (nonatomic, assign) BOOL normalLogin;

/**
 AppStore是否审核通过
 */
@property (nonatomic, assign) BOOL hasReviewed;

- (void)logOut;

@end

NS_ASSUME_NONNULL_END
