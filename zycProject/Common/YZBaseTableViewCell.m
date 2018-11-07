//
//  YZBaseTableViewCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

@implementation YZBaseTableViewCell

+ (YZBaseTableViewCell *)yz_createCellForTableView:(UITableView *)tableView {
    YZBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self yz_cellIdentifiler]];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault
                           reuseIdentifier:[self yz_cellIdentifiler]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return cell;
}

+ (CGFloat)yz_heightForCellWithModel:(nullable id)model contentWidth:(CGFloat)width {
    return 0.0f;
}

- (void)yz_configWithModel:(nullable id)model {
    
}

+ (NSString *)yz_cellIdentifiler {
    return [NSString stringWithFormat:@"kYZ%@Identifiler",NSStringFromClass([self class])];
}

@end
