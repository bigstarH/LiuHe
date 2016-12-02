//
//  HomeViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "VideoLotteryViewController.h"
#import "PicLibraryViewController.h"
#import "TreasureViewController.h"
#import "HistoryViewController.h"
#import "XQFasciatePageControl.h"
#import "HomeViewController.h"
#import "DataViewController.h"
#import "WebViewController.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "AdvertModel.h"
#import "CountDowner.h"
#import "MenuItem.h"

@interface HomeViewController () <XQCycleImageViewDelegate>

@property (nonatomic, weak) UIView *timeView;

@property (nonatomic, weak) UILabel *nextTimeLab;

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@end

@implementation HomeViewController

#pragma mark - start ViewController生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCycleImageView];
    [self createBottomButton];
    
    // 获取广告图片
    [self getAdvertisementPic];
    // 获取下期开奖事件
    [self getLotteryNextTime];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.cycleImageView startPlayImageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.cycleImageView stopPlayImageView];
}
#pragma mark end ViewController生命周期

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = shareBtn;
}

- (UIView *)setTitleView
{
    UILabel *titleLab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLab.text          = @"首頁";
    titleLab.font          = [UIFont boldSystemFontOfSize:18];
    titleLab.textColor     = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    return titleLab;
}

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

/** 创建底部按钮菜单 */
- (void)createBottomButton
{
    __weak typeof(self) ws = self;
    CGFloat hSpace = WIDTH(6);
    CGFloat vSpace = HEIGHT(6);
    
    CGFloat viewY  = CGRectGetMaxY(ws.cycleImageView.frame) + HEIGHT(5);
    CGFloat viewH  = HEIGHT(130) - viewY + 64;
    CGFloat viewW  = SCREEN_WIDTH - hSpace * 2;
    UIView *view   = [[UIView alloc] initWithFrame:CGRectMake(hSpace, viewY, viewW, viewH)];
    self.timeView  = view;
    [view setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.view addSubview:view];
    
    CGFloat labelH = viewH * 0.4;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewW, labelH)];
    label.font     = [UIFont systemFontOfSize:fontSize(14)];
    _nextTimeLab   = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    
    NSArray *array      = @[@"視頻開獎", @"歷史記錄", @"走勢分析", @"開獎日期",
                            @"六合資料", @"六合圖庫", @"六合尋寶", @"六合大全"];
    NSArray *bgColorArr = @[RGBCOLOR(237, 110, 112), RGBCOLOR(194, 153, 194),
                            RGBCOLOR(67, 180, 237) , RGBCOLOR(195, 163, 159), 
                            RGBCOLOR(60, 179, 113) , RGBCOLOR(237, 163, 130),
                            RGBCOLOR(237, 163, 45)];
    
    CGFloat originY   = CGRectGetMaxY(view.frame) + vSpace;
    CGFloat mHeight   = (SCREEN_HEIGHT - originY - 49 - 3 * vSpace) / 3;
    CGFloat itemW     = (SCREEN_WIDTH - 3 * hSpace) * 0.5;
    for (int i = 0; i < 7; i++) {
        CGFloat itemX = hSpace;
        CGFloat itemY = originY;
        CGFloat itemH = (i == 2 || i == 3 || i == 4) ? mHeight + HEIGHT(20) : mHeight - HEIGHT(10);
        if (!(i == 3 || i == 4)){
            itemX = itemX + (i < 3 ? (i % 2) * (hSpace + itemW) : ((i + 1) % 2) * (hSpace + itemW));
        }else {
            itemX = itemX + hSpace + itemW;
        }
        if (i == 3 || i == 4) {
            CGFloat tempH = itemH;
            itemH = (itemH - HEIGHT(6)) * 0.5;
            itemY = (i == 3 ? itemY + vSpace + tempH : itemY + vSpace + tempH + itemH + HEIGHT(6)) - HEIGHT(30);
        }else if (i == 2) {
            itemY = itemY + itemH + vSpace - HEIGHT(30);
        }else {
            itemY = i < 3 ? itemY + (i / 2) * (itemH + vSpace) : itemY + (i - 1) / 2 * (itemH + vSpace) + HEIGHT(30);
        }
        MenuItem *item = [[MenuItem alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        item.tag       = i;
        [item setMenuTitle:array[i] font:[UIFont systemFontOfSize:fontSize(14)]];
        [item.label setTextColor:[UIColor whiteColor]];
        [item setMenuImage:[UIImage imageNamed:array[i]]];
        [item setMenuClickBlock:^(NSInteger tag) {
            [ws menuItemDidClickWithTag:tag];
        }];
        [self setMenuTitleAndImageFrame:item];
        [item setBackgroundColor:bgColorArr[i]];
        [self.view addSubview:item];
    }
}

/** 创建倒计时 */
- (void)createCountDownerWithTime:(NSTimeInterval)time
{
    CGFloat width      = WIDTH(200);
    CGFloat originX    = (CGRectGetWidth(self.timeView.frame) - width) * 0.5;
    CGFloat originY    = CGRectGetMaxY(self.nextTimeLab.frame);
    CGFloat height     = CGRectGetHeight(self.timeView.frame) - originY;
    NSDate *date       = [NSDate date];
    NSTimeInterval dis = time - [date timeIntervalSince1970];
    if (dis <= 0) {
        dis  = 0;
    }
    
    CountDowner *count = [CountDowner countDownerWithTime:dis];
    count.frame        = CGRectMake(originX, originY, width, height);
    [count setBackgroundColor:MAIN_COLOR];
    [count startCountDown];
    [self.timeView addSubview:count];
}

/** 设置每个菜单项的位置尺寸 */
- (void)setMenuTitleAndImageFrame:(MenuItem *)item
{
    CGFloat width  = item.bounds.size.width;
    CGFloat height = item.bounds.size.height;
    CGSize labSize = item.titleSize;
    
    if (item.tag == 0 || item.tag == 5 || item.tag == 6) {
        item.label.frame     = CGRectMake(WIDTH(12), HEIGHT(20), labSize.width, labSize.height);
        item.imageView.frame = CGRectMake(width - WIDTH(18) - WIDTH(55), (height - WIDTH(55)) * 0.5, WIDTH(55), WIDTH(55));
    }else if (item.tag == 3 || item.tag == 4) {
        item.label.frame     = CGRectMake(width * 0.5, (height - labSize.height) * 0.5, labSize.width, labSize.height);
        item.imageView.frame = CGRectMake(WIDTH(20), (height - WIDTH(38)) * 0.5, WIDTH(38), WIDTH(38));
    }else if (item.tag == 1 || item.tag == 2) {
        CGFloat imageW = WIDTH(55) * (item.tag == 2 ? 1.2 : 0.8);
        CGFloat imageX = WIDTH(15) + (item.tag == 2 ? WIDTH(-3) : WIDTH(5));
        CGFloat labelX = width - WIDTH(12) - labSize.width + (item.tag == 2 ? 0 : WIDTH(-3));
        item.imageView.frame = CGRectMake(imageX, (height - imageW) * 0.5, imageW, imageW);
        item.label.frame     = CGRectMake(labelX, HEIGHT(20), labSize.width, labSize.height);
    }
}

/** 菜单项的点击事件 */
- (void)menuItemDidClickWithTag:(NSInteger)tag
{
    switch (tag) {
        case 0:  // 视频开奖
        {
            VideoLotteryViewController *vc = [[VideoLotteryViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:  // 历史记录
        {
            HistoryViewController *vc = [[HistoryViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:  // 走势分析
        {
            WebViewController *vc = [[WebViewController alloc] initWithHidesBottomBar:YES];
            vc.type = WebVCTypeTrendAnalyze;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:  // 开奖日期
        {
            WebViewController *vc = [[WebViewController alloc] initWithHidesBottomBar:YES];
            vc.type = WebVCTypeDateLottery;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:  // 六合资料
        {
            DataViewController *vc = [[DataViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:  // 六合图库
        {
            PicLibraryViewController *vc = [[PicLibraryViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 6:  // 六合寻宝
        {
            TreasureViewController *vc = [[TreasureViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark end 初始化控件

#pragma mark - start XQCycleImageViewDelegate
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index
{
    AdvertModel *model = self.imageArr[index];
    if (![model.linkStr isEqualToString:@"#"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.linkStr]];
    }
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

/** 获取下期开奖事件 */
- (void)getLotteryNextTime
{
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] lotteryNextTimeWithSuccess:^(NSString *time) {
        NSString *formatter = @"MM月dd日  HH时mm分 EE";
        NSString *str = [SystemManager dateStringWithTime:[time doubleValue] formatter:formatter];
        ws.nextTimeLab.text = [NSString stringWithFormat:@"下期開獎時間：%@",str];
        [ws createCountDownerWithTime:[time doubleValue]];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark end 网络请求
@end
