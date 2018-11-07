//
//  YZOrderSelectTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

#import "YZOrderManagerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^CaculateOrderPriceBlock)(YZOrderManagerModel *order);

@interface YZOrderSelectTableCell : YZBaseTableViewCell

@property (nonatomic, copy) CaculateOrderPriceBlock caculateBlock;

@end

NS_ASSUME_NONNULL_END
