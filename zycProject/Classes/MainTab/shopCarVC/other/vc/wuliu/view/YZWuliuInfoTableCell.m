//
//  YZWuliuInfoTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZWuliuInfoTableCell.h"

@interface YZWuliuInfoTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderTitleLb;
@property (weak, nonatomic) IBOutlet UILabel *devNumberLb;
@property (weak, nonatomic) IBOutlet UILabel *devCompanyLb;
@property (weak, nonatomic) IBOutlet UILabel *companyTitleLb;
@property (weak, nonatomic) IBOutlet UIButton *cpActionBt;

@end

@implementation YZWuliuInfoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSString *logisticsNumber = [model yz_stringForKey:@"logisticsNumber"];
        NSString *logisticsCompany = [model yz_stringForKey:@"logisticsCompany"];
        if (logisticsNumber.length > 0 && logisticsCompany.length > 0) {
            return 90;
        }
        if (logisticsNumber.length > 0) {
            return 18 + 20 + 20;
        }
        if (logisticsCompany.length > 0) {
            return 18 + 20 + 20;
        }
    }
    return  0.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[NSDictionary class]]) {
        self.devNumberLb.text = [model yz_stringForKey:@"logisticsNumber"];
        self.devCompanyLb.text = [model yz_stringForKey:@"logisticsCompany"];
        self.companyTitleLb.hidden = (self.devCompanyLb.text.length == 0);
        self.orderTitleLb.hidden = (self.devNumberLb.text.length == 0);
        self.cpActionBt.hidden = self.orderTitleLb.hidden;
    }
}

- (IBAction)copyAction:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.devNumberLb.text;
}

@end
