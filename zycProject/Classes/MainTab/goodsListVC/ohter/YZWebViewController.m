
//
//  YZWebViewController.m
//  zycProject
//
//  Created by yc on 2018/11/6.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZWebViewController.h"

@interface YZWebViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation YZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.mas_equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.webView loadHTMLString:@"<p>这是一个段落</p>" baseURL:nil];
}

#pragma mark - property
- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
    }
    return _webView;
}

@end
