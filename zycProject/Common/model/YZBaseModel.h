//
//  YZBaseModel.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZBaseModel : NSObject

+ (id)yz_objectWithKeyValues:(id)keyValues;

+ (NSArray *)yz_objectArrayWithKeyValuesArray:(NSArray *)dictArray;

@end

NS_ASSUME_NONNULL_END
