//
//  YZSearchGoodsViewController.m
//  zycProject
//
//  Created by yc on 2018/11/20.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZSearchGoodsViewController.h"

#import "YZGoodsModel.h"

#import "YZGoodsSearchTableCell.h"
#import "YZHomeGoodsCollectionCell.h"

@interface YZSearchGoodsViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) NSMutableDictionary *searchKeyDict;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) NSMutableArray *searchGoodsArray;

@end

static NSString * const kLastQueryTime = @"kLastQueryTime";
static NSString * const kSearchKeyArray = @"kSearchKeyArray";
static NSString * const kGoodsSearhResultCell = @"kGoodsSearhResultCell";

@implementation YZSearchGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    [self initDatas];
    [self.searchBar becomeFirstResponder];
    self.tableView.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.hidden = YES;
}

- (void)initViews {
    
    self.navigationItem.titleView = self.searchBar;
    
    self.collectionLayout.minimumLineSpacing = 4;
    self.collectionLayout.minimumInteritemSpacing = 4;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZHomeGoodsCollectionCell class])
                                                bundle:nil]
      forCellWithReuseIdentifier:[YZHomeGoodsCollectionCell yz_cellIdentifiler]];
    //    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZHomeGoodsCollectionHeaderView class])
    //                                                bundle:nil]
    //      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
    //             withReuseIdentifier:[YZHomeGoodsCollectionHeaderView yz_cellIdentifiler]];
    
    __weak typeof(self) weakSelf = self;
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf searchGoods:YES needLoading:(weakSelf.searchGoodsArray.count == 0)];
    }];
    _collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf searchGoods:NO needLoading:NO];
    }];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self.view);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsSearchTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZGoodsSearchTableCell yz_cellIdentifiler]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initDatas {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSearchKeyArray];
    if (dict) {
        self.searchKeyDict = [dict mutableCopy];
    }
    
    NSNumber *lastTimeLg = @(0);
    
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].productAPI updateSearchKeyListWithLastQueryTime:lastTimeLg
                                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
#warning for yc 这里还有好多逻辑处理，过期 type time 等
                                                                        NSTimeInterval timeFlag = [[NSDate date] timeIntervalSince1970];
                                                                        NSArray *temp = [responseObject yz_arrayForKey:@"configs"];
                                                                        for (NSDictionary *dict in temp) {
                                                                            if ([dict yz_stringForKey:@"keyword"]) {
                                                                                [weakSelf.searchKeyDict setValue:dict forKey:[dict yz_stringForKey:@"keyword"]];
                                                                            }
                                                                        }
                                                                        [weakSelf.searchKeyDict setValue:[NSNumber numberWithInteger:timeFlag * 1000] forKey:kLastQueryTime];
                                                                        [[NSUserDefaults standardUserDefaults] setValue:weakSelf.searchKeyDict forKey:kSearchKeyArray];
                                                                        [[NSUserDefaults standardUserDefaults] synchronize];
                                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                        NSLog(@"error");
                                                                    }];
    
}

#pragma mark - private

#pragma mark network
- (void)searchGoods:(BOOL)refresh needLoading:(BOOL)needLoading{
    __weak typeof(self) weakSelf = self;
    pageIndex = refresh ? 1 : pageIndex + 1;
    if (refresh && needLoading) {
        [MBProgressHUD showMessage:@""];
    }
    if (refresh) {
        [self.collectionView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI searchProductWithKeyWorld:self.searchBar.text
                                                       pageIndex:pageIndex
                                                         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                             [weakSelf.collectionView.mj_header endRefreshing];
                                                             [weakSelf.collectionView.mj_footer endRefreshing];
                                                             
                                                             NSArray *userArray = [[YZGoodsModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]] mutableCopy];
                                                             if (refresh) {
                                                                 weakSelf.searchGoodsArray = [userArray mutableCopy];
                                                             } else {
                                                                 [weakSelf.searchGoodsArray  addObjectsFromArray:userArray];
                                                             }
                                                             if (weakSelf.searchGoodsArray.count > 0) {
                                                                 [weakSelf.searchBar resignFirstResponder];
                                                             }
                                                             
                                                             if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.searchGoodsArray.count > 0) {
                                                                 [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                                                             }
                                                             
                                                             weakSelf.tableView.hidden = YES;
                                                             [weakSelf.collectionView reloadData];
                                                             weakSelf.searchBar.showsCancelButton = YES;
                                                         } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                             [MBProgressHUD showMessageAuto:error.msg];
                                                             [weakSelf.collectionView.mj_header endRefreshing];
                                                             [weakSelf.collectionView.mj_footer endRefreshing];
                                                         }];
}

