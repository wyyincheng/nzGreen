//
//  YZSwitchTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SwitchInfoBlock)(NSInteger index);

@interface YZSwitchTableCell : YZBaseTableViewCell

@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, copy) SwitchInfoBlock switchInfoBlock;

@end

NS_ASSUME_NONNULL_END
