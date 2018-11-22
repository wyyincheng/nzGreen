//
//  YZGoodsDetailViewController.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsDetailViewController.h"

#import "YZBuyNowViewController.h"
#import "SDCycleScrollView.h"
#import "YZGoodsModel.h"

#import "YZGoodsSpecificationsTableCell.h"
#import "YZGoodsDetailInfoTableCell.h"
#import "YZGoodsServiceTableCell.h"
#import "YZGoodsSelectView.h"
#import "YZGoodsIconTableCell.h"
#import "YZGoodsCountTableCell.h"
#import "YZWebViewController.h"
#import "YZGoodsWeightTableCell.h"
#import "YZSwitchTableCell.h"
#import "YZCommentModel.h"
#import "YZWebTableCell.h"
#import "YZCommentTableCell.h"
#import "YZCommentEmptyTableCell.h"

#import "YZShopCarViewController.h"
#import "YZBuyNowViewController.h"
//#import "MJRefreshBackNormalFooter.h"

@interface YZGoodsDetailViewController () <UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIWebViewDelegate> {
    BOOL hasSelectedCount;
    BOOL webLoadFinish;
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) YZGoodsModel *goodsModel;
@property (nonatomic, strong) UIWebView *detailView;
@property (nonatomic, strong) UIWebView *tempWebView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
//@property (nonatomic, assign) NSInteger goodsCount;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCartButton;

@property (nonatomic, strong) UIView *selectBkView;
@property (nonatomic, strong) UITableView *selectView;
@property (nonatomic, strong) UIButton *closeSelectViewBt;
@property (weak, nonatomic) IBOutlet UIButton *addToShoppingCartBt;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBt;
@property (nonatomic, strong) NSMutableArray *commentArray;
@property (nonatomic, assign) BOOL showComment;

@property(nonatomic,strong)NSMutableDictionary *heightDic;

@property (nonatomic, strong) UIView *webBackView;

@property (nonatomic, assign) CGRect webViewFrame;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom;
@property (nonatomic, copy) NSString *goodsId;

@end

static NSInteger kSelectViewTag = 1001;

@implementation YZGoodsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.detailView;
    //    self.tableView.pagingEnabled = YES;
    self.tableView.hidden = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsDetailInfoTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZGoodsDetailInfoTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsServiceTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZGoodsServiceTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsSpecificationsTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZGoodsSpecificationsTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZSwitchTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZSwitchTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZCommentTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZCommentTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZCommentEmptyTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZCommentEmptyTableCell yz_cellIdentifiler]];
    [self.tableView registerClass:[YZWebTableCell class]
           forCellReuseIdentifier:[YZWebTableCell yz_cellIdentifiler]];
    
    [self.view addSubview:self.selectBkView];
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.closeSelectViewBt];
    
    [self.selectBkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addToShoppingCartBt.mas_top);
    }];
    
    CGFloat height = [YZGoodsIconTableCell yz_heightForCellWithModel:@[] contentWidth:kScreenWidth] + [YZGoodsWeightTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth] + [YZGoodsCountTableCell yz_heightForCellWithModel:@[] contentWidth:kScreenWidth];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.addToShoppingCartBt.mas_top).offset(10);
        make.height.mas_equalTo(height);
    }];
    
    [self.closeSelectViewBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.selectView.mas_trailing).offset(0);
        make.top.mas_equalTo(self.selectView.mas_top).offset(0);
    }];
    
    [self.view bringSubviewToFront:self.addToShoppingCartBt];
    [self.view bringSubviewToFront:self.buyNowBt];
    
    //    self.webBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight + 10, kScreenWidth, 10)];
    //    [self.view addSubview:self.webBackView];
    //    [self.webBackView addSubview:self.detailView];
    
    self.heightDic = [[NSMutableDictionary alloc] init];
    
    //    // 注册加载完成高度的通知
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:@"WEBVIEW_HEIGHT" object:nil];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshComment:YES];
    }];
    
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [tempView addSubview:self.tempWebView];
    [self.view addSubview:tempView];
    
//    self.addToShoppingCartBt.hidden = ![YZUserCenter shared].hasReviewed;
//    self.shoppingCartButton.hidden = ![YZUserCenter shared].hasReviewed;
//    self.buyNowBt.hidden = ![YZUserCenter shared].hasReviewed;
//    self.tableViewBottom.constant = [YZUserCenter shared].hasReviewed ? 0 : -49;
}

