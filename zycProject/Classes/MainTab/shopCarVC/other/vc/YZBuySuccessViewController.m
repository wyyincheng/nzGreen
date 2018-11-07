//
//  YZBuySuccessViewController.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZBuySuccessViewController.h"

#import "YZUserOrderDTOModel.h"
#import "YZOrderDetailViewController.h"

@interface YZBuySuccessViewController ()

@property (nonatomic, strong) YZUserOrderDTOModel *userOrder;

@end

@implementation YZBuySuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)yc_goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)gotoOrderDetail:(id)sender {
    if (self.userOrder) {
        YZOrderDetailViewController *vc = [[YZOrderDetailViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.orderNumber = self.userOrder.orderNumber;
        vc.backType = BackType_From;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (YZUserOrderDTOModel *)userOrder {
    if (!_userOrder) {
        _userOrder = [self.lauchParams yz_objectForKey:kYZLauchParams_UserOrder];
    }
    return _userOrder;
}

@end
