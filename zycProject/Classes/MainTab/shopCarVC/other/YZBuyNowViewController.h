//
//  YZBuyNowViewController.h
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

static NSString * const kYZLauchParams_GoodsModel = @"kYZLauchParams_GoodsModel";
static NSString * const kYZLauchParams_GoodsDict = @"kYZLauchParams_GoodsDict";

typedef NS_ENUM(NSUInteger, BuyType) {
    BuyType_Default = 0,
    BuyType_Merge = 2,
    BuyType_ReSubmit = 3,
    BuyType_GoodsDetail = 4
};

@interface YZBuyNowViewController : YZBaseViewController

@end

NS_ASSUME_NONNULL_END
