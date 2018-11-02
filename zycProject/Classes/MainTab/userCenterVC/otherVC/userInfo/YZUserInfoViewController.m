//
//  YZUserInfoViewController.m
//  zycProject
//
//  Created by yc on 2018/11/2.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZUserInfoViewController.h"

#import "ZLPhotoActionSheet.h"
#import "YZUserInfoTableCell.h"
#import "YZUserAvartTableCell.h"
#import "YZChangeNameViewController.h"

@interface YZUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *iconArray;

@end

@implementation YZUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
}

- (void)initViews {
    
    self.tableView.backgroundColor = kYZBackViewColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZUserInfoTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZUserInfoTableCell yz_cellIdentifiler]];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YZUserAvartTableCell class])
                                               bundle:nil]
         forCellReuseIdentifier:[YZUserAvartTableCell yz_cellIdentifiler]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)updateUserAvart:(UIImage *)image {
    if (image) {
        __weak typeof(self) weakSelf = self;
        [MBProgressHUD showMessage:@""];
        NSData *data = UIImageJPEGRepresentation(image, 0.5f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        [[YZNCNetAPI sharedAPI].userAPI updateUserInfoWithAvart:encodedImageStr
                                                      avartName:@"userAvartIcon"
                                                       nickName:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                           [MBProgressHUD showSuccess:@"修改成功"];
                                                           if ([responseObject isKindOfClass:[NSString class]]) {
                                                               [YZUserCenter shared].accountInfo.avatar = responseObject;
                                                               [weakSelf.tableView reloadData];
                                                           }
                                                       } Failure:^(NSURLSessionDataTask * _Nullable task, NZError * _Nonnull error) {
                                                           [MBProgressHUD showError:error.msg];
                                                       }];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 47;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YZAccountModel *user = [YZUserCenter shared].accountInfo;
    if (indexPath.section == 0) {
        YZUserAvartTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[YZUserAvartTableCell yz_cellIdentifiler]];
        [cell yz_configWithModel:user];
        return cell;
    } else {
        YZUserInfoTableCell *cell = [tableView  dequeueReusableCellWithIdentifier:[YZUserInfoTableCell yz_cellIdentifiler]];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                [dict setValue:@"昵称" forKey:@"title"];
                [dict setValue:user.nickname forKey:@"info"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                [dict setValue:@"ID" forKey:@"title"];
                [dict setValue:user.userId forKey:@"info"];
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        } else {
            [dict setValue:@"账号" forKey:@"title"];
            [dict setValue:user.telephone forKey:@"info"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [cell yz_configWithModel:dict];
        
        return cell;
    }
    return [UITableViewCell new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
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
            
            //            //预览网络图片
            //            [ac previewPhotos:self.iconArray index:0 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            //                //your codes
            //            }];
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                NSString *nickName = [YZUserCenter shared].accountInfo.nickname;
                [self gotoViewController:NSStringFromClass([YZChangeNameViewController class])
                             lauchParams:@{kYZLauchParams_NickName:nickName}];
            }
        }
            break;
        default:
            break;
    }
}

@end
