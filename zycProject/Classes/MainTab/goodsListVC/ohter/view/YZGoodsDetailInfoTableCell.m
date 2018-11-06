//
//  YZGoodsDetailInfoTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsDetailInfoTableCell.h"

@interface YZGoodsDetailInfoTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nowPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *leftCountLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *freightLb;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLb;
@property (weak, nonatomic) IBOutlet UILabel *brandLb;

@end

@implementation YZGoodsDetailInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goodsModel = model;
        self.nowPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[goodsModel.sellingPrice floatValue]];
        self.oldPriceLb.text = [NSString stringWithFormat:@"%.2f",[goodsModel.costPrice floatValue]];
        self.leftCountLb.text = [YZUserCenter shared].hasReviewed ? [NSString stringWithFormat:@"库存量：%@件",goodsModel.stock] : nil;
        self.nameLb.text = goodsModel.title;
        self.freightLb.text = [YZUserCenter shared].hasReviewed ? [NSString stringWithFormat:@"快递：%@",goodsModel.freight] : nil;
        self.saleCountLb.text = [YZUserCenter shared].hasReviewed ? [NSString stringWithFormat:@"%ld人付款",(long)goodsModel.salesVolume] : nil;
        self.brandLb.text = [YZUserCenter shared].hasReviewed ? goodsModel.brand : nil;
    }
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        YZGoodsModel *goodsModel = model;
        CGFloat  height = [goodsModel.title boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 500)
                                                         options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                                         context:nil].size.height;
        CGFloat deliverInfoHeight = [YZUserCenter shared].hasReviewed ? 48 : 12;
        height = 58 + height + deliverInfoHeight;
        return height;
    }
    return 0.0f;
}

@end
