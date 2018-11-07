//
//  YZOrderDetailStatusTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderDetailStatusTableCell.h"

#import "YZOrderModel.h"
#import "YZAgentOrderDetailModel.h"

@interface YZOrderDetailStatusTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *statusLb;

@end

@implementation YZOrderDetailStatusTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 120.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZOrderModel class]]) {
        YZOrderModel *orderModel = model;
        switch (orderModel.userOrderStatus) {
            case -1:
                self.statusLb.text = @"已驳回";
                break;
            case 0:
                self.statusLb.text = @"待确认";
                break;
            case 1:
                self.statusLb.text = @"待发货";
                break;
            case 2:
                self.statusLb.text = @"已完成";
            case 3:
                self.statusLb.text = @"已处理";
                break;
            default:
                break;
        }
    } else if ([model isKindOfClass:[YZAgentOrderDetailModel class]]) {
        YZAgentOrderDetailModel *order = model;
        switch (order.userOrderStatus) {
            case -1:
                self.statusLb.text = @"已拒绝";
                break;
            case 0:
                self.statusLb.text = @"待确认";
                break;
            case 1:
                self.statusLb.text = @"已通过";
                break;
            default:
                break;
        }
    }
}

@end
