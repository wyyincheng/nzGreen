//
//  NZTipView.m
//  nzGreens
//
//  Created by yc on 2018/5/6.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "NZTipView.h"

@implementation NZTipView

+ (void)showError:(NSString *)error onScreen:(UIView *)currentView {
    UIView *errorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationHeight)];
    errorView.backgroundColor = [UIColor colorWithHex:0xFE5561];
    
    UILabel *errorMsg = [[UILabel alloc] init];
    errorMsg.textColor = [UIColor whiteColor];
    errorMsg.textAlignment = NSTextAlignmentCenter;
    errorMsg.text = error;
    
    [errorView addSubview:errorMsg];
    [currentView addSubview:errorView];
    
    CGFloat leftGap = 15.0f;
    CGFloat topGap = 8.0f;
    [errorMsg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(errorView.mas_leading).offset(leftGap);
        make.trailing.mas_equalTo(errorView.mas_trailing).offset(-leftGap);
        make.top.mas_equalTo(errorView.mas_top).offset(kStatusBarHeight);
        make.bottom.mas_equalTo(errorView.mas_bottom).offset(-topGap);
    }];
    
    [self performSelector:@selector(dismissErrorView:)
               withObject:errorView
               afterDelay:1.5];
}

+ (void)dismissErrorView:(UIView *)errorView {
    [UIView animateWithDuration:0.3
                     animations:^{
                         errorView.frame = CGRectMake(0, -100, kScreenWidth, kNavigationHeight);
                     } completion:^(BOOL finished) {
                         [self removeErrorView:errorView];
                     }];
}

+ (void)removeErrorView:(UIView *)errorView {
    [errorView removeFromSuperview];
    errorView = nil;
}

@end
