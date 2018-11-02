//
//  YZAddressModel.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZAddressModel : YZBaseModel

#warning for yc 指给一个字段修改地址时无法切割开展示
@property (nonatomic, copy) NSString *address;//": "上海市浦东新区 xxx路401号",
@property (nonatomic, copy) NSString *contact;//": "小虫子",
@property (nonatomic, strong) NSNumber *addressId;//": 1,
@property (nonatomic, assign) NSInteger isDefault;//": 1,
@property (nonatomic, copy) NSString *telephone;//": "185********"

@end

NS_ASSUME_NONNULL_END