- (void)loadWebView {
    if (webLoadFinish) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    __weak typeof(self) weakSelf = self;
    if (self.goodsId) {
        [MBProgressHUD showMessage:@""];
        [[YZNCNetAPI sharedAPI].productAPI getProductDetailWithGoodsId:self.goodsId
                                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                   weakSelf.goodsModel = [YZGoodsModel yz_objectWithKeyValues:responseObject];
                                                                   [weakSelf updateSelectView];
                                                                   weakSelf.goodsModel.count = 1;
                                                                   [weakSelf reloadDetailVC];
                                                               } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                   [MBProgressHUD showMessageAuto:error.msg];
                                                               }];
    }
    
    [self refreshComment:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self disMissSelectView];
}

- (void)refreshComment:(BOOL)isRefresh {
    
    if (!self.showComment) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI getCommentListWithProductId:self.goodsId
                                                         pageIndex:pageIndex
                                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                               if (isRefresh) {
                                                                   weakSelf.commentArray = [[YZCommentModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]] mutableCopy];
                                                               } else {
                                                                   [weakSelf.commentArray addObjectsFromArray: [[YZCommentModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]] mutableCopy]];
                                                               }
                                                               if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.commentArray.count > 0) {
                                                                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                               }
                                                               [weakSelf.tableView reloadData];
                                                           } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                               
                                                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private
- (void)updateSelectView {
    CGFloat height = [YZGoodsIconTableCell yz_heightForCellWithModel:@[] contentWidth:kScreenWidth] + [YZGoodsWeightTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth] + [YZGoodsCountTableCell yz_heightForCellWithModel:@[] contentWidth:kScreenWidth];
    [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)reloadDetailVC {
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    [self.detailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsModel.detail]]];
    [self.tempWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsModel.detail]]];
    self.bannerView.imageURLStringsGroup = self.goodsModel.imageList;
    [self.selectView reloadData];
}

- (IBAction)goback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goShoprCar:(id)sender {
    if (![YZUserCenter shared].userInfo) {
        [[YZUserCenter shared] gotoLogin];
        return;
    }
    [self gotoViewController:NSStringFromClass([YZShopCarViewController class])];
}

- (IBAction)addShopCar:(id)sender {
    if (![YZUserCenter shared].userInfo) {
        [[YZUserCenter shared] gotoLogin];
        return;
    }
#warning 交互需要讨论
    if (!_selectView.hidden && self.goodsModel.count == 0) {
        [MBProgressHUD showMessageAuto:@"请输入合理的购物数量"];
        return;
    } else if (_selectView.hidden) {
        [self showSelectView];
        return;
    }
    
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].productAPI addShoppingCarWithGoodsId:self.goodsId
                                                     goodsNumber:[NSNumber numberWithInteger:self.goodsModel.count]
                                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                             NSLog(@"respondes: %@",responseObject);
                                                             [MBProgressHUD hideHUD];
                                                             [MBProgressHUD showSuccess:@"已添加至购物车"];
                                                             [weakSelf disMissSelectView];
                                                         } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                             [MBProgressHUD hideHUD];
                                                             [MBProgressHUD showError:error.msg];
                                                         }];
}

- (IBAction)buyGoodsAction:(id)sender {
    if (![YZUserCenter shared].userInfo) {
        [[YZUserCenter shared] gotoLogin];
        return;
    }
    if (!_selectView.hidden && self.goodsModel.count == 0) {
        [MBProgressHUD showMessageAuto:@"请输入合理的购物数量"];
        return;
    } else if (_selectView.hidden) {
        [self showSelectView];
        return;
    }
    [self gotoViewController:NSStringFromClass([YZBuyNowViewController class])
                 lauchParams:@{kYZLauchParams_GoodsModel:self.goodsModel,
                               kYZLauchParams_GoodsDict:@{@"type":@(BuyType_GoodsDetail)}}];
}

- (void)showSelectView {
    //    hasSelectedCount = YES;
    self.selectBkView.hidden = NO;
    self.selectView.hidden = NO;
    self.closeSelectViewBt.hidden = NO;
}

- (void)disMissSelectView {
    self.selectView.hidden = YES;
    self.selectBkView.hidden = YES;
    self.closeSelectViewBt.hidden = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:kYZNotification_HiddenKeyBoard
                                                        object:nil];
}

