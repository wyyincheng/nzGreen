//
//  NSString+NZCheck.m
//  nzGreens
//
//  Created by yc on 2018/4/12.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "NSString+NZCheck.h"

@implementation NSString (NZCheck)

- (BOOL)isPhoneNumber {
#warning for yc
    return (11 == self.length);
}

- (BOOL)isPassword {
#warning for yc
    return self.length > 3;
}

@end
