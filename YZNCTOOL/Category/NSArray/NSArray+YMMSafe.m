//
//  NSArray+YMMSafe.m
//  GoodTransport
//
//  Created by 尹成 on 2017/12/26.
//  Copyright © 2017年 Yunmanman. All rights reserved.
//

#import "NSArray+YMMSafe.h"

@implementation NSArray (YMMSafe)

- (NSInteger)ymm_integerAtIndex:(NSUInteger)index {
    id value = [self ymm_objectAtIndex:index];
    if (value && [value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    }
    return 0;
}

- (NSString *)ymm_stringAtIndex:(NSUInteger)index {
    id value = [self ymm_objectAtIndex:index];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    }
    return nil;
}

- (NSNumber *)ymm_numberAtIndex:(NSUInteger)index {
    id value = [self ymm_objectAtIndex:index];
    if (value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return value;
        }
        if ([value respondsToSelector:@selector(integerValue)]) {
            return [NSNumber numberWithInteger:[value integerValue]];
        }
    }
    return nil;
}

- (NSArray *)ymm_arrayAtIndex:(NSUInteger)index {
    id value = [self ymm_objectAtIndex:index];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)ymm_dictAtIndex:(NSUInteger)index {
    id value = [self ymm_objectAtIndex:index];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (id)ymm_objectAtIndex:(NSUInteger)index {
    //FIXME: for yc runtime 拦截过一次，是否需要再次拦截
    if (index < self.count) {
        id value = [self objectAtIndex:index];
        if (value != [NSNull null]) {
            return value;
        }
    }
    return nil;
}

@end