#pragma mark - jump
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"buynowVC"]) {
//        YZBuyNowViewController *vc = segue.destinationViewController;
//        vc.goodsDict = @{@"type":@(BuyType_GoodsDetail)};
//        vc.goodsModel = sender;
//    }
//}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == kSelectViewTag) {
        return 1;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (kSelectViewTag == tableView.tag) {
        return 3;
    }
    if (section == 4) {
        if (self.showComment) {
            return self.commentArray.count > 0 ? self.commentArray.count : 1;
        } else {
            return 0;
        }
    }
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (kSelectViewTag == tableView.tag || section == 3) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHex:0xF4F4F4];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (kSelectViewTag == tableView.tag || section == 3) {
        return 0.0f;
    }
    return 8.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kSelectViewTag == tableView.tag) {
        switch (indexPath.row) {
            case 0:
                return [YZGoodsIconTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth];
            case 1:
                return [YZGoodsWeightTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth];
            case 2:
                return [YZGoodsCountTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth];
            default:
                return 0.0f;
        }
    } else {
        switch (indexPath.section) {
            case 0:
                return [YZGoodsDetailInfoTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth];
            case 1:
                return [YZGoodsServiceTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth];
            case 2:
                return [YZGoodsSpecificationsTableCell yz_heightForCellWithModel:self.goodsModel contentWidth:kScreenWidth];
            case 3:
                return [YZSwitchTableCell yz_heightForCellWithModel:@[] contentWidth:kScreenWidth];
            case 4:
                return [YZCommentTableCell yz_heightForCellWithModel:[self.commentArray yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
            default:
                return 0.0f;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kSelectViewTag == tableView.tag) {
        switch (indexPath.row) {
            case 0: {
                YZGoodsIconTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsIconTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.goodsModel];
                return cell;
            }
            case 1: {
                YZGoodsWeightTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsWeightTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.goodsModel];
                return cell;
            }
            case 2: {
                YZGoodsCountTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsCountTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.goodsModel];
                return cell;
            }
            default:
                return [UITableViewCell new];
        }
    } else {
        switch (indexPath.section) {
            case 0: {
                YZGoodsDetailInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsDetailInfoTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.goodsModel];
                return cell;
            }
            case 1: {
                YZGoodsServiceTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsServiceTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.goodsModel];
                return cell;
            }
            case 2: {
                YZGoodsSpecificationsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsSpecificationsTableCell yz_cellIdentifiler]];
                [cell yz_configWithModel:self.goodsModel];
                return cell;
            }
            case 3: {
                YZSwitchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZSwitchTableCell yz_cellIdentifiler]];
                cell.commentCount = self.commentArray.count;
                __weak typeof(self) weakSelf = self;
                cell.switchInfoBlock = ^(NSInteger index) {
                    weakSelf.showComment = (index == 1);
                    if (weakSelf.showComment) {
                        weakSelf.detailView.hidden = YES;
                        weakSelf.tableView.tableFooterView = [UIView new];
                        //                        weakSelf.detailView.frame = CGRectMake(0, 0, kScreenWidth, 1);
                        //                        weakSelf.tableView.tableFooterView = self.detailView;
                    } else {
                        weakSelf.detailView.hidden = NO;
                        weakSelf.detailView.frame = weakSelf.webViewFrame;
                        weakSelf.tableView.tableFooterView = self.detailView;
                    }
                    [weakSelf.tableView reloadData];
                    //                    if (weakSelf.showComment) {
                    //                        [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                    //                    }
                };
                return cell;
            }
                //            case 4: {
                //
                //                NZWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNZWebTableViewCellIdentifiler];
                //                cell.tag = indexPath.row;
                //                // 赋值 把需要的html放里面就好了，不需要其他操作
                //                cell.contentStr = self.goodsModel.detail;
                //
                //                return cell;
                ////                NZWebTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNZWebTableViewCellIdentifiler];
                ////                [cell yz_configWithModel:self.goodsModel.detail];
                ////                return cell;
                //            }
            case 4: {
                YZCommentModel *model = [self.commentArray yz_objectAtIndex:indexPath.row];
                if (model) {
                    YZCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZCommentTableCell yz_cellIdentifiler]];
                    [cell yz_configWithModel:model];
                    return cell;
                } else {
                    YZCommentEmptyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZCommentEmptyTableCell yz_cellIdentifiler]];
                    return cell;
                }
            }
                
            default:
                return [UITableViewCell new];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        [self showSelectView];
    }
}

//webView
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    if (webView.tag == 99) {
//        CGRect frame = webView.frame;
//        frame.size.height = 1;
//        webView.frame = frame;
//        CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
//        frame.size = fittingSize;
//        webView.frame = frame;
//
//        NSString *javascript = [NSString stringWithFormat:@"var viewPortTag=document.createElement('meta');  \
//                                viewPortTag.id='viewport';  \
//                                viewPortTag.name = 'viewport';  \
//                                viewPortTag.content = 'width=%d; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;';  \
//                                document.getElementsByTagName('head')[0].appendChild(viewPortTag);" , (int)kScreenWidth];
//        [webView stringByEvaluatingJavaScriptFromString:javascript];
//
//        self.detailView = webView;
//        self.detailView.hidden = NO;
//
//        [_tableView beginUpdates];
//        [_tableView setTableFooterView:self.detailView];
//        [_tableView endUpdates];
//
//        webLoadFinish = YES;
//        [self.tableView.mj_footer endRefreshing];
//    }
//}

#pragma mark - delegate
- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        [_headerView addSubview:self.bannerView];
    }
    return _headerView;
}

