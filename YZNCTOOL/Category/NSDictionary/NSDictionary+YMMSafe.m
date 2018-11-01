//
//  NSDictionary+YMM.m
//  GoodTransport
//
//  Created by 尹成 on 2017/12/7.
//  Copyright © 2017年 Yunmanman. All rights reserved.
//

#import "NSDictionary+YMMSafe.h"

@implementation NSDictionary (YMMSafe)

- (NSDictionary *)ymm_dictForKey:(id)aKey {
    id value = [self ymm_objectForKey:aKey];
    if (value && [value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSArray *)ymm_arrayForKey:(id)aKey {
    id value = [self ymm_objectForKey:aKey];
    if (value && [value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSNumber *)ymm_numberForKey:(id)aKey {
    id value = [self ymm_objectForKey:aKey];
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

- (NSString *)ymm_stringForKey:(id)aKey {
    id value = [self ymm_objectForKey:aKey];
    if (value && [value isKindOfClass:[NSString class]]) {
        return value;
    }
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",value];
    }
    return nil;
}

- (NSInteger)ymm_integerForKey:(id)aKey {
    id value = [self ymm_objectForKey:aKey];
    if (value && [value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    }
    return 0;
}

- (id)ymm_objectForKey:(id)aKey {
    if(aKey == nil)
    return nil;
    id value = [self objectForKey:aKey];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end
