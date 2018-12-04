//
//  YZOrderStatusTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderStatusTableCell.h"

#import "YZOrderModel.h"
#import "YZOrderManagerModel.h"

@interface YZOrderStatusTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *orderStatusIconView;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLb;
@property (weak, nonatomic) IBOutlet UIButton *orderPingjiaBt;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *contactLb;
@property (nonatomic, strong) id orderModel;
@property (weak, nonatomic) IBOutlet UIButton *rejectBt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rejectBtRightGap;

@end

@implementation YZOrderStatusTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.orderPingjiaBt.layer.masksToBounds = YES;
    self.orderPingjiaBt.layer.cornerRadius = 16;
    self.orderPingjiaBt.layer.borderWidth = 1;
    self.orderPingjiaBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    
    [self.rejectBt setTitle:@"   拒绝   " forState:UIControlStateNormal];
    self.rejectBt.layer.masksToBounds = YES;
    self.rejectBt.layer.cornerRadius = 16;
    self.rejectBt.layer.borderWidth = 1;
    self.rejectBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    [self.rejectBt addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    self.rejectBt.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
//    if ([model isKindOfClass:[YZOrderModel class]]) {
        return 125;
//    }
    return 0;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZOrderModel class]]) {
        
        self.orderModel = model;
        
        YZOrderModel *order = model;
        
        self.priceLb.text =  [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f（含运费¥%@）",order.productTotalNumber,[order.price floatValue],order.freight];
        
        BOOL showBt = (order.canResend) || ([YZUserCenter shared].userInfo.userType == UserType_Agent && order.userOrderStatus == 2);
        self.orderPingjiaBt.hidden = !showBt;
        if (order.canResend) {
            [self.orderPingjiaBt setTitle:@"   重新发起交易   " forState:UIControlStateNormal];
        }
        //        if (order.userOrderStatus == -1) {
        //            [self.orderPingjiaBt setTitle:@"   重新发起交易   " forState:UIControlStateNormal];
        //        } else
        if ([YZUserCenter shared].userInfo.userType == UserType_Agent && order.userOrderStatus == 2) {
            [self.orderPingjiaBt setTitle:@"   查看物流   " forState:UIControlStateNormal];
        }
        
        self.orderStatusLb.hidden = showBt;
        switch (order.userOrderStatus) {
            case -1:
                self.orderStatusIconView.hidden = NO;
                self.orderStatusIconView.image = [UIImage imageNamed:@"icon_order_cancel"];
                self.orderStatusLb.text = @"已驳回";
                break;
            case 0:
                self.orderStatusIconView.hidden = YES;
                self.orderStatusLb.text = @"待确认";
                break;
            case 1:
                self.orderStatusIconView.hidden = NO;
                self.orderStatusIconView.image = [UIImage imageNamed:@"icon_order_pass"];
                self.orderStatusLb.text = @"待发货";
                break;
            case 2:
                self.orderStatusIconView.hidden = NO;
                self.orderStatusIconView.image = [UIImage imageNamed:@"icon_order_finish"];
                self.orderStatusLb.text = @"已完成";
                break;
            case 3:
                self.orderStatusIconView.hidden = YES;
                self.orderStatusLb.text = @"已处理";
                break;
            default:
                break;
        }
    } else if ([model isKindOfClass:[YZOrderManagerModel class]])  {
        YZOrderManagerModel *order = model;
        self.orderModel = model;
        
        self.priceLb.text =  [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f（含运费¥%@）",order.totalNumber,[order.price floatValue],order.freight];
        self.contactLb.text = order.nickname.length > 0 ? [NSString stringWithFormat:@"买家：%@",order.nickname] : nil;
        
        BOOL showBt = (order.userOrderStatus == 0);
        self.orderPingjiaBt.hidden = !showBt;
        //        self.rejectBtRightGap.constant = (showBt && (order.canAdopt == 1) ? 77 : 15);
        if (showBt && (order.refuseShow)) {
            self.rejectBt.hidden = NO;
        } else {
            self.rejectBt.hidden = YES;
        }
        self.orderPingjiaBt.hidden = !showBt;
        if (order.canAdopt == 1) {
            [self.orderPingjiaBt setTitle:@"   通过   " forState:UIControlStateNormal];
        }
        else {
            [self.orderPingjiaBt setTitle:@"   合并   " forState:UIControlStateNormal];
        }
        
        self.orderStatusLb.hidden = showBt;
        switch (order.userOrderStatus) {
            case -1:
                self.orderStatusLb.text = @"已拒绝";
                break;
            case 1:
                self.orderStatusLb.text = @"已通过";
                break;
            default:
                self.orderStatusIconView.hidden = YES;
                self.orderStatusLb.text = nil;
                break;
        }
    }
}

- (IBAction)pingjiaAction:(id)sender {
    if (self.reSubmitBlock) {
        self.reSubmitBlock(self.orderModel);
    }
}

- (void)rejectAction {
    if (self.rejectBlock) {
        self.rejectBlock(self.orderModel);
    }
}

@end
