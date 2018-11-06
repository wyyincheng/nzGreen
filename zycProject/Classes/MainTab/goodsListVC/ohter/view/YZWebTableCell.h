//
//  YZWebTableCell.h
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZWebTableCell : YZBaseTableViewCell <UIWebViewDelegate>

@property (nonatomic,strong) NSString *contentStr;
@property (nonatomic,assign) CGFloat height;
@property (strong, nonatomic) UIWebView *webView;

@end

NS_ASSUME_NONNULL_END
