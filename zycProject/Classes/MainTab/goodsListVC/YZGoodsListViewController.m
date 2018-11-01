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
#import "YZHomeGoodsCollectionHeaderView.h"

@interface YZGoodsListViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) NSMutableDictionary *headerIconDict;
@property (nonatomic, strong) NSMutableArray *goodsArray;

@end

@implementation YZGoodsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self refreshGoods:YES needLoading:YES];
}

#pragma mark - init
- (void)initView {
    //FIXME: 正式版本顶部有搜索框
    self.navigationItem.title = @"首页";
    
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
    
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    //    self.collectionView.tag = kCollectionViewTag;
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

#pragma mark - private

#pragma mark network
- (void)refreshGoods:(BOOL)refresh needLoading:(BOOL)needLoading{
    
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
#pragma mark collectionView
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
        [self performSegueWithIdentifier:@"detailVC" sender:((YZGoodsModel *)model).goodsId];
    }
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_goodslist_empty"];
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

@end
