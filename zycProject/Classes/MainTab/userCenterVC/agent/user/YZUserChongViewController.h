//
//  YZUserChongViewController.h
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

#import "YZAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, MangerType) {
    MangerType_Chong = 0,
    MangerType_Tui,
};

@interface YZUserChongViewController : YZBaseViewController

@property (nonatomic, assign) MangerType mangerType;
@property (nonatomic, strong) YZAccountModel *user;

@end

NS_ASSUME_NONNULL_END
