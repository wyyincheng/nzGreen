//
//  YZMainViewController.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZMainViewController.h"

#import "YZShopCarViewController.h"
#import "YZGoodsListViewController.h"
#import "YZUserCenterViewController.h"

@interface YZMainViewController ()

@end

@implementation YZMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = @[[YZGoodsListViewController new],
                             [YZShopCarViewController new],
                             [YZUserCenterViewController new]];
}


@end