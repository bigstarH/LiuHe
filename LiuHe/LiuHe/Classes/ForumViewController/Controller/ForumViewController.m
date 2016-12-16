//
//  ForumViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "PostReleaseViewController.h"
#import "ForumDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "XQFasciatePageControl.h"
#import "ForumViewController.h"
#import "NSString+Extension.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "ShareManager.h"
#import "AdvertModel.h"
#import "ShareMenu.h"
#import "ForumCell.h"
#import "XQToast.h"

#define pageSize   20
#define starBegin  50

@interface ForumViewController () <XQCycleImageViewDelegate, ShareMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@property (nonatomic, weak) UITableView *tableView;
/** 论坛帖子数据数组 */
@property (nonatomic, strong) NSArray *dataList;
/** 分页 */
@property (nonatomic) NSInteger star;

@property (nonatomic) BOOL loadFailure;
@end

@implementation ForumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建广告轮播
    [self createCycleImageView];
    // 创建论坛列表
    [self createTableView];
    
    // 获取广告数据
    [self getAdvertisementPic];
    
    // 获取论坛数据
    self.loadFailure = NO;
    [self getForumPostWithHUD:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ((!self.dataList) || self.dataList.count <= 0) {
        if (self.loadFailure) {
            [self getForumPostWithHUD:YES];
        }
    }
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"論壇";
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = shareBtn;
    
    XQBarButtonItem *postBtn  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post_forum"]];
    [postBtn setTag:2];
    [postBtn addTarget:self action:@selector(releasePost) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItems = @[shareBtn, postBtn];
}

- (void)shareEvent
{
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}

- (void)releasePost
{
    BOOL didLogin = [UserDefaults boolForKey:USER_DIDLOGIN];
    if (!didLogin) {
        [[XQToast makeText:@"請先登錄"] show];
        return;
    }
    PostReleaseViewController *vc = [[PostReleaseViewController alloc] initWithHidesBottomBar:YES];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)createTableView
{
    CGFloat tableY = CGRectGetMaxY(self.cycleImageView.frame);
    CGFloat tableH = SCREEN_HEIGHT - tableY - 49;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, tableH)];
    self.tableView         = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:tableView];
    
    __weak typeof(self) ws = self;
    tableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getForumPostWithMore:NO];
    }];
    tableView.mj_footer    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws getForumPostWithMore:YES];
    }];
    tableView.mj_header.hidden = YES;
    tableView.mj_footer.hidden = YES;
}
#pragma mark end 初始化控件

#pragma mark - start 私有方法
/** 列表结束刷新加载 */
- (void)endRefreshing
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

/** 处理ForumModel */
- (void)dealWithModel:(ForumModel *)model
{
    model.dateString  = [SystemManager dateStringWithTime:[model.newstime doubleValue] formatter:@"yyyy-MM-dd"];
    
    UIFont *font    = [UIFont systemFontOfSize:fontSize(13)];
    CGSize maxSize  = CGSizeMake(WIDTH(130), HEIGHT(18));
    CGSize realSize = [model.username realSize:maxSize font:font];
    model.userNameWidth = realSize.width + WIDTH(10);
    
    realSize = [model.groupname realSize:maxSize font:font];
    model.groupNameWidth = realSize.width + WIDTH(10);
    
    NSString *string = [NSString stringWithFormat:@"%d", model.rnum.intValue];
    realSize = [string realSize:CGSizeMake(CGFLOAT_MAX, HEIGHT(20)) font:[UIFont systemFontOfSize:fontSize(12)]];
    model.replyWith  = realSize.width + WIDTH(6);
}
#pragma mark end 私有方法

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT(94);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumCell *cell   = [ForumCell forumCell:tableView];
    ForumModel *model = self.dataList[indexPath.row];
    cell.model        = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ForumModel *model = self.dataList[indexPath.row];
    ForumDetailViewController *vc = [[ForumDetailViewController alloc] initWithHidesBottomBar:YES];
    vc.model        = model;
    vc.needReplyBtn = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

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

#pragma mark - start XQCycleImageViewDelegate
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index
{
    AdvertModel *model = self.imageArr[index];
    if (![model.linkStr isEqualToString:@"#"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.linkStr]];
    }
}

- (void)cycleImageViewDidScrollingAnimation:(XQCycleImageView *)cycleImageView atIndex:(int)index
{
    self.pageControl.currentPage = index;
}
#pragma mark end XQCycleImageViewDelegate

#pragma mark - start 网络请求
- (void)getForumPostWithHUD:(BOOL)needHUD
{
    __weak typeof(self) ws = self;
    MBProgressHUD *hud     = nil;
    if (needHUD) {
        hud = [MBProgressHUD hudView:self.view text:@"正在加載中..." removeOnHide:YES];
    }
    [[NetworkManager shareManager] forumPostWithSuccess:^(NSArray *array) {
        [hud hideAnimated:YES];
        [ws endRefreshing];
        ws.tableView.mj_header.hidden = NO;
        if (array.count >= pageSize) {
            ws.tableView.mj_footer.hidden = NO;
        }
        NSMutableArray *dataList = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            ForumModel *data   = [ForumModel forumModelWithDict:dict];
            [ws dealWithModel:data];
            [dataList addObject:data];
        }
        ws.star     = starBegin;
        ws.dataList = dataList;
        [ws.tableView reloadData];
    } failure:^(NSString *error) {
        ws.loadFailure = YES;
        [ws endRefreshing];
        [hud hideAnimated:YES];
        [MBProgressHUD showFailureInView:ws.view mesg:error];
    }];
}

/** 获取论坛数据 */
- (void)getForumPostWithMore:(BOOL)more
{
    if (more == NO) {
        [self getForumPostWithHUD:NO];
    }else {
        __weak typeof(self) ws  = self;
        NetworkManager *manager = [NetworkManager shareManager];
        [manager forumPostWithStar:[NSString stringWithFormat:@"%zd", self.star]
                           success:^(NSArray *array) {
                               [ws endRefreshing];
                               if ((!array) || array.count <= 0) {
                                   ws.tableView.mj_footer.hidden = YES;
                                   [MBProgressHUD showFailureInView:ws.view mesg:@"沒有更多數據了"];
                                   return ;
                               }
                               NSMutableArray *dataList = [ws.dataList mutableCopy];
                               for (int i = 0; i < array.count; i++) {
                                   NSDictionary *dict = array[i];
                                   ForumModel *data = [ForumModel forumModelWithDict:dict];
                                   if (data.rnum.intValue > 0) {
                                       NSLog(@"titile = %@", data.title);
                                   }
                                   [ws dealWithModel:data];
                                   [dataList addObject:data];
                               }
                               ws.star     = ws.star + 20;
                               ws.dataList = dataList;
                               [ws.tableView reloadData];
                           } failure:^(NSString *error) {
                               [ws endRefreshing];
                               [MBProgressHUD showFailureInView:ws.view mesg:error];
                           }];
    }
}

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
                                            [ws getAdvertisementPic];
                                        }];
}
#pragma mark end 网络请求
@end
