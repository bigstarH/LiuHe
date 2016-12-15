//
//  CollectionWebViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "CollectionWebViewController.h"
#import "MBProgressHUD+Extension.h"
#import "ShareManager.h"
#import "ShareMenu.h"

@interface CollectionWebViewController () <WKNavigationDelegate, UIWebViewDelegate, ShareMenuDelegate>

@property (nonatomic, copy) NSString *linkStr;

@property (nonatomic, weak) MBProgressHUD *hud;

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
    if (IOS_8_LATER) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, webViewH)];
        webView.navigationDelegate = self;
        [webView sizeToFit];
        [self.view addSubview:webView];
    
        MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:@"正在加载中..." removeOnHide:YES];
        self.hud           = hud;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_linkStr]];
        [webView loadRequest:request];
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, webViewH)];
        webView.delegate   = self;
        [webView setScalesPageToFit:YES];
        [webView sizeToFit];
        [self.view addSubview:webView];
        
        // 加载网页
        MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:@"正在加载中..." removeOnHide:YES];
        self.hud           = hud;
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
            [ShareManager weChatShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeWechatTimeLine:  // 朋友圈
            [ShareManager weChatTimeLineShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQQ:  // QQ
            [ShareManager QQShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQZone:  // QQ空间
            [ShareManager QZoneWithCurrentVC:self success:nil failure:nil];
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
    [self.hud hideAnimated:YES];
    self.hud = nil;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    [self.hud hideAnimated:YES];
    self.hud = nil;
    [MBProgressHUD showFailureInView:self.view mesg:@"網絡不是很好哦，請檢查您的網絡"];
}
#pragma mark end WKNavigationDelegate

#pragma mark - start UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.hud hideAnimated:YES];
    self.hud = nil;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.hud hideAnimated:YES];
    self.hud = nil;
    [MBProgressHUD showFailureInView:self.view mesg:@"網絡不是很好哦，請檢查您的網絡"];
}
#pragma mark end UIWebViewDelegate
@end
