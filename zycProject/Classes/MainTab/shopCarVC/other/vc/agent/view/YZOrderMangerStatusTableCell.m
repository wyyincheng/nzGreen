//
//  YZOrderMangerStatusTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderMangerStatusTableCell.h"

#import "YZOrderModel.h"
#import "YZOrderManagerModel.h"

@interface YZOrderMangerStatusTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *orderStatusIconView;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLb;
@property (weak, nonatomic) IBOutlet UIButton *orderPingjiaBt;
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *contactLb;
@property (nonatomic, strong) id orderModel;
@property (weak, nonatomic) IBOutlet UIButton *selectBt;

@end

@implementation YZOrderMangerStatusTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.orderPingjiaBt.layer.masksToBounds = YES;
    self.orderPingjiaBt.layer.cornerRadius = 16;
    self.orderPingjiaBt.layer.borderWidth = 1;
    self.orderPingjiaBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    
    [self.selectBt setImage:[UIImage yz_imageWithNamed:@"btn_radio_default" backSize:CGSizeMake(38, 38)]
                   forState:UIControlStateNormal];
    [self.selectBt setImage:[UIImage yz_imageWithNamed:@"btn_radio_selected" backSize:CGSizeMake(38, 38)]
                   forState:UIControlStateSelected];
    self.selectBt.adjustsImageWhenHighlighted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 125;
}

- (void)yz_configWithModel:(id)model {
    self.orderModel = model;
    if ([model isKindOfClass:[YZOrderModel class]]) {
        YZOrderModel *order = model;
        
        self.priceLb.text =  [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f（含运费¥%@）",order.productTotalNumber,[order.price floatValue],order.freight];
        BOOL showBt = order.userOrderStatus == -1;
        self.orderPingjiaBt.hidden = YES;
        [self.orderPingjiaBt setTitle:@"   重新发起交易   " forState:UIControlStateNormal];
        self.orderStatusLb.hidden = !showBt;
        switch (order.userOrderStatus) {
            case -1:
                self.orderStatusIconView.hidden = NO;
                self.orderStatusIconView.image = [UIImage imageNamed:@"icon_order_cancel"];
                self.orderStatusLb.text = @"已驳回";
                break;
            case 0:
                self.orderStatusIconView.hidden = YES;
                if ([YZUserCenter shared].userInfo.userType == 1) {
                    self.orderStatusLb.text = @"等待代理确认…";
                } else {
                    self.orderStatusLb.text = @"待确认";
                }
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
            case 3:
                self.orderStatusIconView.hidden = YES;
                self.orderStatusLb.text = @"已处理";
                break;
            default:
                break;
        }
    } else if ([model isKindOfClass:[YZOrderManagerModel class]])  {
        YZOrderManagerModel *order = model;
        self.selectBt.selected = order.selected;
        self.priceLb.text =  [NSString stringWithFormat:@"共%@件商品 合计：¥%.2f（含运费¥%@）",order.totalNumber,[order.price floatValue],order.freight];
        self.contactLb.text = order.nickname.length > 0 ? [NSString stringWithFormat:@"买家：%@",order.nickname] : nil;
#warning for yc 是否通过可选中状态 ？
        BOOL showBt = (order.canAdopt == 1);
        self.orderPingjiaBt.hidden = YES;
        //        [self.orderPingjiaBt setTitle:@"   通过   " forState:UIControlStateNormal];
        self.orderStatusLb.hidden = NO;
        switch (order.userOrderStatus) {
            case -1:
                //                self.orderStatusIconView.hidden = NO;
                //                self.orderStatusIconView.image = [UIImage imageNamed:@"icon_order_cancel"];
                self.orderStatusLb.text = @"已驳回";
                break;
            case 0:
                //                self.orderStatusIconView.hidden = YES;
                if ([YZUserCenter shared].userInfo.userType == 1) {
                    self.orderStatusLb.text = @"等待代理确认…";
                } else {
                    self.orderStatusLb.text = @"待确认";
                }
                break;
            case 1:
                //                self.orderStatusIconView.hidden = NO;
                //                self.orderStatusIconView.image = [UIImage imageNamed:@"icon_order_pass"];
                self.orderStatusLb.text = @"已处理";
                break;
            default:
                self.orderStatusIconView.hidden = YES;
                self.orderStatusLb.text = nil;
                break;
        }
    }
}
- (IBAction)selectAcrion:(UIButton *)sender {
    sender.selected = !sender.selected;
    ((YZOrderManagerModel *)self.orderModel).selected = sender.selected;
}

@end
