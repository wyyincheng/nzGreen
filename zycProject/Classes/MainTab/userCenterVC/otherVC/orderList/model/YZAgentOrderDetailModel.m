//
//  YZAgentOrderDetailModel.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAgentOrderDetailModel.h"

@implementation YZAgentOrderItemModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"productFreight":@"YZGoodsFreightModel"};
}

- (NSString *)image {
    return [_image imageUrlString];
}

@end


@implementation YZAgentOrderDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderItemDetailList":@"YZAgentOrderItemModel",@"addressItem":@"YZAddressModel"};
}

@end
