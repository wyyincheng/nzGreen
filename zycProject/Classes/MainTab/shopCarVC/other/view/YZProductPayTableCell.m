//
//  YZProductPayTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZProductPayTableCell.h"

@interface YZProductPayTableCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation YZProductPayTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return [YZUserCenter shared].hasReviewed ? 80 : 0;
}

- (void)yz_configWithModel:(id)model {
    self.contentView.hidden = ![YZUserCenter shared].hasReviewed;
}

- (IBAction)changeSatus:(UIButton *)sender {
    sender.selected = !sender.selected;
}

@end
