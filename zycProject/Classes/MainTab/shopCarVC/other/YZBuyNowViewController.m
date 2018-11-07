//
//  YZBuyNowViewController.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBuyNowViewController.h"

#import "YZGoodsModel.h"

@interface YZBuyNowViewController ()

@property (nonatomic, strong) NSDictionary *goodsDict;
@property (nonatomic, strong) YZGoodsModel *goodsModel;

@end

@implementation YZBuyNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (YZGoodsModel *)goodsModel {
    if (!_goodsModel) {
        _goodsModel = [self.lauchParams yz_objectForKey:kYZLauchParams_GoodsModel];
    }
    return _goodsModel;
}

- (NSDictionary *)goodsDict {
    if (!_goodsDict) {
        _goodsDict = [self.lauchParams yz_objectForKey:kYZLauchParams_GoodsDict];
    }
    return _goodsDict;
}

@end
