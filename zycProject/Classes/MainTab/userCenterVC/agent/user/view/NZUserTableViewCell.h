//
//  NZUserTableViewCell.h
//  nzGreens
//
//  Created by yc on 2018/5/26.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "YZBaseTableViewCell.h"
#import "YZAccountModel.h"

typedef void(^ChongBlock)(YZAccountModel *user);
typedef void(^TuiBlock)(YZAccountModel *user);

@interface NZUserTableViewCell : YZBaseTableViewCell

@property (nonatomic, copy) ChongBlock chongBlock;
@property (nonatomic, copy) TuiBlock tuiBlock;

@end
