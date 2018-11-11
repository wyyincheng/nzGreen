//
//  YCNetworkManager.h
//  nzGreens
//
//  Created by yc on 2018/4/22.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"
#import "AFHTTPSessionManager.h"
#import "NZError.h"

typedef void(^ProgressBlock)(NSProgress * _Nonnull uploadProgress);
typedef void(^SuccessBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^FailureBlock)(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error);
typedef void(^ManagerBlock)(AFHTTPSessionManager * _Nullable manager);

@interface YCNetworkManager : NSObject

@property (nonatomic, strong) ProgressBlock _Nonnull progress;
@property (nonatomic, copy) SuccessBlock _Nonnull success;
@property (nonatomic, copy) FailureBlock _Nonnull failure;
@property (nonatomic, copy) ManagerBlock _Nonnull manager;

+ (YCNetworkManager *_Nonnull)shared;

- (void)lc_post:(NSString *)method
     parameters:(NSDictionary *)parameters
       progress:(ProgressBlock)progress
        success:(SuccessBlock)success
        failure:(FailureBlock)failure;

-(void)post:(NSString * _Nonnull)method
 parameters:(NSDictionary * _Nullable)parameters
   progress:(ProgressBlock _Nullable)progress
    success:(SuccessBlock _Nonnull)success
    failure:(FailureBlock _Nullable)failure;

- (void)get:(NSString * _Nonnull)method
 parameters:(NSDictionary * _Nullable)parameters
   progress:(ProgressBlock _Nullable)progress
    success:(SuccessBlock _Nonnull)success
    failure:(FailureBlock _Nullable)failure;

- (void)put:(NSString *)method
 parameters:(NSDictionary *)parameters
   progress:(ProgressBlock)progress
    success:(SuccessBlock)success
    failure:(FailureBlock)failure;

- (void)delete:(NSString *)method
parameters:(NSDictionary *)parameters
progress:(ProgressBlock)progress
success:(SuccessBlock)success
failure:(FailureBlock)failure;

@end
