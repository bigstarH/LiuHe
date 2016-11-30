//
//  HistoryDetailViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/30.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "HistoryDetailViewController.h"
#import "XQFasciatePageControl.h"
#import "LotteryNumberModel.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "LotteryView.h"
#import "AdvertModel.h"

@interface HistoryDetailViewController () <XQCycleImageViewDelegate>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@end

@implementation HistoryDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建广告轮播
    [self createCycleImageView];
    // 创建详情View
    [self createDetailView];
    
    // 获得广告轮播图
    [self getAdvertisementPic];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"當期詳情";
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

/** 创建详情View */
- (void)createDetailView
{
    NSString *dateStr = [SystemManager dateStringWithTime:[_model.newstime doubleValue]
                                                formatter:@"yyyy.MM.dd"];
    CGFloat titleVY   = CGRectGetMaxY(self.cycleImageView.frame) + HEIGHT(3);
    CGFloat titleVH   = HEIGHT(90);
    CGFloat titleVX   = WIDTH(6);
    CGFloat titleVW   = SCREEN_WIDTH - titleVX * 2;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(titleVX, titleVY, titleVW, titleVH)];
    [titleView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.view addSubview:titleView];
    
    CGFloat titleLabH = HEIGHT(28);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, titleVW, titleLabH)];
    titleLab.text     = [NSString stringWithFormat:@"%@期  %@", _model.bq, dateStr];
    titleLab.font     = [UIFont boldSystemFontOfSize:fontSize(16)];
    [titleLab setTextAlignment:NSTextAlignmentCenter];
    [titleView addSubview:titleLab];
    
    CGFloat lotViewY  = titleLabH;
    CGFloat lotViewH  = titleVH - lotViewY;
    LotteryView *lotView = [[LotteryView alloc] initWithFrame:CGRectMake(0, lotViewY, titleVW, lotViewH)];
    lotView.model     = _model;
    [titleView addSubview:lotView];
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
