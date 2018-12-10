//
//  YZGoodsListViewController.m
//  zycProject
//
//  Created by yc on 2018/11/1.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsListViewController.h"

#import "YZGoodsModel.h"
#import "YZHomeGoodsCollectionCell.h"
#import "YZGoodsDetailViewController.h"
#import "YZSearchGoodsViewController.h"
#import "YZHomeGoodsCollectionHeaderView.h"

@interface YZGoodsListViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UISearchBarDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) NSMutableDictionary *headerIconDict;
@property (nonatomic, strong) NSMutableArray *goodsArray;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchBt;

@end

@implementation YZGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.goodsArray.count == 0) {
        [self refreshGoods:YES needLoading:YES];
    }
    [self fetchGoodsListHeaderIcon];
}

#pragma mark - init
- (void)initView {
    
    self.navigationItem.titleView = self.searchBar;
    [self.searchBar addSubview:self.searchBt];
    [self.searchBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self.searchBar);
    }];
    
    self.collectionLayout.minimumLineSpacing = 4;
    self.collectionLayout.minimumInteritemSpacing = 4;
    self.collectionView.backgroundColor = kYZBackViewColor;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZHomeGoodsCollectionCell class]) bundle:nil]
      forCellWithReuseIdentifier:[YZHomeGoodsCollectionCell yz_cellIdentifiler]];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZHomeGoodsCollectionHeaderView class]) bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:[YZHomeGoodsCollectionHeaderView yz_cellIdentifiler]];
    
    __weak typeof(self) weakSelf = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshGoods:YES needLoading:(weakSelf.goodsArray.count == 0)];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshGoods:NO needLoading:NO];
    }];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

#pragma mark - private

#pragma mark network
- (void)refreshGoods:(BOOL)refresh needLoading:(BOOL)needLoading {

    pageIndex = refresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (refresh && needLoading) {
        [MBProgressHUD showMessage:@""];
    }
    if (refresh) {
        [self.collectionView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI getProductListWithPageIndex:pageIndex
                                                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                               [MBProgressHUD hideHUD];
                                                               [weakSelf.collectionView.mj_header endRefreshing];
                                                               [weakSelf.collectionView.mj_footer endRefreshing];
                                                               NSArray *userArray = [YZGoodsModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                               if (refresh) {
                                                                   weakSelf.goodsArray = [userArray mutableCopy];
                                                               } else {
                                                                   [weakSelf.goodsArray  addObjectsFromArray:userArray];
                                                               }
                                                               if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.goodsArray.count > 0) {
                                                                   [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                                                               }
                                                               [weakSelf.collectionView reloadData];
                                                           } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                               [MBProgressHUD hideHUD];
                                                               [weakSelf.collectionView.mj_header endRefreshing];
                                                               [weakSelf.collectionView.mj_footer endRefreshing];
                                                               [MBProgressHUD showMessageAuto:error.msg];
                                                           }];
}

- (void)fetchGoodsListHeaderIcon {
    YZ_Weakify(self, weakSelf);
    [[YZNCNetAPI sharedAPI].userAPI getShopInfoWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *headerIcon = [[responseObject yz_stringForKey:@"shopImage"] imageUrlString];
        [weakSelf.headerIconDict setValue:@(self.goodsArray.count) forKey:@"GoodsCount"];
        [weakSelf.headerIconDict setValue:headerIcon forKey:@"HeaderIcon"];
        [weakSelf.collectionView reloadData];
    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
        
    }];
}

#pragma mark - delegate
- (void)gotoSearchVC {
    [self gotoViewController:NSStringFromClass([YZSearchGoodsViewController class])];
}

#pragma mark searchBar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self gotoViewController:NSStringFromClass([YZSearchGoodsViewController class])];
}

#pragma mark collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [YZHomeGoodsCollectionCell yz_sizeForCellWithModel:[self.goodsArray yz_objectAtIndex:indexPath.row]
                                                        contentWidth:(kScreenWidth - 5)/2];
    //第一行cell会和headerView重叠部分，要做特殊处理
    CGFloat height = ((size.height > 0 && indexPath.row < 2) ? size.height - 22.5 : size.height);
    return CGSizeMake(size.width, height + 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZHomeGoodsCollectionCell *goodsCell = [YZHomeGoodsCollectionCell yz_createCellForCollectionView:collectionView
                                                                                           indexPath:indexPath];
    [goodsCell yz_configWithModel:[self.goodsArray yz_objectAtIndex:indexPath.row]];
    return goodsCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return [YZHomeGoodsCollectionHeaderView yz_heightForCellWithModel:self.headerIconDict
                                                         contentWidth:kScreenWidth];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        YZHomeGoodsCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                                         withReuseIdentifier:[YZHomeGoodsCollectionHeaderView yz_cellIdentifiler]
                                                                                                forIndexPath:indexPath];
        [headerView yz_configWithModel:self.headerIconDict];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.goodsArray yz_objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        [self gotoViewController:NSStringFromClass([YZGoodsDetailViewController class])
                     lauchParams:@{kYZLauchParams_GoodsId:((YZGoodsModel *)model).goodsId}];
    }
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:kYZVCDefaultEmptyIcon];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:@"哎呀，商品列表竟然是空的！" attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

//- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
//    return 0;
//}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"detailVC"]) {
//        NZGoodsDetailViewController *vc = segue.destinationViewController;
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.goodsId = sender;
//    }
//}

#pragma mark - property
- (NSMutableArray *)goodsArray {
    if (!_goodsArray) {
        NSMutableArray *marray = [NSMutableArray array];
        _goodsArray = marray;
    }
    return _goodsArray;
}

- (NSMutableDictionary *)headerIconDict {
    if (!_headerIconDict) {
        _headerIconDict = [NSMutableDictionary dictionary];
    }
    return _headerIconDict;
}

- (UIButton *)searchBt {
    if (!_searchBt) {
        _searchBt = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBt addTarget:self
                      action:@selector(gotoSearchVC)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBt;
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundImage = [UIImage imageNamed:@"icon_search"];
        
        UITextField *searchTextField = [_searchBar valueForKey:@"_searchField"];
        searchTextField.font = [UIFont systemFontOfSize:16];
        searchTextField.textColor = [UIColor colorWithHex:0x999999];
        searchTextField.backgroundColor = [UIColor colorWithHex:0x8E8E93 alpha:0.2];
        
        _searchBar.tintColor = [UIColor colorWithHex:0x999999];
        
        [_searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
        
        _searchBar.delegate = self;
    }
    return _searchBar;
}

@end
