//
//  YZOrderManagerModel.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "YZGoodsFreightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZOrderManagerItemModel : YZBaseModel

@property (nonatomic, assign) BOOL canMerge;

@property (nonatomic, copy) NSString *title;//商品title
@property (nonatomic, copy) NSString *image;//商品title
@property (nonatomic, assign) NSInteger weight;//商品title
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger productNumber;
@property (nonatomic, strong) NSNumber *productTotalPrice;
#warning for yc 缺失字段
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) YZGoodsFreightModel *productFreight;

@property (nonatomic, assign) BOOL selected;

@end


@interface YZOrderManagerModel : YZBaseModel

@property (nonatomic, strong) NSNumber *agentOrderPrice;

@property (nonatomic, copy) NSString *freight;//运费
@property (nonatomic, assign) BOOL canAdopt;//是否通过中选中

@property (nonatomic, assign) BOOL refuseShow; // 拒绝

/**
 普通用户：-1：已驳回 0：待确认 3：已处理
 代理用户：-1：已驳回 0：待确认 1：待发货 2：已完成
 */
@property (nonatomic, assign) NSInteger userOrderStatus;//用户订单状态
@property (nonatomic, assign) NSInteger agentStatus;//-1：已驳回 0：待确认 1： 已处理
@property (nonatomic, strong) NSNumber *productPrice;//商品金额
@property (nonatomic, strong) NSNumber *price;//总金额
@property (nonatomic, copy) NSString *orderNumber;//订单号
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, strong) NSArray *orderItemList;

@property (nonatomic, copy) NSString *totalNumber;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
