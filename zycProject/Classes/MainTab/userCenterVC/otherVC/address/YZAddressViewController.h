//
//  YZAddressViewController.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

#import "YZAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectAddressBlock)(YZAddressModel *addressModel);

@interface YZAddressViewController : YZBaseViewController

@property (nonatomic, assign) BOOL needSelectAddress;
@property (nonatomic, copy) SelectAddressBlock selectAddressBlock;

@end

NS_ASSUME_NONNULL_END
