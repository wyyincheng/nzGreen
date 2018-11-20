//
//  YCNetworkManager.m
//  nzGreens
//
//  Created by yc on 2018/4/22.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "YCNetworkManager.h"

#import "YZLoginViewController.h"

static NSString * const ServiceBaseURL = @"https://www.nzgreens.com";

static YCNetworkManager *_networkManager;

@implementation YCNetworkManager

+ (YCNetworkManager *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _networkManager = [[YCNetworkManager alloc] init];
    });
    return _networkManager;
}

- (void)lc_post:(NSString *)method
     parameters:(NSDictionary *)parameters
       progress:(ProgressBlock)progress
        success:(SuccessBlock)success
        failure:(FailureBlock)failure {
    
    [self yz_post:method
       parameters:parameters
      serviceType:1
          success:success
          failure:failure];
    
}

- (void)yz_post:(NSString *)method
     parameters:(NSDictionary *)parameters
    serviceType:(NSInteger)serviceType
        success:(SuccessBlock)success
        failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    if (0 == serviceType) {
        [manager.requestSerializer setValue:[self Authorization]
                         forHTTPHeaderField:@"Authorization"];
    } else {
        [manager.requestSerializer setValue:@"6n5w8re56d5GYFbVJGmnLQdp-gzGzoHsz"
                         forHTTPHeaderField:@"X-LC-Id"];
        [manager.requestSerializer setValue:@"pOLrsEybPSlvKxoKLM2q2YBf"
                         forHTTPHeaderField:@"X-LC-Key"];
    }
    [manager.requestSerializer setValue:@"application/json"
                     forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *baseServiceUrl = (0 == serviceType ? ServiceBaseURL : @"https://6n5w8re5.api.lncld.net/1.1");
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",baseServiceUrl,method];
    
    YCLog(@"\n==============开始请求网络===============\n%@ \n%@ \n=======================================",urlString,dict);
    
    [manager POST:urlString parameters:dict progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [MBProgressHUD hideHUD];
              
              if (0 != serviceType) {
                  if (success) {
                      success(task, responseObject);
                  }
              } else {
                  NSDictionary *resultDict = nil;
                  if ([responseObject isKindOfClass:[NSDictionary class]]) {
                      resultDict = responseObject;
                  } else if ([responseObject isKindOfClass:[NSData class]]) {
                      resultDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:nil];
                  }
                  
                  if ([resultDict yz_integerForKey:@"success"] == 1) {
                      //成功
                      success(task, [resultDict yz_objectForKey:@"data"]);
                  } else {
                      //失败
                      if (failure) {
                          if ([resultDict yz_integerForKey:@"code"] == (-1000)) {
                              [[YZUserCenter shared] logOut];
                          }
                          NZError *error = [[NZError alloc] init];
                          error.code = [resultDict yz_integerForKey:@"code"];
                          error.msg = [resultDict yz_stringForKey:@"msg"];
                          failure(task, error);
                      }
                  }
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              //        [busyView stopAnimating];
              //        [busyView removeFromSuperview];
              [MBProgressHUD hideHUD];
              NSLog(@"网络错误 ： %@",error);
              if (0 != serviceType) {
                  if (failure) {
                      NZError *nzError = [[NZError alloc] init];
                      //            nzError.msg = error.description;
                      nzError.msg = @"网络连接失败，稍后再试";
                      nzError.code = error.code;
                      failure(task, nzError);
                  }
              } else {
                  if (failure) {
                      NZError *nzError = [[NZError alloc] init];
                      //            nzError.msg = error.description;
                      nzError.msg = @"网络连接失败，稍后再试";
                      nzError.code = error.code;
                      failure(task, nzError);
                  } else {
                      NSLog(@"error:%@",error);
                      [MBProgressHUD showMessageAuto:@"网络连接失败，稍后再试"];
                  }
              }
          }];
}

- (void)post:(NSString *)method
  parameters:(NSDictionary *)parameters
    progress:(ProgressBlock)progress
     success:(SuccessBlock)success
     failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[self Authorization]
                     forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServiceBaseURL,method];
    
    YCLog(@"\n==============开始请求网络===============\n%@ \n%@ \n=======================================",urlString,dict);
    
    [manager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) {
            progress(uploadProgress);
        } else {
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        } else if ([responseObject isKindOfClass:[NSData class]]) {
            resultDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        }
        
        if ([resultDict yz_integerForKey:@"success"] == 1) {
            //成功
            success(task, [resultDict yz_objectForKey:@"data"]);
        } else {
            //失败
            if (failure) {
                if ([resultDict yz_integerForKey:@"code"] == (-1000)) {
                    [[YZUserCenter shared] logOut];
                }
                NZError *error = [[NZError alloc] init];
                error.code = [resultDict yz_integerForKey:@"code"];
                error.msg = [resultDict yz_stringForKey:@"msg"];
                failure(task, error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [busyView stopAnimating];
        //        [busyView removeFromSuperview];
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 ： %@",error);
        if (failure) {
            NZError *nzError = [[NZError alloc] init];
            //            nzError.msg = error.description;
            nzError.msg = @"网络连接失败，稍后再试";
            nzError.code = error.code;
            failure(task, nzError);
        } else {
            NSLog(@"error:%@",error);
            [MBProgressHUD showMessageAuto:@"网络连接失败，稍后再试"];
        }
    }];
}

