//
//  MessageClass.h
//  IBZApp
//
//  Created by 尹成 on 16/10/27.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageClass : NSObject

@property (nonatomic, copy) NSString *ContentType;
@property (nonatomic, copy) NSString *Type;
@property (nonatomic, copy) NSString *Uid;
@property (nonatomic, copy) NSString *alert;

+ (MessageClass *)sharedMsg;

- (void)confimWithDict:(NSDictionary *)dict;

@end
