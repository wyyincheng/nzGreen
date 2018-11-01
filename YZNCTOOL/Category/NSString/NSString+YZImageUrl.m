//
//  NSString+YZImageUrl.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "NSString+YZImageUrl.h"

#define kBaseHostUrlString @"https://www.nzgreens.com"

@implementation NSString (YZImageUrl)

- (NSString *)imageUrlString {
    return [NSString stringWithFormat:@"%@%@",kBaseHostUrlString,self];
}

@end