- (void)get:(NSString *)method
 parameters:(NSDictionary *)parameters
   progress:(ProgressBlock)progress
    success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[self Authorization]
                     forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"HEAD", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServiceBaseURL,method];
    
    NSLog(@"\n==============开始请求网络===============\n%@ \n%@ \n=======================================",urlString,parameters);
    [manager GET:urlString
      parameters:parameters
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             [MBProgressHUD hideHUD];
             NSDictionary *resultDict = nil;
             if ([responseObject isKindOfClass:[NSDictionary class]]) {
                 resultDict = responseObject;
             } else if ([responseObject isKindOfClass:[NSData class]]) {
                 resultDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                              options:NSJSONReadingAllowFragments
                                                                error:nil];
             }
             
             if ([resultDict yz_integerForKey:@"success"] == 1) {
                 //成功
                 success(task, [resultDict yz_objectForKey:@"data"]);
             } else {
                 //失败
                 if ([resultDict yz_integerForKey:@"code"] == (-1000)) {
                     [[YZUserCenter shared] logOut];
                 }
                 if (failure) {
                     NZError *error = [[NZError alloc] init];
                     error.code = [resultDict yz_integerForKey:@"code"];
                     error.msg = [resultDict yz_stringForKey:@"msg"];
                     failure(task, error);
                 }
             }
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [MBProgressHUD hideHUD];
             NSLog(@"网络错误 ： %@",error);
             if (failure) {
                 NZError *nzError = [[NZError alloc] init];
                 nzError.msg = @"网络连接失败，稍后再试";// error.description;
                 nzError.code = error.code;
                 failure(task, nzError);
             } else {
                 NSLog(@"error:%@",error);
                 [MBProgressHUD showMessageAuto:@"网络连接失败，稍后再试"];
             }
         }];
}

- (void)put:(NSString *)method
 parameters:(NSDictionary *)parameters
   progress:(ProgressBlock)progress
    success:(SuccessBlock)success
    failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[self Authorization]
                     forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServiceBaseURL,method];
    
    NSLog(@"\n==============开始请求网络===============\n%@ \n%@ \n=======================================",urlString,dict);
    
    [manager PUT:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        } else if ([responseObject isKindOfClass:[NSData class]]) {
            resultDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        }
        
        if ([resultDict yz_integerForKey:@"success"] == 1) {
            //成功
            success(task, [resultDict yz_objectForKey:@"data"]);
        } else {
            //失败
            if (failure) {
                if ([resultDict yz_integerForKey:@"code"] == (-1000)) {
                    [[YZUserCenter shared] logOut];
                }
                NZError *error = [[NZError alloc] init];
                error.code = [resultDict yz_integerForKey:@"code"];
                error.msg = [resultDict yz_stringForKey:@"msg"];
                failure(task, error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [busyView stopAnimating];
        //        [busyView removeFromSuperview];
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 ： %@",error);
        if (failure) {
            NZError *nzError = [[NZError alloc] init];
            //            nzError.msg = error.description;
            nzError.msg = @"网络连接失败，稍后再试";
            nzError.code = error.code;
            failure(task, nzError);
        } else {
            NSLog(@"error:%@",error);
            [MBProgressHUD showMessageAuto:@"网络连接失败，稍后再试"];
        }
    }];
}

- (void)delete:(NSString *)method
    parameters:(NSDictionary *)parameters
      progress:(ProgressBlock)progress
       success:(SuccessBlock)success
       failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[self Authorization]
                     forHTTPHeaderField:@"Authorization"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", nil];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",ServiceBaseURL,method];
    
    NSLog(@"\n==============开始请求网络===============\n%@ \n%@ \n=======================================",urlString,dict);
    
    [manager DELETE:urlString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUD];
        NSDictionary *resultDict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            resultDict = responseObject;
        } else if ([responseObject isKindOfClass:[NSData class]]) {
            resultDict = [NSJSONSerialization JSONObjectWithData:responseObject
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
        }
        
        if ([resultDict yz_integerForKey:@"success"] == 1) {
            //成功
            success(task, [resultDict yz_objectForKey:@"data"]);
        } else {
            //失败
            if (failure) {
                if ([resultDict yz_integerForKey:@"code"] == (-1000)) {
                    [[YZUserCenter shared] logOut];
                }
                NZError *error = [[NZError alloc] init];
                error.code = [resultDict yz_integerForKey:@"code"];
                error.msg = [resultDict yz_stringForKey:@"msg"];
                failure(task, error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [busyView stopAnimating];
        //        [busyView removeFromSuperview];
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 ： %@",error);
        if (failure) {
            NZError *nzError = [[NZError alloc] init];
            //            nzError.msg = error.description;
            nzError.msg = @"网络连接失败，稍后再试";
            nzError.code = error.code;
            failure(task, nzError);
        } else {
            NSLog(@"error:%@",error);
            [MBProgressHUD showMessageAuto:@"网络连接失败，稍后再试"];
        }
    }];
}

- (void)handleSuccess:(id)responseObject {
    
}

- (void)handleError:(NSError *)error {
    
}

- (NSString *)Authorization {
    return ([YZUserCenter shared].userInfo ? [YZUserCenter shared].userInfo.token : @"18de2f5ddb694b8586c1bfca2b88b3f2");
}

@end
