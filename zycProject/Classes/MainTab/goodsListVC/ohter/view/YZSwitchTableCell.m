//
//  YZSwitchTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZSwitchTableCell.h"

@interface YZSwitchTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLine;
@property (weak, nonatomic) IBOutlet UILabel *comentLb;
@property (weak, nonatomic) IBOutlet UILabel *commentLine;

@end

@implementation YZSwitchTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 48;
}

- (void)yz_configWithModel:(id)model {
    self.contentView.clipsToBounds = YES;
}

- (IBAction)switchAction:(UIButton *)sender {
    switch (sender.tag) {
        case 1:
            self.detailLb.textColor = [UIColor colorWithHex:0x141414];
            self.comentLb.textColor = [UIColor colorWithHex:0x62aa60];
            self.detailLine.hidden = YES;
            self.commentLine.hidden = NO;
            break;
            
        default:
            self.detailLb.textColor = [UIColor colorWithHex:0x62aa60];
            self.comentLb.textColor = [UIColor colorWithHex:0x141414];
            self.detailLine.hidden = NO;
            self.commentLine.hidden = YES;
            break;
    }
    if (self.switchInfoBlock) {
        self.switchInfoBlock(sender.tag);
    }
}

- (void)setCommentCount:(NSInteger)commentCount {
    if (commentCount == 0) {
        self.comentLb.text = [NSString stringWithFormat:@"评论"];
    } else {
        self.comentLb.text = [NSString stringWithFormat:@"评论(%ld)",(long)commentCount];
    }
}

@end
