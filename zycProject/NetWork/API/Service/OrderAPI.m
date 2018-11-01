//
//  OrderService.m
//  IBZApp
//
//  Created by 尹成 on 16/6/18.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "OrderAPI.h"
#import "YCNetworkManager.h"
#import "YZOrderManagerModel.h"
//#import "UserModel.h"

//static NSString *SubmitAppRelease       = @"Order/SubmitAppRelease";
//static NSString *QueryAppReleaseList    = @"Order/QueryAppReleaseList";
//static NSString *QueryAppReleaseDetail  = @"Order/QueryAppReleaseDetail";
//static NSString *GetHomeData            = @"Order/QueryIndexAppReleaseList";
//static NSString *GetSupplyDetail        = @"Order/GetSupplyDetail";
//static NSString *GetPuarchaseDetail     = @"Order/GetPuarchaseDetail";
//static NSString *SubmitAppOffer         = @"Order/SubmitAppOffer";
//static NSString *SubmitAppOrder         = @"Order/SubmitAppOrder";
//static NSString *EditAppReleaseStatus   = @"Order/EditAppReleaseStatus";
//static NSString *QueryAppOfferList      = @"Order/QueryAppOfferList";
//static NSString *QueryAppOrderList      = @"Order/QueryAppOrderList";
//static NSString *EditAppOrderStatus     = @"Order/EditAppOrderStatus";
//static NSString *CompanyDetail          = @"Account/CompanyDetail";
//static NSString *GetBaseData            = @"Basic/GetBaseData";

@implementation OrderAPI

