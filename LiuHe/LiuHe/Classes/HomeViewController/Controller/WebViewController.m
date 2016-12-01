//
//  WebViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "XQFasciatePageControl.h"
#import "WebViewController.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "AdvertModel.h"

@interface WebViewController ()<XQCycleImageViewDelegate, WKNavigationDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@property (nonatomic) BOOL refreshing;

@property (nonatomic, copy) NSString *requestUrl;

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建广告轮播
    [self createCycleImageView];
    // 创建WebView
    [self createWebView];
    
    // 获得广告轮播图
    [self getAdvertisementPic];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title      = self.type == WebVCTypeTrendAnalyze ? @"走勢分析" : @"開獎日期";
    self.requestUrl = self.type == WebVCTypeTrendAnalyze ? TREND_ANALYZE_URL : DATE_LOTTERY_URL;
    
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = shareBtn;
    self.navigationBar.leftBarButtonItem  = leftItem;
}

/** 按钮分享事件 */
- (void)shareEvent
{
    NSLog(@"分享");
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
/** 创建图片轮播 */
- (void)createCycleImageView
{
    CGFloat cycleH = SCREEN_WIDTH * 200 / 1100;
    XQCycleImageView *cycleImage = [XQCycleImageView cycleImageView];
    cycleImage.frame             = CGRectMake(0, 64, SCREEN_WIDTH, cycleH);
    cycleImage.backgroundColor   = RGBCOLOR(245, 245, 245);
    cycleImage.delegate          = self;
    cycleImage.repeatSecond      = 5;
    cycleImage.autoDragging      = YES;
    self.cycleImageView          = cycleImage;
    [self.view addSubview:cycleImage];
}

/** 设置轮播数据 */
- (void)setCycleImageData
{
    NSMutableArray *array = [NSMutableArray array];
    for (AdvertModel *model in self.imageArr) {
        [array addObject:model.titlepic];
    }
    self.cycleImageView.images = array;
    
    if (array.count <= 1) return;
    
    CGFloat pageY      = CGRectGetMaxY(self.cycleImageView.frame) - HEIGHT(25);
    XQFasciatePageControl *page  = [XQFasciatePageControl pageControl];
    page.frame         = CGRectMake(0, pageY, SCREEN_WIDTH, HEIGHT(25));
    page.numberOfPages = array.count;
    self.pageControl   = page;
    [page setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [page setPageIndicatorTintColor:[UIColor whiteColor]];
    [page setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [self.view addSubview:page];
}

- (void)createWebView
{
    __weak typeof(self) ws = self;
    CGFloat webViewY = CGRectGetMaxY(self.cycleImageView.frame) + HEIGHT(2);
    CGFloat webViewH = SCREEN_HEIGHT - webViewY;
    CGRect frame     = CGRectMake(0, webViewY, SCREEN_WIDTH, webViewH);
    if (IOS_8_LATER) {  // iOS 8及之后的版本
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
        [webView setNavigationDelegate:self];
        [webView sizeToFit];
        [self.view addSubview:webView];
        
        // 添加下拉刷新功能
        __weak WKWebView *wb   = webView;
        webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 加载网页
            ws.refreshing = YES;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ws.requestUrl]];
            [wb loadRequest:request];
        }];
        [webView.scrollView.mj_header beginRefreshing];
    }else {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate   = self;
        [webView setScalesPageToFit:YES];
        [webView sizeToFit];
        [self.view addSubview:webView];
        
        // 添加下拉刷新功能
        __weak UIWebView *wb = webView;
        webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 加载网页
            ws.refreshing = YES;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:ws.requestUrl]];
            [wb loadRequest:request];
        }];
        [webView.scrollView.mj_header beginRefreshing];
    }
}
#pragma mark end 初始化控件

#pragma mark - start XQCycleImageViewDelegate
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index
{
    AdvertModel *model = self.imageArr[index];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.linkStr]];
}

- (void)cycleImageViewDidScrollingAnimation:(XQCycleImageView *)cycleImageView atIndex:(int)index
{
    self.pageControl.currentPage = index;
}
#pragma mark end XQCycleImageViewDelegate

#pragma mark - start WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    if (self.refreshing) {
        self.refreshing = NO;
        return;
    }
    [SVProgressHUD show];
}
/** 页面加载完成之后调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [SVProgressHUD dismiss];
    [webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error
{
    [webView.scrollView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:@"網絡不是很好哦，請檢查您的網絡"];
}
#pragma mark end WKNavigationDelegate

#pragma mark - start UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [webView.scrollView.mj_header endRefreshing];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [webView.scrollView.mj_header endRefreshing];
    [SVProgressHUD showErrorWithStatus:@"網絡不是很好哦，請檢查您的網絡"];
}
#pragma mark end UIWebViewDelegate

#pragma mark - start 网络请求
/** 获取广告轮播图 */
- (void)getAdvertisementPic
{
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] getADWithURL:GET_INDEXAD_AD_URL
                                        success:^(NSArray *imagesArray) {
                                            NSMutableArray *images = [NSMutableArray array];
                                            for (int i = 0; i < imagesArray.count; i++) {
                                                NSDictionary *dict = imagesArray[i];
                                                AdvertModel *model = [AdvertModel advertModelWithDict:dict];
                                                [images addObject:model];
                                            }
                                            ws.imageArr = images;
                                            [ws setCycleImageData];
                                            [ws.cycleImageView startPlayImageView];
                                        } failure:^(NSString *error) {
                                            [SVProgressHUD showErrorWithStatus:error];
                                        }];
}
#pragma mark end 网络请求
@end
