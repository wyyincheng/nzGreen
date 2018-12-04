//
//  NZStoreHeaerCell.h
//  nzGreens
//
//  Created by yc on 2018/5/27.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "YZBaseTableViewCell.h"
#import "YZShopInfoModel.h"

typedef void(^ChangeShopIconBlock)(void);
typedef void(^ChangeShopNameBlock)(NSString *name);

@interface NZStoreHeaerCell : YZBaseTableViewCell

@property (nonatomic, copy) ChangeShopIconBlock changeShopIconBlock;
@property (nonatomic, copy) ChangeShopNameBlock changeShopNameBlock;

@end
