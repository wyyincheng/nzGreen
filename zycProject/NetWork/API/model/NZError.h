//
//  NZError.h
//  nzGreens
//
//  Created by yc on 2018/5/6.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NZError : NSObject

@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy)   NSString *msg;

@end
