//
//  NZStoreItemCell.m
//  nzGreens
//
//  Created by yc on 2018/5/27.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "NZStoreItemCell.h"
#import "YZAgentGoodsModel.h"

@interface NZStoreItemCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UILabel *oldPricelb;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLb;
@property (weak, nonatomic) IBOutlet UIButton *changeBt;
@property (nonatomic, strong) YZAgentGoodsModel *goods;

@end

@implementation NZStoreItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.changeBt.layer.masksToBounds = YES;
    self.changeBt.layer.cornerRadius = 16;
    self.changeBt.layer.borderWidth = 1;
    self.changeBt.layer.borderColor = [UIColor colorWithHex:0x62aa60].CGColor;
    
    [self.changeBt addTarget:self action:@selector(changePriceAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 120;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZAgentGoodsModel class]]) {
        self.goods = model;
        YZAgentGoodsModel *goods = model;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:goods.image]
                         placeholderImage:[UIImage placeHolderImage]];
        self.titleLb.text = goods.title;
        self.oldPricelb.text = [NSString stringWithFormat:@"系统价格：%.2f",[goods.sellingPrice floatValue]];
        self.salePriceLb.text = [NSString stringWithFormat:@"代理价格：%.2f",[goods.agentPrice floatValue]];
    }
}

- (IBAction)changePriceAction:(id)sender {
    if (self.changePriceBlock) {
        self.changePriceBlock(self.goods);
    }
}

@end
