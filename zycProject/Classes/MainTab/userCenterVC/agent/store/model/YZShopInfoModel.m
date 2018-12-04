//
//  YZShopInfoModel.m
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZShopInfoModel.h"

@implementation YZShopInfoModel

- (NSString *)shopImage {
    if (_shopImage) {
        return [NSString stringWithFormat:@"https://www.nzgreens.com%@",_shopImage];
    }
    return nil;
}

@end
