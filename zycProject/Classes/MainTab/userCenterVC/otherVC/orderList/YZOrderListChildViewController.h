//
//  YZOrderListChildViewController.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZOrderListChildViewController : YZBaseViewController

@property (nonatomic, assign) NSInteger status;

- (void)refreshGoods:(BOOL)isRefresh;

@end

NS_ASSUME_NONNULL_END
