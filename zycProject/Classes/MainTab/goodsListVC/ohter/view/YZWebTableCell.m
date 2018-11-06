//
//  YZWebTableCell.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZWebTableCell.h"

@implementation YZWebTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSLog(@"%@",NSStringFromCGRect(self.contentView.bounds));
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 2)];
        
        // 高度必须提前赋一个值 >0
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 1)];
        self.webView.backgroundColor = [UIColor clearColor];
        self.webView.opaque = NO;
        self.webView.userInteractionEnabled = NO;
        self.webView.scrollView.bounces = NO;
        self.webView.delegate = self;
        self.webView.paginationBreakingMode = UIWebPaginationBreakingModePage;
        self.webView.scalesPageToFit = YES;
        
        [view addSubview:self.webView];
        
        [self.contentView addSubview:view];
    }
    return self;
}

// contentStr 用于更新值
-(void)setContentStr:(NSString *)contentStr
{
    return;
    if ([contentStr isEqualToString:_contentStr]) {
        return;
    }
    _contentStr = contentStr;
    
    //    [self.webView loadHTMLString:contentStr baseURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentStr]]];
    //        [self.detailView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.goodsModel.detail]]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // 如果要获取web高度必须在网页加载完成之后获取
    
    // 方法一
    CGSize fittingSize = [self.webView sizeThatFits:CGSizeZero];
    
    // 方法二
    //    CGSize fittingSize = webView.scrollView.contentSize;
    NSLog(@"webView:%@",NSStringFromCGSize(fittingSize));
    self.height = fittingSize.height;
    
    self.webView.frame = CGRectMake(0, 0, fittingSize.width, fittingSize.height);
    
    self.height = fittingSize.height;
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:nil];
}

@end
