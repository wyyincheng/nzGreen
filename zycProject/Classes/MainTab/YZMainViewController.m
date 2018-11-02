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
    
    UINavigationController *goodsVC = [[UINavigationController alloc] initWithRootViewController:[YZGoodsListViewController new]];
    goodsVC.tabBarItem.title = @"首页";
    goodsVC.tabBarItem.image = [UIImage imageNamed:@"icon_tab_home_default"];
    goodsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *shopCarVC = [[UINavigationController alloc] initWithRootViewController:[YZShopCarViewController new]];
    shopCarVC.tabBarItem.title = @"购物车";
    shopCarVC.tabBarItem.image = [UIImage imageNamed:@"icon_tab_shopcar_default"];
    shopCarVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab_shopcar_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *userCenterVC = [[UINavigationController alloc] initWithRootViewController:[YZUserCenterViewController new]];
    userCenterVC.tabBarItem.title = @"我的";
    userCenterVC.tabBarItem.image = [UIImage imageNamed:@"icon_tab_user_default"];
    userCenterVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tab_user_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithHex:0x141414]];
    [[UITabBar appearance] setTintColor:kTextColorGreen];
    
    self.viewControllers = @[goodsVC,shopCarVC,userCenterVC];
}

- (void)gotoIndexVC:(YZVCIndex)vcIndex {
    for (UINavigationController *nv in self.viewControllers) {
        [nv popToRootViewControllerAnimated:NO];
    }
    self.selectedIndex = vcIndex;
}

@end
