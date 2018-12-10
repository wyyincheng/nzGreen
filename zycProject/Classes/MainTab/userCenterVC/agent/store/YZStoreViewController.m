//
//  YZStoreViewController.m
//  zycProject
//
//  Created by yc on 2018/12/4.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZStoreViewController.h"

#import "YZShopInfoModel.h"
#import "YZAgentGoodsModel.h"

#import "NZStoreItemCell.h"
#import "NZStoreHeaerCell.h"
#import "ZLPhotoActionSheet.h"
#import "YZGoodsSearchTableCell.h"

@interface YZStoreViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UITextFieldDelegate,UISearchBarDelegate> {
    NSInteger pageIndex;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerBgView;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) UIView *headerView;
@property (nonatomic, strong) YZAgentGoodsModel *changeModel;
@property (nonatomic, strong) YZShopInfoModel *shopInfo;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (strong, nonatomic) UIBarButtonItem *searchItem;
@property (nonatomic, strong) UITableView *searchResultView;

@property (nonatomic, assign) BOOL isSearchGoods;
@property (nonatomic, strong) NSMutableArray *searchResult;
@property (nonatomic, strong) NSMutableArray *searchGoodsArray;
@property (nonatomic, strong) NSMutableDictionary *searchKeyDict;

@end

CGFloat kSearchResultViewTag = 1230;

static NSString * const kLastQueryTime = @"kLastQueryTime";
static NSString * const kSearchKeyArray = @"kSearchKeyArray";
static NSString * const kNZStoreItemCellIdentifiler = @"kNZStoreItemCellIdentifiler";
static NSString * const kNZStoreHeaerCellIdentifiler = @"kNZStoreHeaerCellIdentifiler";

static NSString * const kGoodsSearhResultCell = @"kGoodsSearhResultCell";
//static NSString * const kNZGoodsSearchCellIdentifiler = @"kNZGoodsSearchCellIdentifiler";

@implementation YZStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = kYZBackViewColor;
    
    self.searchItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                    target:self
                                                                    action:@selector(searchAction:)];
    self.navigationItem.rightBarButtonItem = self.searchItem;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshGoods:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshGoods:NO];
    }];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NZStoreItemCell" bundle:nil]
         forCellReuseIdentifier:kNZStoreItemCellIdentifiler];
    [self.tableView registerNib:[UINib nibWithNibName:@"NZStoreHeaerCell" bundle:nil]
         forCellReuseIdentifier:kNZStoreHeaerCellIdentifiler];
    
    [self.tableView addSubview:self.headerBgView];
    
    self.title = nil;
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kSearchKeyArray];
    if (dict) {
        self.searchKeyDict = [dict mutableCopy];
    }
    
    [self.view addSubview:self.searchResultView];
    [self.searchResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self.view);
    }];
    //    self.searchResultView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.searchResultView.emptyDataSetSource = self;
    self.searchResultView.emptyDataSetDelegate = self;
    
    self.searchResultView.estimatedRowHeight = 0;
    self.searchResultView.estimatedSectionHeaderHeight = 0;
    self.searchResultView.estimatedSectionFooterHeight = 0;
    
    self.searchResultView.tableFooterView = [UIView new];
    
//    [self.searchResultView registerNib:[UINib nibWithNibName:@"NZGoodsSearchCell" bundle:nil] forCellReuseIdentifier:kNZGoodsSearchCellIdentifiler];
    [self.searchResultView registerNib:[UINib nibWithNibName:NSStringFromClass([YZGoodsSearchTableCell class]) bundle:nil]
               forCellReuseIdentifier:[YZGoodsSearchTableCell yz_cellIdentifiler]];
    [self.searchResultView registerNib:[UINib nibWithNibName:@"NZStoreItemCell" bundle:nil]
                forCellReuseIdentifier:kNZStoreItemCellIdentifiler];
    self.searchResultView.tag = kSearchResultViewTag;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //    //    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //    //    [UIApplication sharedApplication].statusBarHidden = YES;
    //
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //    //    //去掉透明后导航栏下边的黑边
    //    //    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self refreshGoods:YES];
    [self refreshShopInfo];
}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshShopInfo {
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI getShopInfoWithSuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        weakSelf.shopInfo = [YZShopInfoModel yz_objectWithKeyValues:responseObject];
        [weakSelf.tableView reloadData];
    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
        [MBProgressHUD showError:error.msg];
    }];
}

