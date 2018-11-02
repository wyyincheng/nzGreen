//
//  YZAddressAddViewController.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshAddressListBlock)(void);

static NSString * const kYZLauchParams_AddressModel = @"kYZLauchParams_AddressModel";

@interface YZAddressAddViewController : YZBaseViewController

//@property (nonatomic, strong) YZAddressModel *addressModel;
@property (nonatomic, copy) RefreshAddressListBlock refreshAddressBlock;

@end

NS_ASSUME_NONNULL_END
