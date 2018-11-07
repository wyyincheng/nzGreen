//
//  YZWuliuTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^RefreshWuliuIconBlock)(NSString *url,CGFloat width,CGFloat height);

@interface YZWuliuTableCell : YZBaseTableViewCell

@property (nonatomic, copy) RefreshWuliuIconBlock refreshIconBlock;

@end

NS_ASSUME_NONNULL_END