- (SDCycleScrollView *)bannerView {
    if (!_bannerView) {
        CGFloat width = kScreenWidth * 200/375;
        _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake((kScreenWidth - width)/2, (kScreenWidth - width)/2+15, width, width)
                                                         delegate:self
                                                 placeholderImage:[UIImage yz_imageWithNamed:@"icon_goods_placeholder_240x260"
                                                                                    backSize:CGSizeMake(width, width)]];
    }
    return _bannerView;
}

- (UIWebView *)detailView {
    if (!_detailView) {
        _detailView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
        _detailView.scalesPageToFit = YES;
        _detailView.delegate = self;
        _detailView.hidden = NO;
        
        //使用kvo为webView添加监听，监听webView的内容高度
        [_detailView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    }
    return _detailView;
}

- (UIWebView *)tempWebView {
    if (!_tempWebView) {
        _tempWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _tempWebView.scalesPageToFit = YES;
        _tempWebView.delegate = self;
        _tempWebView.tag = 99;
    }
    return _tempWebView;
}

//实时改变webView的控件高度，使其高度跟内容高度一致
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGRect frame = self.detailView.frame;
        frame.size.height = self.detailView.scrollView.contentSize.height;
        self.detailView.frame = frame;
        self.webViewFrame = frame;
        self.tableView.tableFooterView = self.detailView;
    }
}

- (UITableView *)selectView {
    if (!_selectView) {
        //            CGFloat height = [NZGoodsIconCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth] + [NZGoodsWeightCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth] + [NZGoodsCountCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
        _selectView = [[YZGoodsSelectView alloc] initWithFrame:CGRectZero
                                                         style:UITableViewStylePlain];
        _selectView.delegate = self;
        _selectView.dataSource = self;
        
        _selectView.estimatedRowHeight = 0;
        _selectView.estimatedSectionFooterHeight = 0;
        _selectView.estimatedSectionHeaderHeight = 0;
        
        [_selectView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsIconTableCell class]) bundle:nil]
          forCellReuseIdentifier:[YZGoodsIconTableCell yz_cellIdentifiler]];
        [_selectView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsCountTableCell class]) bundle:nil]
          forCellReuseIdentifier:[YZGoodsCountTableCell yz_cellIdentifiler]];
        [_selectView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsWeightTableCell class]) bundle:nil]
          forCellReuseIdentifier:[YZGoodsWeightTableCell yz_cellIdentifiler]];
        
        //        [self.view addSubview:_selectView];
        _selectView.tag = kSelectViewTag;
        _selectView.backgroundColor = [UIColor whiteColor];
        _selectView.hidden = YES;
        _selectView.layer.cornerRadius = 10;
        
        //        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_selectView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        //        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        //        maskLayer.frame = _selectView.bounds;
        //        maskLayer.path = maskPath.CGPath;
        //        _selectView.layer.mask = maskLayer;
    }
    return _selectView;
}

- (UIButton *)closeSelectViewBt {
    if (!_closeSelectViewBt) {
        _closeSelectViewBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeSelectViewBt addTarget:self action:@selector(disMissSelectView) forControlEvents:UIControlEventTouchUpInside];
        [_closeSelectViewBt setImage:[UIImage yz_imageWithNamed:@"icon_detail_close" backSize:CGSizeMake(43, 43)] forState:UIControlStateNormal];
        _closeSelectViewBt.adjustsImageWhenHighlighted = NO;
        _closeSelectViewBt.hidden = YES;
        _closeSelectViewBt.layer.masksToBounds = YES;
        _closeSelectViewBt.layer.cornerRadius = 10;
    }
    return _closeSelectViewBt;
}

- (UIView *)selectBkView {
    if (!_selectBkView) {
        _selectBkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49)];
        _selectBkView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissSelectView)];
        [_selectBkView addGestureRecognizer:tap];
        _selectBkView.userInteractionEnabled = YES;
        _selectBkView.hidden = YES;
        [self.view addSubview:_selectBkView];
    }
    return _selectBkView;
}

- (NSMutableArray *)commentArray {
    if (!_commentArray) {
        _commentArray = [NSMutableArray array];
    }
    return _commentArray;
}

- (NSString *)goodsId {
    if (!_goodsId) {
        _goodsId = [self.lauchParams yz_stringForKey:kYZLauchParams_GoodsId];
    }
    return _goodsId;
}

-(void)dealloc {
    //销毁的时候别忘移除监听
    [_detailView.scrollView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
