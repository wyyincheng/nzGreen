//
//  YZOrderDetailCountTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderDetailCountTableCell.h"

#import "YZOrderModel.h"
#import "YZAgentOrderDetailModel.h"

@interface YZOrderDetailCountTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderStatusLb;

@end

@implementation YZOrderDetailCountTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 60;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZOrderModel class]]) {
        YZOrderModel *order = model;
        
        self.orderStatusLb.text =  [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f（含运费¥%@）",order.productTotalNumber,[order.price floatValue],order.freight];
    } else if ([model isKindOfClass:[YZAgentOrderDetailModel class]]) {
        YZAgentOrderDetailModel *order = model;
        
        self.orderStatusLb.text =  [NSString stringWithFormat:@"共%ld件商品 合计：¥%.2f（含运费¥%@）",(long)order.totalNumber,[order.price floatValue],order.freight];
    }
}

@end
