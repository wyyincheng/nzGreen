//
//  YZAgentOrderDetailModel.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "YZAddressModel.h"
#import "YZGoodsFreightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZAgentOrderItemModel : YZBaseModel

@property (nonatomic, copy) NSString *image;//商品title
@property (nonatomic, assign) BOOL mergeShow;
@property (nonatomic, assign) NSInteger mergeStatus;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, assign) NSInteger productNumber;
@property (nonatomic, strong) NSNumber *productTotalPrice;
@property (nonatomic, strong) NSNumber *sellingPrice;
@property (nonatomic, copy) NSString *title;//商品title
@property (nonatomic, assign) NSInteger weight;//商品title
@property (nonatomic, strong) YZGoodsFreightModel *productFreight;

@end

@interface YZAgentOrderDetailModel : YZBaseModel

@property (nonatomic, assign) NSInteger  agentFeight;
@property (nonatomic, strong) NSNumber *agentOrderPrice;
@property (nonatomic, assign) NSInteger canAdopt;
@property (nonatomic, strong) NSNumber *freight;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *orderNumber;//订单号
@property (nonatomic, strong) NSNumber *price;//总金额
@property (nonatomic, strong) NSNumber *productPrice;//商品金额
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, assign) NSInteger userOrderStatus;
@property (nonatomic, strong) YZAddressModel *addressItem;
@property (nonatomic, strong) NSArray  *orderItemDetailList;

@end

NS_ASSUME_NONNULL_END
