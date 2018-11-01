//
//  NSArray+YMMSafe.h
//  GoodTransport
//
//  Created by 尹成 on 2017/12/26.
//  Copyright © 2017年 Yunmanman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YMMSafe)

/**
 从数组中获取integer类型值
 
 @param index index
 @return index对应value，失败则返回0
 */
- (NSInteger)ymm_integerAtIndex:(NSUInteger)index;

/**
 从数组中获取string类型值
 
 @param index index
 @return index对应value，失败则返回nil
 */
- (NSString *)ymm_stringAtIndex:(NSUInteger)index;

/**
 从数组中获取number类型值
 
 @param index index
 @return index对应value，失败则返回nil
 */
- (NSNumber *)ymm_numberAtIndex:(NSUInteger)index;

/**
 从数组中获取数组类型值
 
 @param index index
 @return index对应value，失败则返回nil
 */
- (NSArray *)ymm_arrayAtIndex:(NSUInteger)index;

/**
 从数组中获取字典类型值
 
 @param index index
 @return index对应value，失败则返回nil
 */
- (NSDictionary *)ymm_dictAtIndex:(NSUInteger)index;

- (id)ymm_objectAtIndex:(NSUInteger)index;

@end