#pragma mark - delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //    self.searchGoodsArray = nil;
    [self.collectionView reloadData];
    [self searchGoods:YES needLoading:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissSearchResult:YES];
}

- (void)dismissSearchResult:(BOOL)needLoading {
    self.searchBar.text = nil;
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    self.searchResult = nil;
    self.searchGoodsArray = nil;
    self.tableView.hidden = YES;
    //    self.goodsArray = nil;
    //    [self.collectionView reloadData];
    //    [self refreshProducts:YES needLoading:needLoading];
    //    //    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchBar:%@  searchText:%@ ",searchBar.text,searchText);
    
    if (searchText.length > 0) {
        self.searchResult = [NSMutableArray array];
        
        NSMutableDictionary *dict = [self.searchKeyDict mutableCopy];
        [dict removeObjectForKey:kLastQueryTime];
        for (NSString *temp in dict.allKeys) {
            if ([temp containsString:searchText]) {
                if ([dict yz_dictForKey:temp] &&
                    [[dict yz_dictForKey:temp] yz_integerForKey:@"isValid"] == 1) {
                    [self.searchResult addObject:[dict yz_dictForKey:temp]];
                }
            }
        }
    } else {
        self.searchResult = nil;
    }
    [self.tableView reloadData];
}

#pragma mark collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searchGoodsArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = [YZHomeGoodsCollectionCell yz_sizeForCellWithModel:[self.searchGoodsArray yz_objectAtIndex:indexPath.row]
                                                        contentWidth:(kScreenWidth - 5)/2];
    CGFloat height = ((size.height > 0 && indexPath.row < 2 && self.searchBar.text.length == 0) ? size.height - 22.5 : size.height);
    return CGSizeMake(size.width, height + 10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZHomeGoodsCollectionCell *goodsCell = [YZHomeGoodsCollectionCell yz_createCellForCollectionView:collectionView
                                                                                           indexPath:indexPath];
    [goodsCell yz_configWithModel:[self.searchGoodsArray yz_objectAtIndex:indexPath.row]];
    return goodsCell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    if (self.searchBar.text.length > 0) {
//        return CGSizeZero;
//    }
//    return [YZHomeGoodsCollectionHeaderView yz_heightForCellWithModel:self.headerIconDict
//                                           contentWidth:kScreenWidth];
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && self.searchBar.text.length == 0) {
//        NZGoodsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                           withReuseIdentifier:[NZGoodsHeaderView cellIdentifiler]
//                                                                                  forIndexPath:indexPath];
//        [headerView yc_configWithModel:self.headerIconDict];
//        return headerView;
//    }
//    return nil;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.searchGoodsArray yz_objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        //TODO: goto detailVC
        //        [self performSegueWithIdentifier:@"detailVC" sender:((NZGoodsModel *)model).goodsId];
    }
}

//tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YZGoodsSearchTableCell yz_heightForCellWithModel:[self.searchResult yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZGoodsSearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZGoodsSearchTableCell yz_cellIdentifiler]];
    [cell yz_configWithModel:[[self.searchResult yz_objectAtIndex:indexPath.row] yz_stringForKey:@"keyword"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.searchResult yz_objectAtIndex:indexPath.row];
    if ([model isKindOfClass:[YZGoodsModel class]]) {
        //TODO:
        //        [self performSegueWithIdentifier:@"detailVC" sender:((NZGoodsModel *)model).goodsId];
    } else if ([model isKindOfClass:[NSDictionary class]]) {
        self.searchGoodsArray = nil;
        [self.collectionView reloadData];
        self.searchBar.text = [model yz_stringForKey:@"keyword"];
        [self searchGoods:YES needLoading:YES];
    }
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:kYZVCDefaultEmptyIcon];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = (self.searchBar.text.length > 0 ? @"哎呀，没有搜到相关内容！\n 换个关键词试试" : @"哎呀，商品列表竟然是空的！");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.searchBar.text.length > 0) {
        return -100;
    }
    return 0;
}

//- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
//    return !self.isSearchGoods;
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"detailVC"]) {
//        NZGoodsDetailViewController *vc = segue.destinationViewController;
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.goodsId = sender;
//    }
//}

#pragma mark - property
- (NSMutableArray *)searchGoodsArray {
    if (!_searchGoodsArray) {
        _searchGoodsArray = [NSMutableArray array];
    }
    return _searchGoodsArray;
}

- (NSMutableDictionary *)searchKeyDict {
    if (!_searchKeyDict) {
        _searchKeyDict = [NSMutableDictionary dictionary];
    }
    return _searchKeyDict;
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
        
        //        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGoodsSearhResultCell];
        _tableView.hidden = YES;
    }
    return _tableView;
}


@end
