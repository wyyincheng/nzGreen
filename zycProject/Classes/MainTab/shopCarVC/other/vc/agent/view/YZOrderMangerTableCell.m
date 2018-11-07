//
//  YZOrderMangerTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderMangerTableCell.h"

#import "YZOrderModel.h"
#import "YZOrderManagerModel.h"

@interface YZOrderMangerTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *orderIconView;
@property (weak, nonatomic) IBOutlet UILabel *orderTitileLb;
@property (weak, nonatomic) IBOutlet UILabel *orderWeightLb;
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLb;
@property (weak, nonatomic) IBOutlet UIButton *orderPingjiaBt;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusIconView;
@property (weak, nonatomic) IBOutlet UILabel *countLb;

@property (nonatomic, strong) id itemModel;

@end

@implementation YZOrderMangerTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
    self.orderPingjiaBt.layer.masksToBounds = YES;
    self.orderPingjiaBt.layer.cornerRadius = 16;
    self.orderPingjiaBt.layer.borderWidth = 1;
    self.orderPingjiaBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZOrderItemModel class]]) {
        YZOrderItemModel *item = model;
        return 105;
    } else if ([model isKindOfClass:[YZOrderManagerItemModel class]]) {
        YZOrderManagerItemModel *item = model;
#warning for yc ? item.canMerge
        //        return item.canMerge ? 166 : 105;
        return 105;
    }
    return 0;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZOrderItemModel class]]) {
        YZOrderItemModel *order = model;
        self.itemModel = order;
        [self.orderIconView sd_setImageWithURL:[NSURL URLWithString:order.image]
                              placeholderImage:[UIImage placeHolderImage]];
        self.orderTitileLb.text = order.title;
        self.orderWeightLb.text = [NSString stringWithFormat:@"商品重量：%ldg",(long)order.weight];
        self.countLb.text = [NSString stringWithFormat:@"x%ld",(long)order.productNumber];
        
        self.orderPingjiaBt.hidden = YES;
        self.orderStatusLb.hidden = NO;
        if (order.commentStatus == 1 && !order.commentShow) {
            self.orderStatusLb.text = @"已评价";
        }
    } else if ([model isKindOfClass:[YZOrderManagerItemModel class]]) {
        YZOrderManagerItemModel *order = model;
        self.itemModel = order;
        [self.orderIconView sd_setImageWithURL:[NSURL URLWithString:order.image]
                              placeholderImage:[UIImage placeHolderImage]];
        self.orderTitileLb.text = order.title;
        self.orderWeightLb.text = [NSString stringWithFormat:@"商品重量：%ldg",(long)order.weight];
        self.countLb.text = [NSString stringWithFormat:@"x%ld",(long)order.productNumber];
        self.orderStatusLb.text = nil;
        self.orderPingjiaBt.hidden = YES;
    }
}

@end
