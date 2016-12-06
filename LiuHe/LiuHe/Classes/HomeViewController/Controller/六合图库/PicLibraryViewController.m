//
//  PicLibraryViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "PicLibraryViewController.h"
#import "PicDetailViewController.h"
#import "PicLibraryTableView.h"
#import "PicLibraryModel.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "ShareManager.h"
#import "ColumnView.h"
#import "ShareMenu.h"

@interface PicLibraryViewController () <ColumnViewDelegate, ShareMenuDelegate, PicLibraryTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) ColumnView *columnView;

@property (nonatomic, weak) UIScrollView *scrollView;
/** 下标 */
@property (nonatomic) NSInteger index;

@end

@implementation PicLibraryViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.index = 0;
    // 初始化控件
    [self createView];
    // 创建TableView
    [self createTableViewWithIndex:0];
    
    // 网络请求
    [self getNetData];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"六合圖庫";
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
- (void)createView
{
    ColumnView *columnView = [[ColumnView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(35))];
    self.columnView        = columnView;
    columnView.itemWidth   = SCREEN_WIDTH * 0.25;
    columnView.delegate    = self;
    columnView.items       = @[@"彩色圖庫", @"玄機圖庫", @"黑白圖庫", @"全年圖庫"];
    [columnView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.view addSubview:columnView];
    
    CGFloat scrollY = CGRectGetMaxY(columnView.frame);
    CGFloat scrollH = SCREEN_HEIGHT - scrollY;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollY, SCREEN_WIDTH, scrollH)];
    self.scrollView = scrollView;
    [scrollView setDelegate:self];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:CGSizeMake(SCREEN_WIDTH * 4, 0)];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:scrollView];
}

/** 创建TableView */
- (void)createTableViewWithIndex:(NSInteger)index
{
    CGFloat height = CGRectGetHeight(self.scrollView.frame);
    CGRect  frame  = CGRectMake(SCREEN_WIDTH * index, 0, SCREEN_WIDTH, height);
    PicLibraryTableView *tableView = [[PicLibraryTableView alloc] initWithFrame:frame];
    tableView.tag        = PLTableViewTypeColours + index;
    tableView.delegate   = self;
    tableView.rowHeight  = HEIGHT(60);
    tableView.classID    = [self getCurrentClassIDWithIndex:index];
    [tableView setHideMJHeader:YES];
    [tableView setHideMJFooter:YES];
    [self.scrollView addSubview:tableView];
}
#pragma mark end 初始化控件

#pragma mark - start 私有方法
/** 获取当前的TableView */
- (PicLibraryTableView *)getCurrentTableViewWithIndex:(NSInteger)index
{
    NSInteger type = index + PLTableViewTypeColours;
    PicLibraryTableView *tableView = [self.scrollView viewWithTag:type];
    return tableView;
}

/** 获取当前的ClassID */
- (NSString *)getCurrentClassIDWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:  // 彩色图库
            return @"66";
        case 1:  // 玄机图库
            return @"89";
        case 2:  // 黑白图库
            return @"92";
        case 3:  // 全年图库
            return @"65";
        default:
            return @"";
    }
}

/** 处理PicLibraryModel模型 */
- (void)dealWithModel:(PicLibraryModel *)model
{
    model.dateString = [SystemManager dateStringWithTime:[model.newstime doubleValue]
                                               formatter:@"yyyy-MM-dd HH:mm:ss"];
    NSString *url    = model.url;
    NSString *text   = model.title;
    if (model.qishu) {
        url  = [NSString stringWithFormat:@"%@%@/", model.url, model.qishu];
    }
    if (model.type) {
        url  = [NSString stringWithFormat:@"%@%@.jpg", url, model.type];
        text = [NSString stringWithFormat:@"%@ %@", model.type, model.title];
    }
    model.urlString = url;
    model.text      = text;
}
#pragma mark end 私有方法

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

