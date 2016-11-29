//
//  CollectionWebViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CollectionWebViewController.h"

@interface CollectionWebViewController () <WKNavigationDelegate>

@property (nonatomic, copy) NSString *linkStr;

@end

@implementation CollectionWebViewController

- (instancetype)initWithLinkStr:(NSString *)linkStr
{
    if (self = [super init]) {
        self.linkStr = linkStr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat webViewH   = SCREEN_HEIGHT - 64;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, webViewH)];
    webView.navigationDelegate = self;
    [webView sizeToFit];
    [self.view addSubview:webView];
    
    [SVProgressHUD showWithStatus:@"正在加载中..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkStr]];
    [webView loadRequest:request];
}

- (void)setNavigationBarStyle
{
    self.title = self.titleStr;
    
    XQBarButtonItem *leftBtn  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftBtn;
    self.navigationBar.rightBarButtonItem = shareBtn;
}

- (void)shareEvent
{
    NSLog(@"分享");
}

#pragma mark - start WKNavigationDelegate
/** 页面加载完成之后调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"網絡不是很好哦，請檢查您的網絡"];
}
#pragma mark end WKNavigationDelegate

@end
