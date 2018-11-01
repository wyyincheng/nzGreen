//
//  BaseService.h
//  IBZApp
//
//  Created by 尹成 on 16/6/13.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "NZError.h"

typedef void(^ProgressBlock)(NSProgress * _Nonnull uploadProgress);
typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error);
typedef void(^ManagerBlock)(AFHTTPSessionManager * _Nullable manager);

@interface YNCZBaseService : NSObject

@property (nonatomic, strong) ProgressBlock _Nonnull progress;
@property (nonatomic, strong) ManagerBlock _Nonnull manager;
@property (nonatomic, copy) SuccessBlock _Nonnull success;
@property (nonatomic, copy) FailureBlock _Nonnull failure;

@end
