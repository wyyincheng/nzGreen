//
//  NZStoreItemCell.h
//  nzGreens
//
//  Created by yc on 2018/5/27.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "YZBaseTableViewCell.h"
#import "YZAgentGoodsModel.h"

typedef void(^ChangePriceBlock)(YZAgentGoodsModel *goods);

@interface NZStoreItemCell : YZBaseTableViewCell

@property (nonatomic, copy) ChangePriceBlock changePriceBlock;

@end
