//
//  OrderService.h
//  IBZApp
//
//  Created by 尹成 on 16/6/18.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "YNCZBaseService.h"

@interface OrderAPI : YNCZBaseService

- (void)yc_addCommentWithOrderId:(NSString *)orderId
                      comment:(NSString *)comment
                        score:(NSNumber *)score
                      success:(SuccessBlock)success
                      Failure:(FailureBlock)failure;

- (void)getOrderDetailWithOrderId:(NSString *)orderId
                          success:(SuccessBlock)success
                          Failure:(FailureBlock)failure;

- (void)getAgentOrderDetailWithOrderId:(NSString *)orderId
                               success:(SuccessBlock)success
                               Failure:(FailureBlock)failure;

- (void)passOrdersByAgentWithOrders:(NSArray *)orderArray
                          success:(SuccessBlock)success
                          Failure:(FailureBlock)failure;

- (void)mergeOrdersByAgentWithOrders:(NSArray *)orderArray
                           addressId:(NSNumber *)addressId
                            success:(SuccessBlock)success
                            Failure:(FailureBlock)failure;

- (void)reSubmitOrderWithOrder:(NSArray *)productOrderList
                  deliveryMode:(NSInteger)deliveryMode
                     addressId:(NSString *)addressId
                       success:(SuccessBlock)success
                       Failure:(FailureBlock)failure;

- (void)getDeliveInfoWithOrderNumber:(NSString *)orderNumber
                             success:(SuccessBlock)success
                             Failure:(FailureBlock)failure;

- (void)rejectOrderWithOrderNumber:(NSString *)orderNumber
                             success:(SuccessBlock)success
                             Failure:(FailureBlock)failure;

- (void)adoptOrderWithOrderList:(NSArray *)orderNumberList
                           success:(SuccessBlock)success
                           Failure:(FailureBlock)failure;

- (void)getReSubmitOrderInfoWithOrderNumber:(NSString *)orderNumber
                        success:(SuccessBlock)success
                        Failure:(FailureBlock)failure;

@end
