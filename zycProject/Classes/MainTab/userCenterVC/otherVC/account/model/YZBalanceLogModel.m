//
//  YZBalanceLogModel.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBalanceLogModel.h"

@implementation YZBalanceLogModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"logId":@"id"};
}

- (NSString *)avatar {
    return [_avatar imageUrlString];
}

@end
