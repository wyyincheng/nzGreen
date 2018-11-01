////
////  OrderModel.m
////  IBZApp
////
////  Created by 尹成 on 16/6/15.
////  Copyright © 2016年 ibaozhuang. All rights reserved.
////
//
//#import "OrderModel.h"
//#import "MJExtension.h"
//
//@implementation OrderModel
//
//+ (NSMutableArray *)yc_objectWithKeyValues:(id)keyValues{
//        if ((0 != [[keyValues yc_objectForKey:@"ErrorCode"] intValue]) ||
//            [keyValues yc_objectForKey:@"Data"] == nil ||
//            ([keyValues yc_objectForKey:@"Data"] == [NSNull null])) {
//    
//            [MBProgressHUD showMessageAuto:[NSString stringWithFormat:@"%@",[keyValues yc_objectForKey:@"ErrorMsg"]]];
//            return nil;
//        }
//    
//    NSArray *orders = [[keyValues yc_objectForKey:@"Data"] yc_objectForKey:@"Items"];
//    return [self mj_objectArrayWithKeyValuesArray:orders context:nil];
//}
//
//- (NSString *)Price{
//    return [NSString stringWithFormat:@"%0.2f",[_Price floatValue]];
//}
//
//@end
