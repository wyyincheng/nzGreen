//
//  YZAgentGoodsModel.h
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZAgentGoodsModel : YZBaseModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger salesVolume;
@property (nonatomic, strong) NSNumber *sellingPrice;
@property (nonatomic, strong) NSNumber *agentPrice;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
