//
//  YZAddressTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAddressTableCell.h"

#import "YZAddressModel.h"

@interface YZAddressTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *phoneLb;
@property (weak, nonatomic) IBOutlet UILabel *defaultLb;
@property (weak, nonatomic) IBOutlet UILabel *addresslb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftGap;

@end

@implementation YZAddressTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZAddressModel class]]) {
        YZAddressModel *address = model;
        if (address.address.length > 0 && address.telephone.length > 0) {
            return 90.0f;
        }
    }
    return 0.0f;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZAddressModel class]]) {
        self.contentView.hidden = NO;
        YZAddressModel *addres = model;
        self.nameLb.text = [NSString stringWithFormat:@"收货人:%@",addres.contact];
        self.phoneLb.text = addres.telephone;
        self.defaultLb.text = (addres.isDefault == 1 ? @"【默认地址】" : @"");
        self.addresslb.text = [NSString stringWithFormat:@"收货地址:%@",[addres.address stringByReplacingOccurrencesOfString:@"$" withString:@" "]];
        self.leftGap.constant = (addres.isDefault == 1 ? 80.5 : 0);
        
    } else {
        self.contentView.hidden = YES;
    }
}

@end
