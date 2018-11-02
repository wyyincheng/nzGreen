//
//  YZBaseTableViewCell.h
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZBaseTableViewCell : UITableViewCell

+ (YZBaseTableViewCell *)yz_createCellForTableView:(UITableView *)tableView;

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width;

- (void)yz_configWithModel:(id)model;

+ (NSString *)yz_cellIdentifiler;

@end

NS_ASSUME_NONNULL_END