- (void)yc_addCommentWithOrderId:(NSString *)orderId comment:(NSString *)comment score:(NSNumber *)score success:(SuccessBlock)success Failure:(FailureBlock)failure {

    NSString *url = [NSString stringWithFormat:@"/comment/%@",orderId];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:comment forKey:@"comment"];
    [dict setValue:score forKey:@"score"];
    
    [[YCNetworkManager shared] post:url
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getOrderDetailWithOrderId:(NSString *)orderId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
    NSString *url = [NSString stringWithFormat:@"/orders/%@",orderId];
    [[YCNetworkManager shared] get:url
                         parameters:nil
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getAgentOrderDetailWithOrderId:(NSString *)orderId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    
    NSString *url = [NSString stringWithFormat:@"/orders/manage/%@",orderId];
    [[YCNetworkManager shared] get:url
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)passOrdersByAgentWithOrders:(NSArray *)orderArray success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *marray = [NSMutableArray array];
    for (YZOrderManagerModel *item in orderArray) {
        [marray addObject:item.orderNumber];
    }
    
    [dict setValue:marray forKey:@"orderNumberList"];
    
    [[YCNetworkManager shared] put:@"/orders/manage/adopt"
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)mergeOrdersByAgentWithOrders:(NSArray *)orderArray addressId:(NSNumber *)addressId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:orderArray forKey:@"orderNumberList"];
    [dict setValue:addressId forKey:@"addressId"];
    [[YCNetworkManager shared] post:@"/orders/manage/merges"
                        parameters:dict
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)reSubmitOrderWithOrder:(NSArray *)productOrderList deliveryMode:(NSInteger)deliveryMode addressId:(NSString *)addressId success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:productOrderList forKey:@"productOrderList"];
    [dict setValue:@(deliveryMode) forKey:@"deliveryMode"];
    [dict setValue:addressId forKey:addressId];
    [[YCNetworkManager shared] post:@"/products/order"
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

//- (void)reSubmitOrderWithOrder:(NSString *)orderNumber success:(SuccessBlock)success Failure:(FailureBlock)failure {
//    [[YCNetworkManager shared] get:[NSString stringWithFormat:@"/orders/%@",orderNumber]
//                        parameters:nil
//                          progress:nil
//                           success:success
//                           failure:failure];
//}

- (void)getDeliveInfoWithOrderNumber:(NSString *)orderNumber success:(SuccessBlock)success Failure:(FailureBlock)failure {
    [[YCNetworkManager shared] get:[NSString stringWithFormat:@"/orders/certs/%@",orderNumber]
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)rejectOrderWithOrderNumber:(NSString *)orderNumber success:(SuccessBlock)success Failure:(FailureBlock)failure {
    [[YCNetworkManager shared] delete:[NSString stringWithFormat:@"/orders/manage/%@",orderNumber]
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

- (void)adoptOrderWithOrderList:(NSArray *)orderNumberList success:(SuccessBlock)success Failure:(FailureBlock)failure {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:orderNumberList forKey:@"orderNumberList"];
    [[YCNetworkManager shared] put:@"/orders/manage/adopt"
                         parameters:dict
                           progress:nil
                            success:success
                            failure:failure];
}

- (void)getReSubmitOrderInfoWithOrderNumber:(NSString *)orderNumber success:(SuccessBlock)success Failure:(FailureBlock)failure {
    [[YCNetworkManager shared] get:[NSString stringWithFormat:@"/orders/resend/%@",orderNumber]
                        parameters:nil
                          progress:nil
                           success:success
                           failure:failure];
}

//- (void)SubmitAppReleaseWithType:(NSString *)PublishType
//                         Address:(NSString *)Address
//                      SpacesDict:(NSMutableDictionary *)SpacesDict
//                           Price:(NSString *)Price
//                           Count:(NSString *)Count
//                            Unit:(NSString *)Unit
//                          Remark:(NSString *)Remark
//                         success:(SuccessBlock)success
//                         failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    //采购 = 0
//    [SpacesDict setValue:Unit forKey:@"Unit"];
//    [SpacesDict setValue:Address forKey:@"Address"];
//    [SpacesDict setValue:Price forKey:@"Price"];
//    [SpacesDict setValue:Remark forKey:@"Remark"];
//    [SpacesDict setValue:user.CompanyUid forKey:@"CompanyUid"];
//    [SpacesDict setValue:user.CompanyName forKey:@"CompanyName"];
//    [SpacesDict setValue:Count forKey:@"Quantity"];
//    [SpacesDict setValue:PublishType forKey:@"Type"];
//    [SpacesDict setValue:user.Uid forKey:@"UserUid"];
//    [SpacesDict setValue:user.UserName forKey:@"UserName"];
//    [SpacesDict setValue:PublishType forKey:@"Type"];
//    [SpacesDict setValue:PublishType forKey:@"Type"];
//    [SpacesDict setValue:PublishType forKey:@"Type"];
//    
//    [[NetWorking sharedNetWorking] post:SubmitAppRelease
//                             parameters:SpacesDict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)getMyPublishWithType:(NSString *)PublishType
//                   pageIndex:(NSInteger)pageIndex
//                     success:(SuccessBlock)success
//                     failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          user.CompanyUid,@"CompanyUid",
//                          user.Uid,@"UserUid",
//                          PublishType,@"Type",
//                          [NSString stringWithFormat:@"%ld",(long)pageIndex],@"PageIndex",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:QueryAppReleaseList
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//    
//}
//
//- (void)QueryAppReleaseDetailWithUid:(NSString *)Uid
//                             success:(SuccessBlock)success
//                             failure:(FailureBlock)failure{
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"Uid",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:QueryAppReleaseDetail
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//    
//}
//
//- (void)getHomeDataWithType:(Boolean)FilterType pageIndex:(NSInteger)pageIndex success:(SuccessBlock)success failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSString *typeString = @"";
//    
//    if (!FilterType) {
//        typeString = @"0";
//    } else {
//        typeString = @"1";
//    }
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          user.Uid,@"UserUid",
//                          [NSString stringWithFormat:@"%ld",(long)pageIndex],@"PageIndex",
//                          user.CompanyUid,@"CompanyUid",
//                          user.Role,@"Role",
//                          typeString,@"FilterType",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:GetHomeData
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)getSupplyDetailWithUid:(NSString *)Uid success:(SuccessBlock)success failure:(FailureBlock)failure{
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"Uid",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:GetSupplyDetail
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)getPuarchaseDetailWithUid:(NSString *)Uid success:(SuccessBlock)success failure:(FailureBlock)failure{
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"Uid",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:GetPuarchaseDetail
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)SubmitAppOfferWithUid:(NSString *)Uid
//                   CompanyUid:(NSString *)CompanyUid
//                  CompanyName:(NSString *)CompanyName
//                        Price:(NSString *)Price
//                       Remark:(NSString *)Remark
//                      success:(SuccessBlock)success
//                      failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"RUid",
//                          user.CompanyUid,@"CompanyUid",
//                          user.CompanyName,@"CompanyName",
//                          user.Uid,@"UserUid",
//                          Price,@"Price",
//                          Remark,@"Remark",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:SubmitAppOffer
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)SubmitAppOrderWithUid:(NSString *)Uid
//                 PurchaserUid:(NSString *)PurchaserUid
//                PurchaserName:(NSString *)PurchaserName
//                  SupplierUid:(NSString *)SupplierUid
//                 SupplierName:(NSString *)SupplierName
//           SupplierContactUid:(NSString *)SupplierContactUid
//          SupplierContactName:(NSString *)SupplierContactName
//                        Price:(NSString *)Price
//                     Quantity:(NSString *)Quantity
//                       Amount:(NSString *)Amount
//                         Type:(NSString *)Type
//                      success:(SuccessBlock)success
//                      failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"RUid",
//                          user.CompanyUid,@"PurchaserUid",
//                          user.CompanyName,@"PurchaserName",
//                          user.Uid,@"PurchaserContactUid",
//                          user.UserName,@"PurchaserContactName",
//                          SupplierUid,@"SupplierUid",
//                          SupplierName,@"SupplierName",
//                          SupplierContactUid,@"SupplierContactUid",
//                          SupplierContactName,@"SupplierContactName",
//                          user.Uid,@"UserUid",
//                          Price,@"Price",
//                          Quantity,@"Quantity",
//                          Amount,@"Amount",
//                          Type,@"Type",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:SubmitAppOrder
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//    
//}
//
//- (void)ComfirmOfferWithUid:(NSString *)Uid
//                       RUid:(NSString *)RUid
//               PurchaserUid:(NSString *)PurchaserUid
//              PurchaserName:(NSString *)PurchaserName
//                SupplierUid:(NSString *)SupplierUid
//               SupplierName:(NSString *)SupplierName
//         SupplierContactUid:(NSString *)SupplierContactUid
//                      Price:(NSString *)Price
//                   Quantity:(NSString *)Quantity
//                     Amount:(NSString *)Amount
//                       Type:(NSString *)Type
//                    success:(SuccessBlock)success
//                    failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"Uid",
//                          RUid,@"RUid",
//                          user.CompanyUid,@"PurchaserUid",
//                          user.CompanyName,@"PurchaserName",
//                          user.Uid,@"PurchaserContactUid",
//                          user.UserName,@"PurchaserContactName",
//                          SupplierUid,@"SupplierUid",
//                          SupplierName,@"SupplierName",
//                          SupplierContactUid,@"SupplierContactUid",
//                          user.Uid,@"UserUid",
//                          Price,@"Price",
//                          Quantity,@"Quantity",
//                          Amount,@"Amount",
//                          Type,@"Type",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:SubmitAppOrder
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//    
//}
//
//- (void)EditAppReleaseStatus:(NSString *)Status Uid:(NSString *)Uid success:(SuccessBlock)success failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"Uid",
//                          Status,@"Status",
//                          user.Uid,@"UserUid",
//                          user.UserName,@"UserName",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:EditAppReleaseStatus
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)QueryAppOfferListWithCompanyUid:(NSString *)CompanyUid
//                              pageIndex:(NSInteger)pageIndex
//                                success:(SuccessBlock)success
//                                failure:(FailureBlock)failure{
//    UserModel *user = [UserModel getUserInfo];
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          user.CompanyUid,@"CompanyUid",
//                          [NSString stringWithFormat:@"%ld",(long)pageIndex],@"PageIndex",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:QueryAppOfferList
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)QueryAppOrderListWithType:(Boolean)FilterType
//                           Status:(NSInteger)Status
//                        pageIndex:(NSInteger)pageIndex
//                          success:(SuccessBlock)success
//                          failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSString *typeString = @"";
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//    
//    if (!FilterType) {
//        typeString = @"0";
//        
//        switch (Status) {
//            case 0:
//                
//                break;
//                
//            case 1:
//                [dict setValue:@"0" forKey:@"Status"];
//                break;
//                
//            case 2:
//                [dict setValue:@"2" forKey:@"Status"];
//                break;
//                
//            case 3:
//                [dict setValue:@"3" forKey:@"Status"];
//                break;
//                
//            default:
//                break;
//        }
//        
//        [dict setValue:user.Uid forKey:@"UserUid"];
//        [dict setValue:user.CompanyUid forKey:@"PurchaserUid"];
//        
//    } else {
//        typeString = @"1";
//        
//        switch (Status) {
//            case 0:
//                
//                break;
//                
//            case 1:
//                [dict setValue:@"0" forKey:@"Status"];
//                break;
//                
//            case 2:
//                [dict setValue:@"1" forKey:@"Status"];
//                break;
//                
//            case 3:
//                [dict setValue:@"3" forKey:@"Status"];
//                break;
//                
//            default:
//                break;
//        }
//        
//        [dict setValue:user.Uid forKey:@"UserUid"];
//        [dict setValue:user.CompanyUid forKey:@"SupplierUid"];
//        
//    }
//    
//    [dict setValue:[NSString stringWithFormat:@"%ld",(long)pageIndex] forKey:@"PageIndex"];
//    
//    [[NetWorking sharedNetWorking] post:QueryAppOrderList
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)QueryAppOrderListWithUid:(NSString *)Uid
//                         success:(SuccessBlock)success
//                         failure:(FailureBlock)failure{
//    [[NetWorking sharedNetWorking] post:QueryAppOrderList
//                             parameters:@{@"RUid":Uid}
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)EditAppOrderStatusWithUid:(NSString *)Uid
//                           Status:(NSInteger)Status
//                          success:(SuccessBlock)success
//                          failure:(FailureBlock)failure{
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          Uid,@"Uid",
//                          [NSString stringWithFormat:@"%ld",(long)Status],@"Status",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:EditAppOrderStatus
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)CompanyDetailWithCompanyUid:(NSString *)CompanyUid success:(SuccessBlock)success failure:(FailureBlock)failure{
//    
//    UserModel *user = [UserModel getUserInfo];
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          CompanyUid,@"CompanyUid",
//                          user.Uid,@"Uid",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:CompanyDetail
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}
//
//- (void)getSpecesDataWithCategoryUid:(NSString *)CategoryUid
//                             success:(SuccessBlock)success
//                             failure:(FailureBlock)failure{
//    
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:
//                          CategoryUid,@"CategoryUid",
//                          nil];
//    
//    [[NetWorking sharedNetWorking] post:GetBaseData
//                             parameters:dict
//                               progress:nil
//                                success:success
//                                failure:failure];
//}

@end