- (void)refreshGoods:(BOOL)isRefresh {
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].userAPI getStoreInfoWithPageIndex:pageIndex
                                                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                          [weakSelf.tableView.mj_header endRefreshing];
                                                          [weakSelf.tableView.mj_footer endRefreshing];
                                                          NSArray *userArray = [YZAgentGoodsModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                          if (isRefresh) {
                                                              weakSelf.array = [userArray mutableCopy];
                                                          } else {
                                                              [weakSelf.array  addObjectsFromArray:userArray];
                                                          }
                                                          if (weakSelf.array.count > 0) {
                                                              weakSelf.tableView.tableHeaderView = self.headerView;
                                                          }
                                                          if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.array.count > 0) {
                                                              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                          }
                                                          [weakSelf.tableView reloadData];
                                                      } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                          [weakSelf.tableView.mj_header endRefreshing];
                                                          [weakSelf.tableView.mj_footer endRefreshing];
                                                          [MBProgressHUD showMessageAuto:error.msg];
                                                      }];
}

#pragma mark - action
- (void)deleteAccountLog:(YZAgentGoodsModel *)model {
    __weak typeof(self) weakSelf = self;
    //    [[BaseAPI sharedAPI].userService delAccountLogWithLogId:model.logId
    //                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //                                                        [weakSelf.array removeObject:model];
    //                                                        [weakSelf.tableView reloadData];
    //                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
    //                                                        [MBProgressHUD showError:error.msg];
    //                                                    }];
}


- (IBAction)searchAction:(id)sender {
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = nil;
    [self.searchBar becomeFirstResponder];
}

#pragma mark - searchBar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchGoods:searchBar.text refresh:YES needLoading:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissSearchResult:YES];
}

- (void)dismissSearchResult:(BOOL)needLoading {
    self.searchBar.text = nil;
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
    
    self.navigationItem.titleView = nil;
    self.navigationItem.rightBarButtonItem = self.searchItem;
    
    self.searchResult = nil;
    self.searchGoodsArray = nil;
    self.searchResultView.hidden = YES;
    
    //    [self.tableView reloadData];
    [self refreshGoods:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.isSearchGoods = YES;
    self.searchResultView.hidden = NO;
    [self.searchResultView reloadData];
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.isSearchGoods = NO;
    [self.searchResultView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.isSearchGoods = YES;
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
    [self.searchResultView reloadData];
}

- (void)searchGoods:(NSString *)keyword refresh:(BOOL)refresh needLoading:(BOOL)needLoading{
    __weak typeof(self) weakSelf = self;
    pageIndex = refresh ? 1 : pageIndex + 1;
    if (refresh && needLoading) {
        [MBProgressHUD showMessage:@""];
    }
    if (refresh) {
        [self.searchResultView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].productAPI searchStoreProductWithKeyWorld:keyword
                                                            pageIndex:pageIndex
                                                              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                  [weakSelf.searchResultView.mj_header endRefreshing];
                                                                  [weakSelf.searchResultView.mj_footer endRefreshing];
                                                                  weakSelf.isSearchGoods = NO;
                                                                  NSArray *userArray = [[YZAgentGoodsModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]] mutableCopy];
                                                                  if (refresh) {
                                                                      weakSelf.searchGoodsArray = [userArray mutableCopy];
                                                                  } else {
                                                                      [weakSelf.searchGoodsArray  addObjectsFromArray:userArray];
                                                                  }
                                                                  if (weakSelf.searchGoodsArray.count > 0) {
                                                                      [weakSelf.searchBar resignFirstResponder];
                                                                  }
                                                                  
                                                                  if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.searchGoodsArray.count > 0) {
                                                                      [weakSelf.searchResultView.mj_footer endRefreshingWithNoMoreData];
                                                                  }
                                                                  
                                                                  //                                                              weakSelf.searchResultView.hidden = YES;
                                                                  weakSelf.tabBarController.tabBar.hidden = YES;
                                                                  [weakSelf.searchResultView reloadData];
                                                                  weakSelf.searchBar.showsCancelButton = YES;
                                                              } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                  [MBProgressHUD showMessageAuto:error.msg];
                                                                  [weakSelf.searchResultView.mj_header endRefreshing];
                                                                  [weakSelf.searchResultView.mj_footer endRefreshing];
                                                              }];
}


