//
//  YZCategoryViewController.m
//  zycProject
//
//  Created by yc on 2018/11/11.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZCategoryViewController.h"

#import "YZCategoryTableCell.h"
#import "YZCategoryCollectionCell.h"

@interface YZCategoryViewController () <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableViews;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

@end

static NSString * const kCategoryTitleKey = @"kCategoryTitleKey";
static NSString * const kCategoryValueKey = @"kCategoryValueKey";

@implementation YZCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableViews registerNib:[UINib nibWithNibName:NSStringFromClass([YZCategoryTableCell class])
                                                bundle:nil]
          forCellReuseIdentifier:[YZCategoryTableCell yz_cellIdentifiler]];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([YZCategoryCollectionCell class])
                                                    bundle:nil]
          forCellWithReuseIdentifier:[YZCategoryCollectionCell yz_cellIdentifiler]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [YZCategoryTableCell yz_heightForCellWithModel:nil contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZCategoryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZCategoryTableCell yz_cellIdentifiler]];
    [cell yz_configWithModel:[[self.dataArray yz_dictAtIndex:indexPath.row] yz_stringForKey:kCategoryTitleKey]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self.dataArray yz_dictAtIndex:section] yz_arrayForKey:kCategoryValueKey] count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [YZCategoryCollectionCell yz_sizeForCellWithModel:nil contentWidth:kScreenWidth];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YZCategoryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YZCategoryCollectionCell yz_cellIdentifiler]
                                                                               forIndexPath:indexPath];
    [cell yz_configWithModel:nil];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[@{kCategoryTitleKey:@"奶粉",kCategoryValueKey:@[@"奶粉",@"婴儿奶粉"]},
                       @{kCategoryTitleKey:@"个人护理",kCategoryValueKey:@[@"洗发水",@"牙膏",@"洗面奶",@"护发素"]},
                       @{kCategoryTitleKey:@"化妆品",kCategoryValueKey:@[@"口红",@"面膜",@"爽肤水",@"润唇",@"面霜"]},
                       @{kCategoryTitleKey:@"营养品",kCategoryValueKey:@[@"维生素",@"蔓越莓",@"胶原蛋白",@"鱼油",@"蛋白粉"]},
                       @{kCategoryTitleKey:@"保健品",kCategoryValueKey:@[@"保健品",@"精油",@"前列康"]},
                       @{kCategoryTitleKey:@"其他",kCategoryValueKey:@[@"墨镜"]}];
    }
    return _dataArray;
}

@end
