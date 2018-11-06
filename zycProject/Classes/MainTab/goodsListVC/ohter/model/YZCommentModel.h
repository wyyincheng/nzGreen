//
//  YZCommentModel.h
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZCommentModel : YZBaseModel

@property (nonatomic, copy) NSString *avatar;//": "/statics/user/2/01335b41a20d44dbafddb05e21bcba2f.jpeg",
@property (nonatomic, copy) NSString *comment;//": "少林功夫好啊，真是好啊",
@property (nonatomic, copy) NSString *createTime;//": 1526712690000,
@property (nonatomic, copy) NSString *nickname;//": "hahaha",
@property (nonatomic, copy) NSString *score;//": 4.5,
@property (nonatomic, copy) NSString *userId;//": 2

@end

NS_ASSUME_NONNULL_END