- (void)changePrice:(YZAgentGoodsModel *)goods {
    self.changeModel = goods;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改价格"
                                                    message:@""
                                                   delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    UITextField *txtName = [alert textFieldAtIndex:0];
    txtName.keyboardType = UIKeyboardTypeDecimalPad;
    txtName.text = [NSString stringWithFormat:@"%ld",(long)[goods.agentPrice integerValue]];
    txtName.placeholder = @"请输入价格";
    txtName.delegate = self;
    [alert show];
}

#pragma mark - 点击代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text isEqualToString:@"0"] && string.length > 0 && ![string isEqualToString:@"."]) {
        textField.text = @"";
    } else if ([textField.text isEqualToString:@""] && [string isEqualToString:@"."]) {
        textField.text = @"0";
    }
    
    if ([textField.text containsString:@"."] &&
        string.length > 0 &&
        (([textField.text rangeOfString:@"."].location == (textField.text.length - 2)) || [string isEqualToString:@"."])) {
        return NO;
    }
    return YES;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *txt = [alertView textFieldAtIndex:0];
        //        ／／获取txt内容即可
        __weak typeof(self) weakSelf = self;
        [[YZNCNetAPI sharedAPI].userAPI changeSalePriceWithProductId:self.changeModel.productId
                                                          agentPrice:txt.text
                                                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                                 [MBProgressHUD showSuccess:@"修改成功"];
                                                                 weakSelf.changeModel.agentPrice = [NSNumber numberWithFloat:[txt.text floatValue]];
                                                                 [weakSelf.tableView reloadData];
                                                                 [weakSelf.searchResultView reloadData];
                                                             } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                                 [MBProgressHUD showSuccess:error.msg];
                                                             }];
    }
}

- (void)changeShopName:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI updateStoreInfoWithShopName:name
                                                      shopImage:nil imageName:nil
                                                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                            [MBProgressHUD hideHUD];
                                                            weakSelf.shopInfo.shopName = name;
                                                            [weakSelf.tableView reloadData];
                                                        } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                            [MBProgressHUD hideHUD];
                                                            [MBProgressHUD showError:error.msg];
                                                        }];
}

- (void)changeShopIcon {
    ZLPhotoActionSheet *ac = [[ZLPhotoActionSheet alloc] init];
    
    //相册参数配置，configuration有默认值，可直接使用并对其属性进行修改
    ac.configuration.maxSelectCount = 1;
    ac.configuration.maxPreviewCount = 0;
    
    //如调用的方法无sender参数，则该参数必传
    ac.sender = self;
    
    //选择回调
    __weak typeof(self) weakSelf = self;
    [ac setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        [weakSelf updateUserAvart:[images firstObject]];
    }];
    
    //调用相册
    [ac showPreviewAnimated:YES];
}

