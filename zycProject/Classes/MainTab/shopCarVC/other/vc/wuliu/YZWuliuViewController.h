//
//  YZWuliuViewController.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZWuliuViewController : YZBaseViewController

@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *logisticsNumber;
#warning for yc 缺失字段
@property (nonatomic, copy) NSString *logisticsCompany;

@end

NS_ASSUME_NONNULL_END
