//
//  YZAccountModel.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAccountModel.h"

@implementation YZAccountModel

- (NSString *)avatar {
    return [_avatar imageUrlString];
}

- (NSNumber *)userId {
    if (_userId) {
        return _userId;
    }
    return self.tempId;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"tempId":@"id"};
}

@end
