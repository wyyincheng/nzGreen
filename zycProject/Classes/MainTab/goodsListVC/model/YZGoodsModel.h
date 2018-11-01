//
//  YZGoodsModel.h
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseModel.h"

#import "YZGoodsFreightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZGoodsModel : YZBaseModel

@property (nonatomic, strong) NSNumber *goodsId;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *goodsWeight;
@property (nonatomic, assign) NSInteger salesVolume;
@property (nonatomic, strong) NSNumber *sellingPrice;

// ----- for shopcar cell -----
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger count;

//------ for detail -------
@property (nonatomic, strong) NSNumber *costPrice;//原价
@property (nonatomic, strong) NSNumber *stock;//库存
@property (nonatomic, copy) NSString *freight;//运费
@property (nonatomic, copy) NSString *brand;//品牌
@property (nonatomic, copy) NSString *service;//售后说明
@property (nonatomic, assign) NSInteger weight;//重量,单位g
@property (nonatomic, copy) NSString *commentNumber;//评论数
@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, copy) NSString *detail;//详情 html

/**
 运费单位
 */
@property (nonatomic, strong) YZGoodsFreightModel *productFreight;

@end

NS_ASSUME_NONNULL_END
