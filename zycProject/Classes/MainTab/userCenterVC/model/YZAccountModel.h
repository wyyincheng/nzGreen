//
//  YZAccountModel.h
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZAccountModel : YZBaseModel

@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, strong) NSNumber *userId;

@property (nonatomic, strong) NSNumber *tempId;

@end

NS_ASSUME_NONNULL_END
