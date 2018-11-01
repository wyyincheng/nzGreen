//
//  YZHomeGoodsCollectionCell.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZHomeGoodsCollectionCell.h"

#import "YZGoodsModel.h"

@interface YZHomeGoodsCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *goodsSaleCountLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodNameBottom;

@end

static CGFloat goodsNameFont = 14.0f;
static CGFloat goodsPriceFont = 18.0f;

@implementation YZHomeGoodsCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.goodsNameLb.font = [UIFont systemFontOfSize:goodsNameFont];
    self.goodsPriceLb.font = [UIFont systemFontOfSize:goodsPriceFont];
}

+ (CGSize)yz_sizeForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        CGFloat height = (width + 10 + [UIFont systemFontOfSize:goodsNameFont].lineHeight + 10 + [UIFont systemFontOfSize:goodsPriceFont].lineHeight + 10);
        return CGSizeMake(width, height);
    }
    return CGSizeMake(0, 0);
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goodsModel = model;
        CGFloat imageWidth = (kScreenWidth - 5) / 2 - 18 * 2;
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.image]
                               placeholderImage:[UIImage yz_imageWithNamed:@"kCargoDetailBannerPlaceholder"
                                                                  backSize:CGSizeMake(imageWidth, imageWidth)]];
        self.goodsNameLb.text = goodsModel.title;
        self.goodsSaleCountLb.text = [NSString stringWithFormat:@"%ld人付款",(long)goodsModel.salesVolume];
        self.goodsPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.sellingPrice floatValue]];
//        self.goodNameBottom.constant = 5;
    }
}

@end
