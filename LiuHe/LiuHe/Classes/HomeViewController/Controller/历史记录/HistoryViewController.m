//
//  HistoryViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/30.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "HistoryDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "HistoryViewController.h"
#import "XQFasciatePageControl.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "ShareManager.h"
#import "AdvertModel.h"
#import "HistoryCell.h"
#import "ShareMenu.h"

@interface HistoryViewController () <XQCycleImageViewDelegate, ShareMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建广告轮播
    [self createCycleImageView];
    // 创建tableView
    [self createTableView];
    
    // 获得广告轮播图
    [self getAdvertisementPic];
    // 获取历史记录
    [self getLotteryHistoryWithMore:NO needHUD:YES];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"歷史記錄";
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

/** 创建tableView */
- (void)createTableView
{
    CGFloat tableY = CGRectGetMaxY(self.cycleImageView.frame);
    CGFloat tableH = SCREEN_HEIGHT - tableY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, tableH)];
    self.tableView         = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:tableView];
    
    __weak typeof(self) ws = self;
    tableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                                 [ws getLotteryHistoryWithMore:NO needHUD:NO];
                             }];
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
#pragma mark end 初始化控件

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

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(70);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryCell *cell = [HistoryCell historyCell:tableView];
    LotteryNumberModel *model = self.dataList[indexPath.row];
    [cell setCellData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LotteryNumberModel *model = self.dataList[indexPath.row];
    HistoryDetailViewController *vc = [[HistoryDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

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
                                            [MBProgressHUD showFailureInView:ws.view mesg:error];
                                        }];
}

/** 获取历史记录 */
- (void)getLotteryHistoryWithMore:(BOOL)more needHUD:(BOOL)needHUD
{
    __weak typeof(self) ws = self;
    
    MBProgressHUD *hud = nil;
    if (needHUD) {
        hud = [MBProgressHUD hudView:self.view text:@"正在加載中..." removeOnHide:YES];
    }
    [[NetworkManager shareManager] lotteryHistoryWithSuccess:^(NSArray *array) {
        [hud hideAnimated:YES];
        [ws.tableView.mj_header endRefreshing];
        NSMutableArray *list = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            LotteryNumberModel *model = [LotteryNumberModel lotteryNumberWithDict:dict];
            [list addObject:model];
        }
        ws.dataList = list;
        [ws.tableView reloadData];
    } failure:^(NSString *error) {
        [hud hideAnimated:YES];
        [ws.tableView.mj_header endRefreshing];
        [MBProgressHUD showFailureInView:ws.view mesg:error];
    }];
}
#pragma mark end 网络请求
@end
