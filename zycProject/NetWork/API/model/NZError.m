//
//  NZError.m
//  nzGreens
//
//  Created by yc on 2018/5/6.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "NZError.h"

@implementation NZError

- (NSString *)description {
    return [NSString stringWithFormat:@"错误信息（%ld）：%@",(long)self.code,self.msg];
}

@end
