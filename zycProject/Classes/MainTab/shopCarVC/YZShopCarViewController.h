//
//  YZShopCarViewController.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ShoppingCartType_Default = 0,
    ShoppingCartType_Pass = 1,
    ShoppingCartType_Merge = 2
} ShoppingCartType;

@interface YZShopCarViewController : YZBaseViewController

@property (nonatomic, assign) ShoppingCartType type;

@end

NS_ASSUME_NONNULL_END
