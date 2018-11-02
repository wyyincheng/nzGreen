//
//  YZOrderModel.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderModel.h"

#import <MJExtension/MJProperty.h>

@implementation YZOrderItemModel

- (NSString *)image {
    return [_image imageUrlString];
}

@end

@implementation YZOrderModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderItemList":@"YZOrderItemModel",@"addressItem":@"YZAddressModel"};
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

//- (NSDictionary *)orderItem {
//    return [self.orderItemList ymm_dictAtIndex:0];
//}

#warning for yc
- (YZAddressModel *)addressItem {
    _addressItem.isDefault = 0;
    return _addressItem;
}

//- (NSString *)image {
//    if (_image) {
//        return [NSString stringWithFormat:@"https://www.nzgreens.com%@",[[self orderItem] ymm_stringForKey:@"title"]];
//    }
//    return nil;
//}

//#warning for yc 设计不对，后续要修改
//- (BOOL)commentShow  {
//    NZOrderItemModel *item = [self.orderItemList ymm_objectAtIndex:0];
//    return item.commentShow;
//}
//
//- (NSInteger)commentStatus  {
//    NZOrderItemModel *item = [self.orderItemList ymm_objectAtIndex:0];
//    return item.commentStatus;
//}

@end
