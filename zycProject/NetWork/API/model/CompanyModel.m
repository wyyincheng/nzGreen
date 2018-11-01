////
////  CompanyModel.m
////  IBZApp
////
////  Created by 尹成 on 16/6/23.
////  Copyright © 2016年 ibaozhuang. All rights reserved.
////
//
//#import "CompanyModel.h"
//#import "MJExtension.h"
//
//@implementation CompanyModel
//
//+ (NSMutableArray *)yc_objectWithKeyValues:(id)keyValues{
//    if ((0 != [[keyValues yc_objectForKey:@"ErrorCode"] intValue]) ||
//        [keyValues yc_objectForKey:@"Data"] == nil ||
//        ([keyValues yc_objectForKey:@"Data"] == [NSNull null])) {
//        
//        [MBProgressHUD showMessageAuto:[NSString stringWithFormat:@"%@",[keyValues yc_objectForKey:@"ErrorMsg"]]];
//        return nil;
//    }
//    
//    NSArray *items = [keyValues yc_objectForKey:@"Data"];
//    return [self mj_objectArrayWithKeyValuesArray:items context:nil];
//}
//
//@end
