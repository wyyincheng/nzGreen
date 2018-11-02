//
//  YZOrderStatusTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RejectBlock)(id orderItem);
typedef void(^ReSubmitBlock)(id orderItem);

@interface YZOrderStatusTableCell : YZBaseTableViewCell

@property (nonatomic, copy) ReSubmitBlock reSubmitBlock;
@property (nonatomic, copy) RejectBlock rejectBlock;

@end

NS_ASSUME_NONNULL_END
