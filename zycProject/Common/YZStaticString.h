//
//  YZStaticString.h
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#ifndef YZStaticString_h
#define YZStaticString_h

/**
 普通用户：-1：已驳回 0：待确认 3：已处理
 代理用户：-1：已驳回 0：待确认 1：待发货 2：已完成
 */
typedef NS_ENUM(NSInteger, UserOrderStatus) {
    UserOrderStatus_Reject = -1,
    UserOrderStatus_WaitConfirm = 0,
    UserOrderStatus_WaitSend = 1,
    UserOrderStatus_Finished = 2,
    UserOrderStatus_Dealed = 3
};

//This App Info


//notification name
static NSString * const kYZWeixinPaySuccessPushFlag = @"WeixinPaySuccessPush";
static NSString * const kYZWeixinPayFaliurePushFlag = @"WeixinPayFaliurePush";
static NSString * const kYZNotification_HiddenKeyBoard = @"kYZNotification_HiddenKeyBoard";

//third lib
static NSString * const kYZLeanCloud_AppId = @"6n5w8re56d5GYFbVJGmnLQdp-gzGzoHsz";

static NSString * const kYZLeanCloud_AppKey = @"pOLrsEybPSlvKxoKLM2q2YBf";

static NSString * const kYZWeixinPay_AppId = @"wx3103de4df49bc68c";

static NSString * const kYZBugly_AppId = @"c6cbb003f3";

//leanCloud ClassName
//AppStoreInfo
static NSString * const kYZClass_AppStoreInfo = @"YZAppStore";
static NSString * const kYZClassAppStore_AppVersion = @"appVersion";
static NSString * const kYZClassAppStore_HasReviewed = @"hasReviewed";
static NSString * const kYZClassAppStore_ShowLoadScreen = @"loadingScreen";

static NSString * const kYZClass_RegisterToken = @"RegisterToken";

//userdefault flag
//UserInfo
static NSString * const kYZUserDefault_UserInfoReal = @"kYZUserDefault_UserInfoReal";
static NSString * const kYZUserDefault_UserInfoReview = @"kYZUserDefault_UserInfoReview";
//AppInfo
static NSString * const kYZUserDefault_AppReviewed = @"kYZUserDefault_AppReviewed";

//other
static NSString * const kYZDictionary_TitleKey = @"title";
static NSString * const kYZDictionary_InfoKey = @"info";

#endif /* YZStaticString_h */
