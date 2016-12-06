//
//  VideoLotteryViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <WebKit/WebKit.h>
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "VideoLotteryViewController.h"
#import "HistoryViewController.h"
#import "XQFasciatePageControl.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "ShareManager.h"
#import "LotteryView.h"
#import "AdvertModel.h"
#import "ShareMenu.h"

@interface VideoLotteryViewController () <XQCycleImageViewDelegate, ShareMenuDelegate, WKNavigationDelegate, UIWebViewDelegate>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;
/** 开奖结果视图 */
@property (nonatomic, weak) UIView *resultView;

@end

@implementation VideoLotteryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"視頻開獎";
    // 创建广告轮播
    [self createCycleImageView];
    // 创建WebView
    [self createWebView];
    
    // 获得广告轮播图
    [self getAdvertisementPic];
    // 获取开奖号码
    [self getLotteryNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.cycleImageView startPlayImageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.cycleImageView stopPlayImageView];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
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
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
/** 创建广告轮播 */
- (void)createCycleImageView
{
    CGFloat cycleH = SCREEN_WIDTH * 200 / 1100;
    XQCycleImageView *cycleImage = [XQCycleImageView cycleImageView];
    cycleImage.frame             = CGRectMake(0, 65, SCREEN_WIDTH, cycleH);
    cycleImage.backgroundColor   = RGBCOLOR(245, 245, 245);
    cycleImage.delegate          = self;
    cycleImage.repeatSecond      = 5;
    cycleImage.autoDragging      = YES;
    self.cycleImageView          = cycleImage;
    [self.view addSubview:cycleImage];
    
    CGFloat resultVY = CGRectGetMaxY(cycleImage.frame) + HEIGHT(2);
    CGFloat resultVX = WIDTH(6);
    CGFloat resultVH = HEIGHT(120);
    CGFloat resultVW = SCREEN_WIDTH - resultVX * 2;
    UIView *resultV  = [[UIView alloc] initWithFrame:CGRectMake(resultVX, resultVY, resultVW, resultVH)];
    self.resultView  = resultV;
    [resultV setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [resultV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goLotteryHistory)]];
    [self.view addSubview:resultV];
}

- (void)createWebView
{
    CGFloat webViewY = CGRectGetMaxY(self.resultView.frame) + HEIGHT(2);
    CGFloat webViewH = SCREEN_HEIGHT - webViewY;
    CGRect frame     = CGRectMake(0, webViewY, SCREEN_WIDTH, webViewH);
    if (IOS_8_LATER) {  // iOS 8及之后的版本
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame];
        [webView setNavigationDelegate:self];
        [webView sizeToFit];
        [self.view addSubview:webView];
        
        // 添加下拉刷新功能
        __weak WKWebView *wb = webView;
        webView.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            // 加载网页
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:LOTTERY_KJ_URL]];
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
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:LOTTERY_KJ_URL]];
            [wb loadRequest:request];
        }];
        [webView.scrollView.mj_header beginRefreshing];
    }
}

/** 创建开奖视图 */
- (void)createLotteryViewWithModel:(LotteryNumberModel *)model
{
    CGFloat originY = 0;
    CGFloat height  = HEIGHT(30);
    CGFloat width   = CGRectGetWidth(self.resultView.frame);
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, width, height)];
    label.font      = [UIFont systemFontOfSize:fontSize(16)];
    label.text      = [NSString stringWithFormat:@"第%@期開獎結果", model.bq];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.resultView addSubview:label];
    
    originY     += height;
    height       = HEIGHT(62);
    CGRect frame = CGRectMake(0, originY, width, height);
    LotteryView *lotteryView = [[LotteryView alloc] initWithFrame:frame];
    lotteryView.model        = model;
    [self.resultView addSubview:lotteryView];
    
    originY     += height;
    height       = CGRectGetHeight(self.resultView.frame) - originY;
    label        = [[UILabel alloc] initWithFrame:CGRectMake(0, originY, width, height)];
    label.font   = [UIFont systemFontOfSize:fontSize(14)];
    label.text   = [NSString stringWithFormat:@"第%@期開獎時間：%@ 星期%@", model.xyq, model.xyqsj, model.xq];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.resultView addSubview:label];
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

/** 进入“历史记录” */
- (void)goLotteryHistory
{
    HistoryViewController *vc = [[HistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end 初始化控件

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
/** 页面加载完成之后调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
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
    __weak typeof(self) ws    = self;
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

/** 获取开奖号码 */
- (void)getLotteryNumber
{
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] lotteryStartWithSuccess:^(NSDictionary *dict) {
        LotteryNumberModel *model = [LotteryNumberModel lotteryNumberWithDict:dict];
        [ws createLotteryViewWithModel:model];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark - start 网络请求
@end