#pragma mark - start ColumnViewDelegate
- (void)columnView:(ColumnView *)columnView didSelectedAtItem:(NSInteger)item
{
    self.index = item;
    [self.scrollView setContentOffset:CGPointMake(item * SCREEN_WIDTH, 0) animated:NO];
    PicLibraryTableView *tableView = [self getCurrentTableViewWithIndex:item];
    if (!tableView) {
        [self createTableViewWithIndex:item];
        [self getNetData];
    }else if ((!tableView.dataList) || tableView.dataList.count <= 0) {
        [self getNetData];
    }
}
#pragma mark end ColumnViewDelegate

#pragma mark - start PicLibraryTableViewDelegate
/** 上拉加载／下拉刷新 */
- (void)picLTableView:(PicLibraryTableView *)picLTableView refreshingDataWithMore:(BOOL)more
{
    if (more == NO) {
        picLTableView.star  = 0;
    }
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager picLibraryWithClassID:picLTableView.classID
                              star:[NSString stringWithFormat:@"%zd", picLTableView.star]
                           success:^(NSArray *array) {
                               [picLTableView endRefreshing];
                               NSMutableArray *dataList = [NSMutableArray array];
                               if (more) {
                                   if ((!array) || array.count <= 0) {
                                       [picLTableView setHideMJFooter:YES];
                                       [SVProgressHUD showErrorWithStatus:@"沒有更多數據了"];
                                       return ;
                                   }
                                   [dataList addObjectsFromArray:picLTableView.dataList];
                               }else {
                                   if (array.count >= pageSize) {
                                       [picLTableView setHideMJFooter:NO];
                                   }
                               }
                               for (int i = 0; i < array.count; i++) {
                                   NSDictionary *dict = array[i];
                                   PicLibraryModel *data = [PicLibraryModel picLibraryWithDict:dict];
                                   [ws dealWithModel:data];
                                   [dataList addObject:data];
                               }
                               picLTableView.star     = picLTableView.star + 20;
                               picLTableView.dataList = dataList;
                               [picLTableView.tableView reloadData];
                           } failure:^(NSString *error) {
                               [picLTableView endRefreshing];
                               [SVProgressHUD showErrorWithStatus:error];
                           }];
}

/** 点击了某一行 */
- (void)picLTableView:(PicLibraryTableView *)picLTableView didSelectCellWithModel:(PicLibraryModel *)model
{
    PicDetailViewController *vc = [[PicDetailViewController alloc] init];
    vc.model   = model;
    vc.classID = picLTableView.classID;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end PicLibraryTableViewDelegate

#pragma mark - start UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.index = currentIndex;
    [self.columnView scrollToCurrentIndex:currentIndex];
    PicLibraryTableView *tableView = [self getCurrentTableViewWithIndex:currentIndex];
    if (!tableView) {
        [self createTableViewWithIndex:currentIndex];
        [self getNetData];
    }else if ((!tableView.dataList) || tableView.dataList.count <= 0) {
        [self getNetData];
    }
}
#pragma mark end UIScrollViewDelegate

#pragma mark - start 网络请求
- (void)getNetData
{
    PicLibraryTableView *tableView = [self getCurrentTableViewWithIndex:self.index];
    NetworkManager *manager = [NetworkManager shareManager];
    __weak typeof(self) ws  = self;
    [SVProgressHUD showWithStatus:@"正在加載中..."];
    [manager picLibraryWithClassID:tableView.classID
                              star:[NSString stringWithFormat:@"%zd", tableView.star]
                           success:^(NSArray *array) {
                               [SVProgressHUD dismiss];
                               [tableView setHideMJHeader:NO];
                               if (array.count >= pageSize) {
                                   [tableView setHideMJFooter:NO];
                               }
                               NSMutableArray *dataList = [NSMutableArray array];
                               tableView.star = 20;
                               for (int i = 0; i < array.count; i++) {
                                   NSDictionary *dict = array[i];
                                   PicLibraryModel *data = [PicLibraryModel picLibraryWithDict:dict];
                                   [ws dealWithModel:data];
                                   [dataList addObject:data];
                               }
                               tableView.dataList = dataList;
                               [tableView.tableView reloadData];
                           } failure:^(NSString *error) {
                               [SVProgressHUD showErrorWithStatus:error];
                           }];
}
#pragma mark end 网络请求
@end
