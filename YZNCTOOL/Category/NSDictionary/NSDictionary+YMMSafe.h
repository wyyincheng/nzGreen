//
//  NSDictionary+YMM.h
//  GoodTransport
//
//  Created by 尹成 on 2017/12/7.
//  Copyright © 2017年 Yunmanman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (YMMSafe)

/**
 从字典中获取integer类型值

 @param aKey key
 @return key对应value，失败则返回0
 */
- (NSInteger)ymm_integerForKey:(id)aKey;

/**
 从字典中获取string类型值

 @param aKey key
 @return key对应value，失败则返回nil
 */
- (NSString *)ymm_stringForKey:(id)aKey;

/**
 从字典中获取number类型值
 
 @param aKey key
 @return key对应value，失败则返回nil
 */
- (NSNumber *)ymm_numberForKey:(id)aKey;

/**
 从字典中获取数组类型值
 
 @param aKey key
 @return key对应value，失败则返回nil
 */
- (NSArray *)ymm_arrayForKey:(id)aKey;

/**
 从字典中获取字典类型值
 
 @param aKey key
 @return key对应value，失败则返回nil
 */
- (NSDictionary *)ymm_dictForKey:(id)aKey;

- (id)ymm_objectForKey:(id)aKey;

@end