- (void)updateUserAvart:(UIImage *)image {
    if (image) {
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showMessage:@""];
        NSData *data = UIImageJPEGRepresentation(image, 0.5f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        [[YZNCNetAPI sharedAPI].userAPI updateStoreInfoWithShopName:nil shopImage:encodedImageStr imageName:@"shopName" success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUD];
            if ([responseObject isKindOfClass:[NSString class]]) {
                [MBProgressHUD showSuccess:@"修改成功"];
                weakSelf.shopInfo.shopImage = responseObject;
                [weakSelf.tableView reloadData];
            }
        } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:error.msg];
        }];
    }
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (tableView.tag == kSearchResultViewTag ? 1 : 2);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == kSearchResultViewTag) {
        return self.isSearchGoods ? self.searchResult.count :self.searchGoodsArray.count;
    }
    if (section == 0) {
        return 1;
    }
    return self.array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kSearchResultViewTag) {
        if (self.isSearchGoods) {
            return [YZGoodsSearchTableCell yz_heightForCellWithModel:[self.searchResult yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
        }
        return [NZStoreItemCell yz_heightForCellWithModel:[self.searchGoodsArray yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
    }
    if (indexPath.section == 0) {
        return [NZStoreHeaerCell yz_heightForCellWithModel:[YZUserCenter shared].accountInfo contentWidth:kScreenWidth];
    }
    return [NZStoreItemCell yz_heightForCellWithModel:[self.array yz_objectAtIndex:indexPath.row] contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == kSearchResultViewTag) {
        if (self.isSearchGoods) {
            YZGoodsSearchTableCell *cell = (YZGoodsSearchTableCell *)[YZGoodsSearchTableCell yz_createCellForTableView:tableView];
//            [tableView dequeueReusableCellWithIdentifier:kNZGoodsSearchCellIdentifiler];
            [cell yz_configWithModel:[[self.searchResult yz_objectAtIndex:indexPath.row] yz_stringForKey:@"keyword"]];
            return cell;
        }
        NZStoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kNZStoreItemCellIdentifiler];
        [cell yz_configWithModel:[self.searchGoodsArray yz_objectAtIndex:indexPath.row]];
        __weak typeof(self) weakSelf = self;
        cell.changePriceBlock = ^(YZAgentGoodsModel *goods) {
            [weakSelf changePrice:goods];
        };
        return cell;
    }
    
    if (indexPath.section == 0) {
        NZStoreHeaerCell *cell = [tableView dequeueReusableCellWithIdentifier:kNZStoreHeaerCellIdentifiler];
        [cell yz_configWithModel:self.shopInfo];
        __weak typeof(self) weakSelf = self;
        cell.changeShopNameBlock = ^(NSString *name) {
            [weakSelf changeShopName:name];
        };
        cell.changeShopIconBlock = ^{
            [weakSelf changeShopIcon];
        };
        return cell;
    }
    NZStoreItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kNZStoreItemCellIdentifiler];
    [cell yz_configWithModel:[self.array yz_objectAtIndex:indexPath.row]];
    __weak typeof(self) weakSelf = self;
    cell.changePriceBlock = ^(YZAgentGoodsModel *goods) {
        [weakSelf changePrice:goods];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == kSearchResultViewTag && self.isSearchGoods) {
        id model = [self.searchResult yz_objectAtIndex:indexPath.row];
        if ([model isKindOfClass:[NSDictionary class]]) {
            self.searchBar.text = [model yz_stringForKey:@"keyword"];
            [self searchGoods:[model yz_stringForKey:@"keyword"] refresh:YES needLoading:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    YZAgentGoodsModel *model = [self.array yz_objectAtIndex:indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              [weakSelf deleteAccountLog:model];
                                                                          }];
    return @[deleteAction];
}

//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_shoppingcar_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀，商品竟然是空的！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.searchBar.text.length > 0 || self.isSearchGoods ? -120 : 0;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return !self.isSearchGoods;
}

//jump
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //    if ([segue.identifier isEqualToString:@"buynowVC"]) {
    //        NZBuyNowViewController *vc = segue.destinationViewController;
    //        vc.productArray = sender;
    //    }
}

#pragma mark - property
- (NSMutableArray *)array {
    if (!_array) {
        NSMutableArray *marray = [NSMutableArray array];
        _array = marray;
    }
    return _array;
}

//- (UIView *)headerView {
//    if (!_headerView) {
//        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35+60)];
//        _headerView.backgroundColor = [UIColor colorWithHex:0x000000];
//
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//        title.text = @"总账户（金币）";
//        title.textAlignment = NSTextAlignmentCenter;
//        title.textColor = [UIColor colorWithHex:0x999999];
//        title.font = [UIFont systemFontOfSize:14];
//        [_headerView addSubview:title];
//
//        UILabel *priceLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 50)];
//        priceLb.textAlignment = NSTextAlignmentCenter;
//        priceLb.textColor = [UIColor whiteColor];
//        priceLb.font = [UIFont systemFontOfSize:36];
//        priceLb.text = [NZUserCenter shared].accountInfo.balance;
//        [_headerView addSubview:priceLb];
//    }
//    return _headerView;
//}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offset = scrollView.contentOffset;
    
    if (offset.y < 0) {
        CGRect rect = self.headerBgView.frame;
        rect.origin.y = offset.y;
        rect.size.height = - offset.y;
        self.headerBgView.frame = rect;   // 下拉背景view
    } else if (offset.y > 54) {
        //        self.title = @"liu"
    }
}

- (UIImageView *)headerBgView {
    if (!_headerBgView) {
        _headerBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _headerBgView.contentMode = UIViewContentModeScaleToFill;
        [_headerBgView setBackgroundColor:[UIColor colorWithHex:0x000000]];
    }
    return _headerBgView;
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

- (UITableView *)searchResultView {
    if (!_searchResultView) {
        _searchResultView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _searchResultView.delegate = self;
        _searchResultView.dataSource = self;
        _searchResultView.hidden = YES;
        __weak typeof(self) weakSelf = self;
        _searchResultView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
            [weakSelf searchGoods:weakSelf.searchBar.text refresh:YES needLoading:(weakSelf.searchGoodsArray.count == 0)];
        }];
        _searchResultView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf searchGoods:weakSelf.searchBar.text refresh:NO needLoading:NO];
        }];
    }
    return _searchResultView;
}


@end
