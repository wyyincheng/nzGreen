//
//  YZBaseViewController.m
//  zycProject
//
//  Created by yc on 2018/10/30.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZBaseViewController ()

@end

@implementation YZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kYZBackViewColor;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (self.navigationController.viewControllers.count > 1) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_nav_back_white"]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(yz_goBack)];
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
}

- (void)yz_goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end