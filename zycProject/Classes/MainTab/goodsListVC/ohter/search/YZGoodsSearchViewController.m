//
//  YZGoodsSearchViewController.m
//  zycProject
//
//  Created by yc on 2018/11/20.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZGoodsSearchViewController.h"

#import "YZGoodsModel.h"

#import "YZHomeGoodsCollectionCell.h"
#import "YZHomeGoodsCollectionHeaderView.h"

@interface YZGoodsSearchViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
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
static NSString * const kNZGoodsSearchCellIdentifiler = @"kNZGoodsSearchCellIdentifiler";


@implementation YZGoodsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self initDatas];
}

- (void)initViews {
    
    self.navigationItem.titleView = self.searchBar;

    self.collectionLayout.minimumLineSpacing = 4;
    self.collectionLayout.minimumInteritemSpacing = 4;
    
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZHomeGoodsCollectionCell class]) bundle:nil]
      forCellWithReuseIdentifier:[YZHomeGoodsCollectionCell yz_cellIdentifiler]];
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZHomeGoodsCollectionHeaderView class]) bundle:nil]
      forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
             withReuseIdentifier:[YZHomeGoodsCollectionHeaderView yz_cellIdentifiler]];
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NZGoodsSearchCell" bundle:nil]
         forCellReuseIdentifier:kNZGoodsSearchCellIdentifiler];
    [self.tableView registerNib:[UINib nibWithNibName:@"NZGoodsSearchCell" bundle:nil] forCellReuseIdentifier:kNZGoodsSearchCellIdentifiler];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
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
