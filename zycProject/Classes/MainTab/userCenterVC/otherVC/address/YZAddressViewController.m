//
//  YZAddressViewController.m
//  zycProject
//
//  Created by yc on 2018/11/3.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAddressViewController.h"

#import "YZAddressTableCell.h"
#import "YZAddressAddViewController.h"

@interface YZAddressViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate> {
    NSInteger pageIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressBt;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomGap;

@property (nonatomic, assign) BOOL needRefresh;

@end

@implementation YZAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.needRefresh) {
        [self refreshAddress:YES];
        self.needRefresh = NO;
    }
}

- (void)initViews {
    
    self.title = @"选择收货地址";
    
    self.bottomGap.constant = kSafeAreaBottomHeight + 50;
    
    self.addAddressBt.layer.masksToBounds = YES;
    self.addAddressBt.layer.cornerRadius = 25;
    
    self.tableView.backgroundColor = kYZBackViewColor;
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf refreshAddress:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshAddress:NO];
    }];
    
//    self.tableView.emptyDataSetSource = self;
//    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZAddressTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZAddressTableCell yz_cellIdentifiler]];
    
    [self refreshAddress:YES];
}

- (IBAction)addAddressAction:(id)sender {
    self.needRefresh = YES;
    YZ_Weakify(self, weakSelf);
    YZAddressAddViewController *vc = [[YZAddressAddViewController alloc] init];
    vc.refreshAddressBlock = ^{
        weakSelf.needRefresh = YES;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshAddress:(BOOL)isRefresh {
    pageIndex = isRefresh ? 1 : pageIndex + 1;
    __weak typeof(self) weakSelf = self;
    if (isRefresh) {
        [self.tableView.mj_footer resetNoMoreData];
    }
    [[YZNCNetAPI sharedAPI].userAPI getAddressListWithPage:pageIndex
                                                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                       [weakSelf.tableView.mj_header endRefreshing];
                                                       [weakSelf.tableView.mj_footer endRefreshing];
                                                       NSArray *userArray = [YZAddressModel yz_objectArrayWithKeyValuesArray:[responseObject yz_arrayForKey:@"records"]];
                                                       if (isRefresh) {
                                                           weakSelf.addressArray = [userArray mutableCopy];
                                                       } else {
                                                           [weakSelf.addressArray  addObjectsFromArray:userArray];
                                                       }
                                                       if ([responseObject yz_integerForKey:@"hasNext"] == 0 && weakSelf.addressArray.count > 0) {
                                                           [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                                       }
                                                       [weakSelf.tableView reloadData];
                                                   } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                       [weakSelf.tableView.mj_header endRefreshing];
                                                       [weakSelf.tableView.mj_footer endRefreshing];
                                                       [MBProgressHUD showMessageAuto:error.msg];
                                                   }];
}

- (void)confirmDelete:(YZAddressModel *)address {
    __weak typeof(self) weakSelf = self;
    [[YZNCNetAPI sharedAPI].userAPI delAddressWithAddressId:address.addressId
                                                    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                        [MBProgressHUD showSuccess:@"删除成功"];
                                                        [weakSelf.addressArray removeObject:address];
                                                        [weakSelf.tableView reloadData];
                                                    } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                        [MBProgressHUD showMessageAuto:error.msg];
                                                    }];
}

- (void)deleteAddress:(YZAddressModel *)address {
    __weak typeof(self) weakSelf = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要删除此收货地址吗？" preferredStyle:UIAlertControllerStyleAlert];
    //    __weak typeof(self) weakSelf = self;
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf confirmDelete:address];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    return;
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.addressArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self.addressArray yz_objectAtIndex:indexPath.row];
    return [YZAddressTableCell yz_heightForCellWithModel:model
                                            contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZAddressTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZAddressTableCell yz_cellIdentifiler]];
    [cell yz_configWithModel:[self.addressArray yz_objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZAddressModel *addressModel = [self.addressArray yz_objectAtIndex:indexPath.row];
    if (self.needSelectAddress) {
        //        self.addressModel = addressModel;
        //TODO: 确认下哪里用了selectAddressBlock
        self.selectAddressBlock(addressModel);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    YZAddressAddViewController *vc = [[YZAddressAddViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    YZ_Weakify(self, weakSelf);
    vc.refreshAddressBlock = ^{
        weakSelf.needRefresh = YES;
    };
    vc.addressModel = addressModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//empty view
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_address_empty"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"哎呀，你还没有收货地址呢！";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:16.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    return [UIImage imageNamed:@"icon_default_green_color"];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    YZAddressModel *address = [self.addressArray yz_objectAtIndex:indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:@"删除"
                                                                          handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              [weakSelf deleteAddress:address];
                                                                          }];
    return @[deleteAction];
}

#pragma mark - property
- (NSMutableArray *)addressArray {
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

@end
