//
//  CompanyService.h
//  IBZApp
//
//  Created by 尹成 on 16/6/23.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "YNCZBaseService.h"
#import "YZGoodsModel.h"

@interface ProductAPI : YNCZBaseService

- (void)searchProductWithKeyWorld:(NSString *)productFuzzyWord
                        pageIndex:(NSInteger)pageIndex
                          success:(SuccessBlock)success
                          Failure:(FailureBlock)failure;

- (void)searchStoreProductWithKeyWorld:(NSString *)productFuzzyWord
                             pageIndex:(NSInteger)pageIndex
                               success:(SuccessBlock)success
                               Failure:(FailureBlock)failure;

- (void)getProductListWithPageIndex:(NSInteger)pageIndex
                            success:(SuccessBlock)success
                            Failure:(FailureBlock)failure;

- (void)getProductDetailWithGoodsId:(NSString *)goodsId
                            success:(SuccessBlock)success
                            Failure:(FailureBlock)failure;

- (void)addShoppingCarWithGoodsId:(NSString *)goodsId
                      goodsNumber:(NSNumber *)goodsNumber
                          success:(SuccessBlock)success
                          Failure:(FailureBlock)failure;

- (void)getShoppinCartListWithPageIndex:(NSInteger)pageIndex
                                success:(SuccessBlock)success
                                Failure:(FailureBlock)failure;

- (void)payOrderWithProductOrderList:(NSArray *)productOrderList
                        deliveryMode:(NSInteger)deliveryMode
                             address:(NSNumber *)addressId
                             success:(SuccessBlock)success
                             Failure:(FailureBlock)failure;

- (void)payShoppingCartWithList:(NSArray *)shoppingCartIdList
                   deliveryMode:(NSInteger)deliveryMode
                        address:(NSNumber *)addressId
                        success:(SuccessBlock)success
                        Failure:(FailureBlock)failure;

- (void)payWeixinWithProductId:(NSString *)productId
                         price:(NSNumber *)price
                       success:(SuccessBlock)success
                       Failure:(FailureBlock)failure;

- (void)getCommentListWithProductId:(NSString *)productId
                          pageIndex:(NSInteger)pageIndex
                            success:(SuccessBlock)success
                            Failure:(FailureBlock)failure;

- (void)updateSearchKeyListWithLastQueryTime:(NSNumber *)lastQueryTime
                                     success:(SuccessBlock)success
                                     Failure:(FailureBlock)failure;

- (void)getOrderListWithPageIndex:(NSInteger)pageIndex
                      orderStatus:(NSInteger)status
                          success:(SuccessBlock)success
                          Failure:(FailureBlock)failure;

- (void)getOrderManagerListWithPageIndex:(NSInteger)pageIndex
                                    type:(NSInteger)type
                                 success:(SuccessBlock)success
                                 Failure:(FailureBlock)failure;

- (void)getOrderMergeListWithPageIndex:(NSInteger)pageIndex
                               success:(SuccessBlock)success
                               Failure:(FailureBlock)failure;

- (void)getAccountLogListWithPageIndex:(NSInteger)pageIndex
                               success:(SuccessBlock)success
                               Failure:(FailureBlock)failure;

- (void)delShoppingCarGoods:(NSArray *)goodsIdArray
                    success:(SuccessBlock)success
                    Failure:(FailureBlock)failure;

- (void)updateShoppingCarGoods:(NSArray *)goodsArray
                       success:(SuccessBlock)success
                       Failure:(FailureBlock)failure;

@end
