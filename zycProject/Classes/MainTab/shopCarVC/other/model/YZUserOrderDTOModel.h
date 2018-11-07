//
//  YZUserOrderDTOModel.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZUserOrderDTOModel : YZBaseModel

@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, strong) NSArray *orderId;

@end

NS_ASSUME_NONNULL_END
