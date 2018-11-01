//
//  YZBaseModel.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "MJExtension.h"
//#import "NSArray+YMMSafe.h"
//#import "NSDictionary+YMMSafe.h"

@implementation YZBaseModel

MJCodingImplementation

+ (NSArray *)yz_objectArrayWithKeyValuesArray:(NSArray *)dictArray {
    return [self mj_objectArrayWithKeyValuesArray:dictArray];
}

+ (id)yz_objectWithKeyValues:(id)keyValues{
    return [self mj_objectWithKeyValues:keyValues context:nil];
    //
    //        if ((0 != [keyValues ymm_integerForKey:@"ErrorCode"]) ||
    //            [keyValues ymm_objectForKey:@"Data"] == nil ||
    //            ([keyValues ymm_objectForKey:@"Data"] == [NSNull null]) ) {
    //
    //            [MBProgressHUD showMessageAuto:[keyValues ymm_stringForKey:@"ErrorMsg"]];
    //            return nil;
    //        }
    //
    //    return nil;
}

- (NSString *)description{
    NSMutableString* text = [NSMutableString stringWithFormat:@"<%@> \n", [self class]];
    NSArray* properties = [self filterPropertys];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* key = (NSString*)obj;
        id value = [self valueForKey:key];
        NSString* valueDescription = (value)?[value description]:@"(null)";
        
        if ( ![value respondsToSelector:@selector(count)] && [valueDescription length]>60  ) {
            valueDescription = [NSString stringWithFormat:@"%@...", [valueDescription substringToIndex:59]];
        }
        valueDescription = [valueDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"\n   "];
        [text appendFormat:@"   [%@]: %@\n", key, valueDescription];
    }];
    [text appendFormat:@"</%@>", [self class]];;
    return text;
}

#pragma mark 获取一个类的属性列表
- (NSArray *)filterPropertys
{
    NSMutableArray* props = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for(int i = 0; i < count; i++){
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
        //        NSLog(@"name:%s",property_getName(property));
        //        NSLog(@"attributes:%s",property_getAttributes(property));
    }
    free(properties);
    return props;
}

@end
