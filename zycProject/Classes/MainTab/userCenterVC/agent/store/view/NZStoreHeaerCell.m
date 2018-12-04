//
//  NZStoreHeaerCell.m
//  nzGreens
//
//  Created by yc on 2018/5/27.
//  Copyright © 2018年 wyyincheng. All rights reserved.
//

#import "NZStoreHeaerCell.h"
#import "YZUserModel.h"

@interface NZStoreHeaerCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *storeIconView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *editIcon;
@property (weak, nonatomic) IBOutlet UITextField *editTF;

@end

@implementation NZStoreHeaerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editTF.hidden = YES;
    self.editTF.delegate = self;
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(changeIconAction)];
    [self.storeIconView addGestureRecognizer:tapGest];
    self.storeIconView.userInteractionEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)yz_heightForCellWithModel:(id)model contentWidth:(CGFloat)width {
    return 120;
}

- (void)yz_configWithModel:(id)model {
    if ([model isKindOfClass:[YZShopInfoModel class]]) {
        YZShopInfoModel *shopInfo = model;
        [self.storeIconView sd_setImageWithURL:[NSURL URLWithString:shopInfo.shopImage]
                              placeholderImage:[UIImage imageNamed:@"icon_store_avart"]];
        self.storeNameLb.text = shopInfo.shopName;
    }
}

- (IBAction)editAction:(id)sender {
    if (self.editTF.text.length == 0) {
        self.editTF.text = self.storeNameLb.text;
    }
    self.editTF.hidden = NO;
    self.editIcon.hidden = YES;
    self.storeNameLb.hidden = YES;
    [self.editTF becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.editTF.hidden = YES;
    self.editIcon.hidden = NO;
    self.storeNameLb.hidden = NO;
    self.storeNameLb.text = self.editTF.text;
    [self.editTF resignFirstResponder];
    if (self.changeShopNameBlock) {
        self.changeShopNameBlock(self.storeNameLb.text);
    }
}

- (void)changeIconAction {
    if (self.changeShopIconBlock) {
        self.changeShopIconBlock();
    }
}

@end
