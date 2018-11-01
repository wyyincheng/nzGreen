//
//  Security.h
//  IBZApp
//
//  Created by 尹成 on 16/8/5.
//  Copyright © 2016年 ibaozhuang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Security : NSObject

+(NSString*)AesEncrypt:(NSString*)str;
+(NSString*)AesDecrypt:(NSString*)str;

@end
