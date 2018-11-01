//
//  BaseAPI.m
//  IBZApp
//
//  Created by yc on 16/5/20.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "YZNCNetAPI.h"

static YZNCNetAPI *api;

@implementation YZNCNetAPI
+ (YZNCNetAPI *)sharedAPI{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[YZNCNetAPI alloc] init];
    });
    return api;
}


- (id)init
{
    self = [super init];
    if(self)
    {
        _userAPI = [[YZUserAPI alloc] init];
        _orderAPI = [[OrderAPI alloc] init];
        _productAPI = [[ProductAPI alloc] init];
    }
    return (self);
}
@end
