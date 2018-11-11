//
//  YZPrivacyViewController.m
//  zycProject
//
//  Created by yc on 2018/11/11.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZPrivacyViewController.h"

@interface YZPrivacyViewController ()

@end

@implementation YZPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"隐私政策";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

@end
