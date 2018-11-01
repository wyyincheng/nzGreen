//
//  CompanyService.m
//  IBZApp
//
//  Created by 尹成 on 16/6/23.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "ProductAPI.h"
#import "YCNetworkManager.h"
#import "YZProductModel.h"

static NSString *GetProductList = @"/products";
static NSString *SearchProduct = @"/products/fuzzy";
static NSString *GetProductDetail = @"/products/";
static NSString *AddShoppingCar = @"/shoppingCart";
static NSString *GetShoppinCarList = @"/shoppingCart";
static NSString *PayShoppinCarList = @"/orders";
static NSString *PayGoodsDetail = @"/products/order";
static NSString *GetOrderList = @"/orders";

@implementation ProductAPI

- (void)searchProductWithKeyWorld:(NSString *)productFuzzyWord pageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:productFuzzyWord forKey:@"productFuzzyWord"];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:SearchProduct
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)searchStoreProductWithKeyWorld:(NSString *)productFuzzyWord pageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:productFuzzyWord forKey:@"productFuzzyWord"];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:@"/products/manage"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getProductListWithPageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:GetProductList
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getProductDetailWithGoodsId:(NSString *)goodsId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",GetProductDetail,goodsId];
    
    [[YCNetworkManager shared] get:url
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)addShoppingCarWithGoodsId:(NSString *)goodsId goodsNumber:(NSNumber *)goodsNumber success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:goodsId forKey:@"productId"];
    [dict setValue:goodsNumber forKey:@"productNumber"];
    
    [[YCNetworkManager shared] post:AddShoppingCar
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getShoppinCartListWithPageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:GetShoppinCarList
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)payGoodsFromShoppingCartWithGoods:(NSArray *)shoppingCartIdList deliveryMode:(NSInteger)deliveryMode address:(NSNumber *)addressId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(deliveryMode) forKey:@"deliveryMode"];
    [dict setValue:addressId forKey:@"addressId"];
    [dict setValue:shoppingCartIdList forKey:@"shoppingCartIdList"];
    
    [[YCNetworkManager shared] post:PayShoppinCarList
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)payOrderWithProductOrderList:(NSArray *)productOrderList deliveryMode:(NSInteger)deliveryMode address:(NSNumber *)addressId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:productOrderList forKey:@"productOrderList"];
    [dict setValue:@(deliveryMode) forKey:@"deliveryMode"];
    [dict setValue:addressId forKey:@"addressId"];
    
    [[YCNetworkManager shared] post:PayGoodsDetail
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)payShoppingCartWithList:(NSArray *)shoppingCartIdList deliveryMode:(NSInteger)deliveryMode address:(NSNumber *)addressId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:shoppingCartIdList forKey:@"shoppingCartIdList"];
    [dict setValue:@(deliveryMode) forKey:@"deliveryMode"];
    [dict setValue:addressId forKey:@"addressId"];
    
    [[YCNetworkManager shared] post:PayShoppinCarList
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)payWeixinWithProductId:(NSString *)productId price:(NSNumber *)price success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:productId forKey:@"productId"];
    [dict setValue:price forKey:@"price"];
    
    [[YCNetworkManager shared] post:@"/pay"
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getOrderListWithPageIndex:(NSInteger)pageIndex orderStatus:(NSInteger)status success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(status) forKey:@"orderStatus"];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:GetOrderList
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getOrderManagerListWithPageIndex:(NSInteger)pageIndex type:(NSInteger)type success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    [dict setValue:@(type) forKey:@"type"];
    
    [[YCNetworkManager shared] get:@"/orders/manage"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getOrderMergeListWithPageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:@"/orders/manage/merge"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)getAccountLogListWithPageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:@"/coins"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)delShoppingCarGoods:(NSArray *)goodsIdArray success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:goodsIdArray forKey:@"shoppingCartIdList"];
    
    [[YCNetworkManager shared] delete:@"/shoppingCart"
                           parameters:dict
                             progress:nil
                              success:success
                              failure:failure];
}

- (void)updateShoppingCarGoods:(NSArray *)goodsArray success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
#warning for yc 建议给个 array 的入参，批量更新
    for (YZProductModel *model in goodsArray) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:model.shoppingCartId forKey:@"shoppingCartId"];
        [dict setValue:@(model.productNumber) forKey:@"productNumber"];
        
        [[YCNetworkManager shared] put:@"/shoppingCart"
                            parameters:dict
                              progress:nil
                               success:success
                               failure:failure];
    }
}

- (void)getCommentListWithProductId:(NSString *)productId pageIndex:(NSInteger)pageIndex success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(pageIndex) forKey:@"current"];
    [dict setValue:@(20) forKey:@"size"];
    
    [[YCNetworkManager shared] get:[NSString stringWithFormat:@"/comment/%@",productId]
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)updateSearchKeyListWithLastQueryTime:(NSNumber *)lastQueryTime success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:lastQueryTime forKey:@"lastQueryTime"];
    
    [[YCNetworkManager shared] get:@"/configs"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

@end
