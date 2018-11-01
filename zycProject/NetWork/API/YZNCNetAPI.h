//
//  BaseAPI.h
//  IBZApp
//
//  Created by yc on 16/5/20.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "YZUserAPI.h"
#import "OrderAPI.h"
#import "ProductAPI.h"

@interface YZNCNetAPI : NSObject

@property (strong, nonatomic) YZUserAPI    *userAPI;
@property (strong, nonatomic) OrderAPI   *orderAPI;
@property (strong, nonatomic) ProductAPI *productAPI;

+ (YZNCNetAPI *)sharedAPI;

@end
