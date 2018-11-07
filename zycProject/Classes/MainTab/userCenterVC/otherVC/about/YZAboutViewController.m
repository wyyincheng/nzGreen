//
//  YZAboutViewController.m
//  zycProject
//
//  Created by yc on 2018/11/8.
//  Copyright © 2018 yc. All rights reserved.
//

#import "YZAboutViewController.h"

@interface YZAboutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation YZAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.nzgreens.com/about"]]];
    
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
