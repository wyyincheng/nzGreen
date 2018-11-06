//
//  YZGoodsCountTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangeCountBlock)(NSInteger count);

@interface YZGoodsCountTableCell : YZBaseTableViewCell

@property (nonatomic, strong) YZGoodsModel *goodsModel;
@property (nonatomic, copy) ChangeCountBlock changCountBlock;

@end

NS_ASSUME_NONNULL_END
