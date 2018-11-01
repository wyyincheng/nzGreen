////
////  SpotGoodsModel.m
////  IBZApp
////
////  Created by 尹成 on 16/6/20.
////  Copyright © 2016年 ibaozhuang. All rights reserved.
////
//
//#import "SpotGoodsModel.h"
//#import "MJExtension.h"
//
//@implementation SpotGoodsModel
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
//    NSArray *orders = [[keyValues yc_objectForKey:@"Data"] yc_objectForKey:@"Items"];
//    return [self mj_objectArrayWithKeyValuesArray:orders context:nil];
//}
//
//- (NSString *)LastModifiedTime{
//
//    NSString *time = [_LastModifiedTime substringWithRange:NSMakeRange(6, 10)];
//    NSLog(@"tiemStr:%@",time);
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
//    
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time longLongValue]];
//    NSLog(@"timeNumber:%lld",[time longLongValue]);
//    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//    return confromTimespStr;
//}
//
//- (NSString *)getLastModifiedTime{
//    return _LastModifiedTime;
//}
//
//- (NSString *)MinPrice{
//    return [NSString stringWithFormat:@"%0.0f",[_MinPrice floatValue]];
//}
//
//@end
