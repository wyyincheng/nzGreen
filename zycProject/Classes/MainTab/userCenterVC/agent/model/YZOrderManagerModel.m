//
//  YZOrderManagerModel.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderManagerModel.h"

@implementation YZOrderManagerItemModel

- (NSString *)image {
    return [_image imageUrlString];
}

@end

@implementation YZOrderManagerModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"orderItemList":@"YZOrderManagerItemModel"};
}

@end
