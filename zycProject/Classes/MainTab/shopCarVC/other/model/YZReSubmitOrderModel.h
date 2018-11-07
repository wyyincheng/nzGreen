//
//  YZReSubmitOrderModel.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "YZAddressModel.h"
#import "YZGoodsFreightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZReSubmitOrderModel : YZBaseModel

@property (nonatomic, assign) NSInteger deliveryMode;
@property (nonatomic, strong) YZGoodsFreightModel *productFreight;
@property (nonatomic, strong) NSArray *productOrderList;
@property (nonatomic, strong) YZAddressModel *userAddress;

@end

NS_ASSUME_NONNULL_END
