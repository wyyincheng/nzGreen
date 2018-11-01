//
//  MessageClass.m
//  IBZApp
//
//  Created by 尹成 on 16/10/27.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import "MessageClass.h"

static MessageClass *msg;

@implementation MessageClass

//+ (MessageClass *)sharedMsg{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        msg = [[MessageClass alloc] init];
//    });
//    return msg;
//}
//
//- (void)confimWithDict:(NSDictionary *)dict{
//    [MessageClass sharedMsg];
//    msg.ContentType = [dict yc_objectForKey:@"ContentType"];
//    msg.Type = [dict yc_objectForKey:@"Type"];
//    msg.Uid = [dict yc_objectForKey:@"Uid"];
//    msg.alert = [[dict yc_objectForKey:@"aps"] yc_objectForKey:@"alert"];
//}

@end
