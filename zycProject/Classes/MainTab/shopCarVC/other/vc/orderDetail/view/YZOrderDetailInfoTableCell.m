//
//  YZOrderDetailInfoTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderDetailInfoTableCell.h"

#import "YZOrderModel.h"
#import "YZAgentOrderDetailModel.h"

@interface YZOrderDetailInfoTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLb;
@property (weak, nonatomic) IBOutlet UILabel *deliveNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *deliveTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *createTimeTitleLb;

@end

@implementation YZOrderDetailInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    
    if ([model isKindOfClass:[YZOrderModel class]]) {
        YZOrderModel *orderModel = model;
        return (orderModel.logisticsNumber.length > 0) ? 120 : 90;
    } else if ([model isKindOfClass:[YZAgentOrderDetailModel class]]) {
        YZAgentOrderDetailModel *orderModel = model;
        return 60;
    }
    return 0.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZOrderModel class]]) {
        YZOrderModel *orderModel = model;
        self.createTimeTitleLb.hidden = NO;
        self.orderNumberLb.text = orderModel.orderNumber;
        self.createTimeLb.text = orderModel.createTime;
        self.deliveTitleLB.hidden = !(orderModel.logisticsNumber.length > 0);
        self.deliveNumberLb.hidden = !(orderModel.logisticsNumber.length > 0);
        self.deliveNumberLb.text = orderModel.logisticsNumber;
        //        self.deliveNumberLb.text = @"123456";
        //        self.deliveNumberLb.hidden = NO;
    } else if ([model isKindOfClass:[YZAgentOrderDetailModel class]]) {
        YZAgentOrderDetailModel *orderModel = model;
        self.orderNumberLb.text = orderModel.orderNumber;
        self.deliveNumberLb.hidden = YES;
        self.deliveTitleLB.hidden = YES;
        self.createTimeLb.hidden = YES;
        self.createTimeTitleLb.hidden = YES;
        //        self.createTimeLb.text = orderModel.createTime;
        //        self.deliveTitleLB.hidden = !orderModel.logisticsShow;
        //        self.deliveNumberLb.hidden = !orderModel.logisticsShow;
        //        self.deliveNumberLb.text = orderModel.logisticsNumber;
    }
}

@end
