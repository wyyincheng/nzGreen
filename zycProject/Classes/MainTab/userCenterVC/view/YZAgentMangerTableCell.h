//
//  YZAgentMangerTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AgentMangerType) {
    AgentMangerType_User = 0,
    AgentMangerType_Sotre = 1,
    AgentMangerType_Order = 2,
};

typedef void(^AgentMangerBlock)(AgentMangerType mangerType);

@interface YZAgentMangerTableCell : YZBaseTableViewCell

@property (nonatomic, copy) AgentMangerBlock agentMangerBlock;

@end

NS_ASSUME_NONNULL_END
