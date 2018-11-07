//
//  YZBalanceTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBalanceTableCell.h"

#import "YZBalanceLogModel.h"

@interface YZBalanceTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userIconVeiw;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;
@property (weak, nonatomic) IBOutlet UILabel *changDeslb;
@property (weak, nonatomic) IBOutlet UILabel *priceChangeLb;

@end

@implementation YZBalanceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZBalanceLogModel class]]) {
        return 68.0f;
    }
    return 0.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZBalanceLogModel class]]) {
        YZBalanceLogModel *logModel = model;
        [self.userIconVeiw sd_setImageWithURL:[NSURL URLWithString:logModel.avatar]
                             placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
        self.userNameLb.text = logModel.nickname;
        self.changDeslb.text = [NSString stringWithFormat:@"%@", logModel.createTime];
        self.priceChangeLb.text = [NSString stringWithFormat:@"%@",logModel.amount];
        if ([logModel.amount hasPrefix:@"-"]) {
            self.priceChangeLb.textColor = [UIColor colorWithHex:0xC34C4C];
        } else {
            self.priceChangeLb.textColor = [UIColor colorWithHex:0x62aa60];
        }
        
        NSString *timeStr = nil;
        NSTimeInterval time = [logModel.createTime doubleValue]/1000;// doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        timeStr = [dateFormatter stringFromDate: detaildate];
        
        //        _CHARGE(1,"充值"), _ORDER_REBATE(2,"订单返佣"), _ORDER(3,"下单"), _REFUND(4,"退款"), _MONTH_REBATE(5,"月返佣"), _WITHDRAW(6,"提现"), _ORDER_REFUSED(7,"订单驳回")
        
        NSString *typeStr = nil;
        switch (logModel.type) {
            case 1:
                typeStr = @"充值";
                break;
            case 2:
                typeStr = @"订单返佣";
                break;
            case 3:
                typeStr = @"下单";
                break;
            case 4:
                typeStr = @"退款";
                break;
            case 5:
                typeStr = @"月返佣";
                break;
            case 6:
                typeStr = @"提现";
                break;
            case 7:
                typeStr = @"订单驳回";
                break;
            default:
                break;
        }
        timeStr = [NSString stringWithFormat:@"%@  %@",timeStr,typeStr];
        self.changDeslb.text = timeStr;
    }
}

@end
