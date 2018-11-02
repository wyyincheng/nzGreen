//
//  YZShopCarTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshPriceActionBlock)(void);

@interface YZShopCarTableCell : YZBaseTableViewCell

@property (nonatomic, copy) RefreshPriceActionBlock refreshPriceBlock;

@end

NS_ASSUME_NONNULL_END
