//
//  YZOrderModel.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "YZAddressModel.h"
#import "YZGoodsFreightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZOrderItemModel : YZBaseModel

@property (nonatomic, copy) NSString *title;//商品title
@property (nonatomic, copy) NSString *image;//商品title
@property (nonatomic, assign) NSInteger weight;//商品title
@property (nonatomic, assign) NSInteger commentStatus;//商品title
@property (nonatomic, assign) BOOL commentShow;//商品title
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, assign) NSInteger productNumber;
#warning for yc 缺失字段
@property (nonatomic, strong) NSNumber *sellingPrice;
@property (nonatomic, strong) YZGoodsFreightModel *productFreight;

@end

@interface YZOrderModel : YZBaseModel

@property (nonatomic, copy) NSString *orderNumber;//订单号

/**
 普通用户：-1：已驳回 0：待确认 3：已处理
 代理用户：-1：已驳回 0：待确认 1：待发货 2：已完成
 */
@property (nonatomic, assign) NSInteger userOrderStatus;//用户订单状态
@property (nonatomic, assign) BOOL canResend;
@property (nonatomic, strong) NSNumber *productPrice;//商品金额
@property (nonatomic, copy) NSString *freight;//运费
@property (nonatomic, strong) NSNumber *price;//总金额
@property (nonatomic, strong) NSArray *orderItemList;
//@property (nonatomic, assign) NSInteger commentStatus;//商品title
//@property (nonatomic, assign) BOOL commentShow;//商品title
@property (nonatomic, copy) NSString *productTotalNumber;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) BOOL logisticsShow;//": false
@property (nonatomic, copy) NSString *logisticsNumber;//": false
#warning for yc 缺失字段
@property (nonatomic, copy) NSString *logisticsCompany;
@property (nonatomic, strong) YZAddressModel *addressItem;

@end

NS_ASSUME_NONNULL_END
