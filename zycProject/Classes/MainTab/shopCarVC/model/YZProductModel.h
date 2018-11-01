//
//  YZProductModel.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "YZGoodsFreightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZProductModel : YZBaseModel

@property (nonatomic, copy) NSString *shoppingCartId;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger productNumber;
@property (nonatomic, strong) NSNumber *sellingPrice;
@property (nonatomic, strong) YZGoodsFreightModel *productFreight;

@property (nonatomic, assign) BOOL selected;

@end

NS_ASSUME_NONNULL_END
