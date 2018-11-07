//
//  YZOrderListTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderListTableCell.h"

#import "YZOrderModel.h"
#import "YZOrderManagerModel.h"
#import "YZAgentOrderDetailModel.h"

@interface YZOrderListTableCell ()

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

@implementation YZOrderListTableCell

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
        return (item.commentShow || item.commentStatus == 1) ? 166 : 105;
    } else if ([model isKindOfClass:[YZOrderManagerItemModel class]]) {
        YZOrderManagerItemModel *item = model;
#warning for yc ? item.canMerge
        //        return item.canMerge ? 166 : 105;
        return 105;
    } else if ([model isKindOfClass:[YZAgentOrderItemModel class]]) {
        YZAgentOrderItemModel *item = model;
        return (item.mergeShow || item.mergeStatus == 1) ? 166 : 105;
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
        self.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[order.sellingPrice floatValue]];
        if (order.commentStatus == 1 || !order.commentShow) {
            self.orderPingjiaBt.hidden = YES;
        } else {
            self.orderPingjiaBt.hidden = NO;
        }
        [self.orderPingjiaBt setTitle:@"评价" forState:UIControlStateNormal];
        self.orderStatusLb.hidden = (order.commentStatus == 0);
        if (order.commentStatus == 1) {
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
        self.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[order.productTotalPrice floatValue]];
        self.orderStatusLb.text = nil;
        self.orderPingjiaBt.hidden = YES;
        self.orderStatusLb.hidden = YES;
    } else if ([model isKindOfClass:[YZAgentOrderItemModel class]]) {
        YZAgentOrderItemModel *order = model;
        self.itemModel = order;
        [self.orderIconView sd_setImageWithURL:[NSURL URLWithString:order.image]
                              placeholderImage:[UIImage placeHolderImage]];
        self.orderTitileLb.text = order.title;
        self.orderWeightLb.text = [NSString stringWithFormat:@"商品重量：%ldg",(long)order.weight];
        self.countLb.text = [NSString stringWithFormat:@"x%ld",(long)order.productNumber];
        self.orderPriceLb.text = [NSString stringWithFormat:@"¥%.2f",[order.productTotalPrice floatValue]];
        
        //        @property (nonatomic, assign) BOOL mergeShow;
        //        @property (nonatomic, assign) NSInteger mergeStatus;
        
        self.orderStatusLb.text = nil;
        self.orderPingjiaBt.hidden = YES;
        self.orderStatusLb.hidden = YES;
        
        if (order.mergeStatus == 1 || !order.mergeShow) {
            self.orderPingjiaBt.hidden = YES;
        } else {
            self.orderPingjiaBt.hidden = NO;
        }
        [self.orderPingjiaBt setTitle:@"合并" forState:UIControlStateNormal];
        self.orderStatusLb.hidden = (order.mergeStatus == 0);
        if (order.mergeStatus == 1) {
            self.orderStatusLb.text = @"已合并";
        }
    }
}

- (IBAction)pingjiaAction:(id)sender {
    if (self.pingjiaBlock) {
        self.pingjiaBlock(self.itemModel);
    }
}

@end
