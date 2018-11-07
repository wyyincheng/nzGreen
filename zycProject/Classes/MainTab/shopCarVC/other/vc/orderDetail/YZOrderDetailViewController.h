//
//  YZOrderDetailViewController.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

/**
 回退方式
 
 - BackType_Default: 返回上一页
 - BackType_Home: 返回首页（poptoroot）
 - BackType_From: 返回来源页（回退三次）
 */
typedef NS_ENUM(NSUInteger, BackType) {
    BackType_Default = 0,
    BackType_Home,
    BackType_From,
};

/**
 来源
 
 - FromType_Default: 默认（运单列表）
 - FromType_AgentManger: 代理订单管理列表
 */
typedef NS_ENUM(NSUInteger, FromType) {
    FromType_Default = 0,
    FromType_AgentManger,
};

typedef NS_ENUM(NSUInteger, OrderType) {
    OrderTyp_Normal = 0,
    OrderTyp_Agent,
};

@interface YZOrderDetailViewController : YZBaseViewController

@property (nonatomic, copy) NSString *orderNumber;//订单号
@property (nonatomic, assign) OrderType orderType;
@property (nonatomic, assign) BackType backType;
@property (nonatomic, assign) FromType fromType;

@end

NS_ASSUME_NONNULL_END
