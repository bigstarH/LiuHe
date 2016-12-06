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
#import "ShareManager.h"
#import "ShareMenu.h"

@interface CollectionWebViewController () <WKNavigationDelegate, UIWebViewDelegate, ShareMenuDelegate>

@property (nonatomic, copy) NSString *linkStr;

@end

@implementation CollectionWebViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

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
    if (IOS_8_LATER) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, webViewH)];
        webView.navigationDelegate = self;
        [webView sizeToFit];
        [self.view addSubview:webView];
        
        [SVProgressHUD showWithStatus:@"正在加载中..."];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkStr]];
        [webView loadRequest:request];
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, webViewH)];
        webView.delegate   = self;
        [webView setScalesPageToFit:YES];
        [webView sizeToFit];
        [self.view addSubview:webView];
        
        // 加载网页
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkStr]];
        [webView loadRequest:request];
    }
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
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}

#pragma mark - start ShareMenuDelegate
/** 分享事件 */
- (void)shareMenu:(ShareMenu *)shareMenu didSelectMenuItemWithType:(ShareMenuItemType)type
{
    switch (type) {
        case ShareMenuItemTypeWeChat:  // 微信
        {
            NSLog(@"微信");
            [ShareManager weChatShareWithImageUrl:@"http://img1.shenchuang.com/2016/1125/1480067250934.jpg" currentVC:self success:nil failure:nil];
            break;
        }
        case ShareMenuItemTypeWechatTimeLine:  // 朋友圈
        {
            NSLog(@"朋友圈");
            [ShareManager weChatTimeLineShareWithImageUrl:@"http://img1.shenchuang.com/2016/1125/1480067250934.jpg" currentVC:self success:^(NSString *result) {
                NSLog(@"result = %@", result);
            } failure:^(NSString *error) {
                NSLog(@"error = %@", error);
            }];
            break;
        }
        case ShareMenuItemTypeQQ:  // QQ
            NSLog(@"QQ");
            break;
        case ShareMenuItemTypeQZone:  // QQ空间
            NSLog(@"QQ空间");
            break;
        default:
            break;
    }
}
#pragma mark end ShareMenuDelegate

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

#pragma mark - start UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"網絡不是很好哦，請檢查您的網絡"];
}
#pragma mark end UIWebViewDelegate
@end
