//
//  YZProductTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshPriceBlock)(void);

@interface YZProductTableCell : YZBaseTableViewCell

@property (nonatomic, assign) BOOL canChangeCount;
@property (nonatomic, copy) RefreshPriceBlock refreshPriceBlock;

@end

NS_ASSUME_NONNULL_END
