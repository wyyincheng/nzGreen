//
//  YZAgentMangerTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAgentMangerTableCell.h"

@interface YZAgentMangerTableCell ()

@property (weak, nonatomic) IBOutlet UIButton *storeMangerBt;
@property (weak, nonatomic) IBOutlet UIButton *userMangerBt;
@property (weak, nonatomic) IBOutlet UIButton *orderMangerBt;

@end

@implementation YZAgentMangerTableCell

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    if ([YZUserCenter shared].hasReviewed &&
        UserType_Agent == [YZUserCenter shared].userInfo.userType) {
        return 90;
    }
    return 0.0f;
}

- (void)yz_configWithModel:(id)model {
    self.contentView.hidden = !([YZUserCenter shared].hasReviewed &&
                                UserType_Agent == [YZUserCenter shared].userInfo.userType);
}

- (IBAction)agentManagerAction:(UIButton *)sender {
    if (self.agentMangerBlock) {
        self.agentMangerBlock(sender.tag);
    }
}

@end
