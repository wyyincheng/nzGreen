//
//  YZProductModel.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZProductModel.h"

@implementation YZProductModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"shoppingCartId":@"id"};
}

- (NSString *)image {
    return [_image imageUrlString];
}

@end
