//
//  YZCommentModel.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZCommentModel.h"

#import <MJExtension/MJProperty.h>

@implementation YZCommentModel

- (NSString *)avatar {
    return [_avatar imageUrlString];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"createTime"]) {
        if (oldValue) {
            
            NSTimeInterval time = [oldValue doubleValue]/1000;// doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
            NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
            //实例化一个NSDateFormatter对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设定时间格式,这里可以设置成自己需要的格式
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            return [dateFormatter stringFromDate: detaildate];
        }
    }
    return oldValue;
}

@end
