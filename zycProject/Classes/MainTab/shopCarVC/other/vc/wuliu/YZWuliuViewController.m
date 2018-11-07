//
//  YZWuliuViewController.m
//  zycProject
//
//  Created by yc on 2018/11/7.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZWuliuViewController.h"

#import "YZWuliuTableCell.h"
#import "YZWuliuInfoTableCell.h"

@interface YZWuliuViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *iconUrlsArray;

@end

@implementation YZWuliuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZWuliuTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZWuliuTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZWuliuInfoTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZWuliuInfoTableCell yz_cellIdentifiler]];
    
    //    self.tableView.estimatedRowHeight = 1;
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    __weak typeof(self) weakSelf = self;
    [MBProgressHUD showMessage:@""];
    [[YZNCNetAPI sharedAPI].orderAPI getDeliveInfoWithOrderNumber:self.orderNumber
                                                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                              if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                                                  weakSelf.logisticsNumber = [responseObject yz_stringForKey:@"logisticsNumber"];
                                                                  weakSelf.logisticsCompany = [responseObject yz_stringForKey:@"logisticsCompany"];
                                                                  [weakSelf downLoadIcons:[responseObject yz_arrayForKey:@"imageList"]];            [weakSelf.tableView reloadData];
                                                              }
                                                          } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                              [MBProgressHUD showError:error.msg];
                                                          }];
}

- (void)downLoadIcons:(NSArray *)icons {
    //    self.imageArray = [icons mutableCopy];
    for (NSString *imageUrl in icons) {
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        [mDict setValue:imageUrl forKey:@"iconUrlStr"];
        if (mDict) {
            [self.iconUrlsArray addObject:mDict];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 && (self.logisticsCompany.length + self.logisticsNumber.length == 0)) {
        return 0;
    }
    return 8.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0 && (self.logisticsCompany.length + self.logisticsNumber.length == 0)) {
        return nil;
    }
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithHex:0xF4F4F4];
    return footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.iconUrlsArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        [mdict setValue:self.logisticsNumber forKey:@"logisticsNumber"];
        [mdict setValue:self.logisticsCompany forKey:@"logisticsCompany"];
        return [YZWuliuInfoTableCell yz_heightForCellWithModel:mdict contentWidth:kScreenWidth];
    }
    return [YZWuliuTableCell yz_heightForCellWithModel:[self.iconUrlsArray yz_dictAtIndex:(indexPath.section -1)] contentWidth:kScreenWidth];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        YZWuliuInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZWuliuInfoTableCell yz_cellIdentifiler]];
        NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
        [mdict setValue:self.logisticsNumber forKey:@"logisticsNumber"];
        [mdict setValue:self.logisticsCompany forKey:@"logisticsCompany"];
        [cell yz_configWithModel:mdict];
        return cell;
    }
    
    YZWuliuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZWuliuTableCell yz_cellIdentifiler]];
    __weak typeof(self) weakSelf = self;
    cell.refreshIconBlock = ^(NSString *url, CGFloat width, CGFloat height) {
        [weakSelf dealWithUrl:url width:width height:height];
    };
    [cell yz_configWithModel:[self.iconUrlsArray yz_dictAtIndex:(indexPath.section - 1)]];
    return cell;
}

- (void)dealWithUrl:(NSString *)url width:(CGFloat)width height:(CGFloat)height {
    if (!url) {
        return;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.iconUrlsArray];
    NSInteger index = 0;
    for (NSDictionary *dict in temp) {
        if ([[dict yz_stringForKey:@"iconUrlStr"] isEqualToString:url]) {
            NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mdict setValue:@(kScreenWidth) forKey:@"width"];
            [mdict setValue:@(width > 0 ? kScreenWidth * height / width : kScreenWidth * 184 /320) forKey:@"height"];
            
            [self.iconUrlsArray replaceObjectAtIndex:index withObject:mdict];
        }
        index ++;
    }
    [self.tableView reloadData];
}

//- (NSMutableArray *)imageArray {
//    if (!_imageArray) {
//        _imageArray = [NSMutableArray array];
//    }
//    return _imageArray;
//}

- (NSMutableArray *)iconUrlsArray {
    if (!_iconUrlsArray) {
        _iconUrlsArray = [NSMutableArray array];
    }
    return _iconUrlsArray;
}

@end
