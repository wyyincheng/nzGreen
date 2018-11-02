//
//  YZOrderListTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^PingjiaBlock)(id itemModel);

@interface YZOrderListTableCell : YZBaseTableViewCell

@property (nonatomic, copy) PingjiaBlock pingjiaBlock;

@end

NS_ASSUME_NONNULL_END
