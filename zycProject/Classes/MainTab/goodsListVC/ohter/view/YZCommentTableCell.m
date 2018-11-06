//
//  YZCommentTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZCommentTableCell.h"

#import "YZCommentModel.h"

@interface YZCommentTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *commentLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *userNameLb;

@end

@implementation YZCommentTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([model isKindOfClass:[YZCommentModel class]]) {
        YZCommentModel *comment = model;
        return 14+32+14+14+[comment.comment boundingRectWithSize:CGSizeMake(kScreenWidth - 20, 500)
                                                         options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                                                         context:nil].size.height;
    }
    return 250;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZCommentModel class]]) {
        YZCommentModel *comment = model;
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:comment.avatar]
                         placeholderImage:[UIImage imageNamed:@"icon_me_avart"]];
        self.userNameLb.text = comment.nickname;
        self.timeLb.text = comment.createTime;
        self.commentLb.text = comment.comment;
    }
}

@end
