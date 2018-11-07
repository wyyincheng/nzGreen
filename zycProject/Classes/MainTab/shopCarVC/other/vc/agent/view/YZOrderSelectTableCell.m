//
//  YZOrderSelectTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderSelectTableCell.h"

@interface YZOrderSelectTableCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectBt;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (nonatomic, strong) YZOrderManagerModel *order;

@end

@implementation YZOrderSelectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.selectBt setImage:[UIImage yz_imageWithNamed:@"btn_radio_default" backSize:CGSizeMake(47, 47)] forState:UIControlStateNormal];
    [self.selectBt setImage:[UIImage yz_imageWithNamed:@"btn_radio_selected" backSize:CGSizeMake(47, 47)] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 47;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZOrderManagerModel class]]) {
        self.order = model;
        self.selectBt.selected = self.order.selected;
        self.nameLb.text = self.order.nickname;
    }
}

- (IBAction)selectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    self.order.selected = sender.selected;
    
    if (self.caculateBlock) {
        self.caculateBlock(self.order);
    }
}

@end
