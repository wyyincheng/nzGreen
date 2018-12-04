//
//  YZAgentGoodsModel.m
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAgentGoodsModel.h"

@implementation YZAgentGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"productId":@"id"};
}

- (NSString *)image {
    if (_image) {
        return [NSString stringWithFormat:@"https://www.nzgreens.com%@",_image];
    }
    return nil;
}

@end
