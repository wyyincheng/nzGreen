//
//  YZOrderListViewController.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZOrderListViewController.h"

#import "YZOrderListChildViewController.h"
#import "YZMainViewController.h"
#import "YMMTopTabbarView.h"

@interface YZOrderListViewController () <YMMTopTabbarDelegate, YMMTopTabbarDatasource>

@property (nonatomic, strong) YMMTopTabbarView *topBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation YZOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNoCommentView:nil];
}

- (void)initViews {
    self.title = @"我的运输单";
    [self.view addSubview:self.topBar];
    [self addSubVoewConstraints];
}

- (void)yc_goBack {
    [(YZMainViewController *)self.tabBarController gotoIndexVC:YZVCIndex_UserCenter];
}

- (void)addSubVoewConstraints {
    [self.topBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)loadNoCommentView:(NSDictionary *)info {
    __weak typeof(self) weakSelf = self;
    NSInteger noCommentOrderCount = 0; // [info[@"notCommentCount"] integerValue];
    
    //    if (noCommentOrderCount > 0) {
    //        [_noCommentArrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.height.mas_equalTo(12);
    //        }];
    //        [_noCommentedView mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.height.mas_equalTo(40);
    //        }];
    //        // mod by yincheng 20170509 start [UI优化]
    //        [_topBar mas_updateConstraints:^(MASConstraintMaker *make) {
    //            // mod by yincheng 20170509 end [UI优化]
    //            make.top.equalTo(@40);
    //        }];
    //        //mod by zgt for 代码优化 20171101 5.8.7 start
    //        NSString *noCommentStr = [NSString stringWithFormat:@"评价有奖！您有%zd个运单待评价，立即查看", noCommentOrderCount];
    //        //mod by zgt for 代码优化 20171101 5.8.7 end
    //        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
    //                                     noCommentStr, @"allText",
    //                                     @(noCommentOrderCount).stringValue, @"setText",
    //                                     @(14), @"setFontSize",
    //                                     [UIColor greenColor], @"setColor",
    //                                     nil];
    //        [self setLabelAttributedText:dict];
    //
    //        _noCommentArrowImageView.image = [UIImage imageNamed:@"icon_driver_btn_arrow_right"];
    //    } else {
    //        [_noCommentArrowImageView mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.height.mas_equalTo(0);
    //        }];
    //        [_noCommentedView mas_updateConstraints:^(MASConstraintMaker *make) {
    //            make.height.mas_equalTo(0);
    //        }];
    // mod by yincheng 20170509 start [UI优化]
    [_topBar mas_updateConstraints:^(MASConstraintMaker *make) {
        // mod by yincheng 20170509 end [UI优化]
#warning  iphone x
        make.top.mas_equalTo(weakSelf.view.mas_top);
    }];
    //    }
}

- (void)setLabelAttributedText:(NSMutableDictionary *)dict {
    
    //    if (dict) {
    //        NSString *allText = [dict objectForKey:@"allText"];
    //        NSString *setText = [dict objectForKey:@"setText"];
    //        float setFontSize = [[dict objectForKey:@"setFontSize"] floatValue];
    //        UIColor *setColor = [dict objectForKey:@"setColor"];
    //
    //        NSRange textRange = [allText rangeOfString:setText];
    //        if (textRange.location != NSNotFound) {
    //            NSMutableAttributedString *attributedString =
    //            [[NSMutableAttributedString alloc]
    //             initWithString:allText];
    //            [attributedString addAttribute:NSForegroundColorAttributeName
    //                                     value:setColor
    //                                     range:textRange];
    //            [attributedString addAttribute:NSFontAttributeName
    //                                     value:[UIFont systemFontOfSize:setFontSize]
    //                                     range:textRange];
    //            [_noCommentLabel setAttributedText:attributedString];
    //        }
    //    }
}

#pragma mark - YMMTopTabbarDatasource
- (NSInteger)numberOfColumsInTopTabbarView:(YMMTopTabbarView *)topTabbarView{
    return self.topBar.topBarTitles.count;
}

- (UIViewController *)topTabbarView:(YMMTopTabbarView *)topTabbarView contentViewControllerForColumnAtIndex:(NSInteger)index{
    BOOL normalUser = ([YZUserCenter shared].userInfo.userType == UserType_Normal);
    NSInteger orderType;
    switch (index) {
        case 0:
        {
            orderType = -1;
        }
            break;
        case 1:
        {
            orderType = 0;
        }
            break;
        case 2:
        {
            orderType = normalUser ? 3 : 1;
        }
        case 3:
        {
            orderType = 3;
        }
            break;
            
        default:
        {
            orderType = -1;
        }
            break;
    }
    YZOrderListChildViewController *vc = [[YZOrderListChildViewController alloc] init];
    vc.status = orderType;
    //    vc.delegate = self;
    [self.viewControllers addObject:vc];
    return vc;
}

#pragma mark - YMMTopTabbarDelegate
- (void)topTabbarView:(YMMTopTabbarView *)topTabbarView didSelectColumnAtIndex:(NSInteger)index fromIndex:(NSInteger)oldIndex{
    //更新上面的数字
    //    [self reqeustOrderCount];
    YZOrderListChildViewController *listVC = [self.viewControllers objectAtIndex:index];
    [listVC refreshGoods:YES];
}


//#pragma mark - YMMOrderListViewDelegate
//- (void)orderListHasReloadDataInViewController:(GTTransportOrderListViewController *)viewController{
//    [self reqeustOrderCount];
//}


#pragma mark - getter
- (YMMTopTabbarView *)topBar{
    return _topBar ?: ({
        _topBar = [[YMMTopTabbarView alloc] initWithtopBarStyle:YMMTopBarStyleDefault];
        _topBar.delegate = self;
        _topBar.dataSource = self;
        if ([YZUserCenter shared].userInfo.userType == UserType_Normal) {
            _topBar.topBarTitles = @[@"全部",@"待确认",@"已完成"];
        } else {
            _topBar.topBarTitles = @[@"全部",@"待确认",@"待发货",@"已完成"];
        }
        _topBar.backgroundColor = [UIColor whiteColor];
        
        _topBar.titleSelectedColor = [UIColor colorWithHex:0x62aa60];
        _topBar.titleNormalColor = [UIColor colorWithHex:0x666666];
        _topBar.bottomlineColor = [UIColor colorWithHex:0x62aa60];
        
        _topBar;
    });
}
//- (UILabel *)noCommentLabel {
//    if (!_noCommentLabel) {
//        _noCommentLabel = [[UILabel alloc] init];
//        _noCommentLabel.font = [UIFont systemFontOfSize:14];
//
//        _noCommentLabel.textColor = [UIColor colorWithHex:0x7e6848];
//
//    }
//    return _noCommentLabel;
//}
//
//- (UIImageView *)noCommentArrowImageView {
//    if (!_noCommentArrowImageView) {
//        _noCommentArrowImageView = [[UIImageView alloc] init];
//    }
//    return _noCommentArrowImageView;
//}
//
//- (UIView *)noCommentedView {
//    if (!_noCommentedView) {
//        _noCommentedView = [[UIView alloc] init];
//
//            _noCommentedView.backgroundColor = [UIColor colorWithHex:0xffecce];
//
//
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNoCommentVC)];
//        gesture.cancelsTouchesInView = NO;
//        [_noCommentedView addGestureRecognizer:gesture];
//    }
//    return _noCommentedView;
//}

#pragma mark - setter
//- (void)setCargoOrderStatus:(CargoOrderStatus)cargoOrderStatus{
//    _cargoOrderStatus = cargoOrderStatus;
//    switch (_cargoOrderStatus) {
//        case CargoOrderStatusInTransit:
//        {
//            self.topBar.selectedColumnIndex = 0;
//            break;
//        }
//        case CargoOrderStatusCompleted:
//        {
//            self.topBar.selectedColumnIndex = 1;
//            break;
//        }
//        case CargoOrderStatusCanceled:
//        {
//            self.topBar.selectedColumnIndex = 2;
//            break;
//        }
//        default:
//        {
//            self.topBar.selectedColumnIndex = 0;
//            break;
//        }
//    }
//}

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

@end
