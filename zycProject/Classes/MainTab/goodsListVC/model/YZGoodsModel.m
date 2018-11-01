//
//  YZGoodsModel.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsModel.h"

@implementation YZGoodsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"goodsId":@"id"};
}

- (NSString *)image {
    return [_image imageUrlString];
}

- (NSArray *)imageList {
    NSMutableArray *temp = [NSMutableArray array];
    for (NSString *url in _imageList) {
        [temp addObject:[url imageUrlString]];
    }
    return temp.count > 0 ? temp : nil;
}

@end
