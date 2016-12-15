//
//  DataViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "DataDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "DataViewController.h"
#import "NSString+Extension.h"
#import "NetworkManager.h"
#import "DataTableView.h"
#import "SystemManager.h"
#import "ShareManager.h"
#import "XQSpringMenu.h"
#import "DataModel.h"
#import "ShareMenu.h"

@interface DataViewController () <DataTableViewDelegate, XQSpringMenuDelegate, ShareMenuDelegate>

@property (nonatomic, weak) UIButton *moreBtn;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleList;
/** 当前的类型 */
@property (nonatomic) NSInteger type;

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = 0;
    
    // 初始化控件
    [self createButtonMenu];
    [self createTableViewWithTag:0];
    
    // 加载数据
    [self getNetDataWithHUD:YES];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = self.titleList[0];
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
/** 创建TableView */
- (DataTableView *)createTableViewWithTag:(NSInteger)tag
{
    CGRect  frame  = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    DataTableView *tableView = [[DataTableView alloc] initWithFrame:frame];
    tableView.tag        = TableViewTypeFavor + tag;
    tableView.delegate   = self;
    tableView.classID    = [self getCurrentClassIDWithTag:tag];
    [tableView setHideMJFooter:YES];
    [self.view insertSubview:tableView belowSubview:self.moreBtn];
    return tableView;
}

/** 创建“更多”菜单按钮 */
- (void)createButtonMenu
{
    CGFloat moreBtnW  = WIDTH(45);
    CGFloat moreBtnX  = SCREEN_WIDTH - moreBtnW - WIDTH(25);
    CGFloat moreBtnY  = SCREEN_HEIGHT - moreBtnW - HEIGHT(110);
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn      = moreBtn;
    [moreBtn setBackgroundColor:MAIN_COLOR];
    [moreBtn setImage:[UIImage imageNamed:@"menu_more"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(WIDTH(10), WIDTH(10), WIDTH(10), WIDTH(10))];
    [moreBtn setFrame:CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnW)];
    [moreBtn.layer setMasksToBounds:YES];
    [moreBtn.layer setCornerRadius:moreBtnW * 0.5];
    [moreBtn addTarget:self action:@selector(showMoreMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
}

- (void)showMoreMenu
{
    XQSpringMenuItem *favor = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"心水資料"] title:@"心水資料"];
    XQSpringMenuItem *text  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"文字資料"] title:@"文字資料"];
    XQSpringMenuItem *sup   = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"高手資料"] title:@"高手資料"];
    XQSpringMenuItem *fx    = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"公式資料"] title:@"公式資料"];
    XQSpringMenuItem *jp    = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"精品殺項"] title:@"精品殺項"];
    XQSpringMenuItem *card  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"香港掛牌"] title:@"香港掛牌"];
    XQSpringMenuItem *year  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"全年資料"] title:@"全年資料"];
    XQSpringMenuItem *attr  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageNamed:@"六合屬性"] title:@"六合屬性"];
    
    NSArray *array      = @[favor, text, sup, fx, jp, card, year, attr];
    XQSpringMenu *menu  = [XQSpringMenu springMenuWithItems:array];
    menu.delegate       = self;
    menu.animationTime  = 0.56;
    menu.animationDelay = 0.017;
    menu.dismissAnimationTime  = 0.3;
    menu.dismissAnimationDelay = 0.017;
    [menu showWithAnimate:YES];
}
#pragma mark end 初始化控件

#pragma mark - start 懒加载
- (NSArray *)titleList
{
    if (!_titleList) {
        _titleList = @[@"心水資料", @"文字資料", @"高手資料", @"公式資料",
                        @"精品殺項", @"香港掛牌", @"全年资料", @"六合屬性"];
    }
    return _titleList;
}
#pragma mark end 懒加载

#pragma mark - start 私有方法
/** 返回当前的tableView */
- (DataTableView *)getCurrentTableViewWithTag:(NSInteger)tag
{
    NSInteger type = tag + TableViewTypeFavor;
    DataTableView *tableView = [self.view viewWithTag:type];
    return tableView;
}

/** 返回当前的Classid */
- (NSString *)getCurrentClassIDWithTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            return @"10";
        case 1:
            return @"11";
        case 2:
            return @"7";
        case 3:
            return @"12";
        case 4:
            return @"13";
        case 5:
            return @"67";
        case 6:
            return @"14";
        default:
            return @"83";
    }
}

/** 返回静态URL */
- (NSString *)getCurrentUrlWithTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            return DATA_FAVORITE_URL;
        case 1:
            return DATA_TEXT_URL;
        case 2:
            return DATA_SUPER_URL;
        case 3:
            return DATA_FX_URL;
        case 4:
            return DATA_BOUTIQUE_URL;
        case 5:
            return DATA_CARD_URL;
        case 6:
            return DATA_YEAR_URL;
        default:
            return DATA_ATTRIBUTE_URL;
    }
}

- (void)caculateHeightWithModel:(DataModel *)model
{
    NSString *title = model.title;
    title = [title stringByReplacingOccurrencesOfString:@"六合管家" withString:@"六合藏宝"];
    model.title     = title;
    
    UIFont *font    = [UIFont systemFontOfSize:fontSize(15)];
    CGSize maxSize  = CGSizeMake(SCREEN_WIDTH - WIDTH(24), CGFLOAT_MAX);
    model.height    = [title realSize:maxSize font:font].height + HEIGHT(9) * 3 + HEIGHT(20);
    
    NSTimeInterval time = model.newstime.doubleValue;
    model.dateStr   = [SystemManager dateStringWithTime:time formatter:@"yyyy-MM-dd HH:mm:ss"];
}
#pragma mark end 私有方法

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

#pragma mark - start XQSpringMenuDelegate
- (void)springMenu:(XQSpringMenu *)menu didClickItemAtIdx:(NSInteger)index menuTitle:(NSString *)menuTitle
{
    self.type  = index;
    self.title = self.titleList[index];
    DataTableView *tableView = [self getCurrentTableViewWithTag:index];
    if (tableView == nil) {
        [self createTableViewWithTag:index];
        [self getNetDataWithHUD:YES];
    }else {
        [self.view bringSubviewToFront:tableView];
    }
    [self.view bringSubviewToFront:self.moreBtn];
}
#pragma mark end XQSpringMenuDelegate

#pragma mark - start DataTableViewDelegate
/** 点击了某一行 */
- (void)dataTableView:(DataTableView *)dataTableView didSelectCellWithModel:(DataModel *)model
{
    DataDetailViewController *vc = [[DataDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

/** 上拉刷新／下拉加载 */
- (void)dataTableView:(DataTableView *)dataTableView refreshingDataWithMore:(BOOL)more
{
    if (more == NO) {
        [self getNetDataWithHUD:NO];
    }else {
        __weak typeof(self) ws  = self;
        NetworkManager *manager = [NetworkManager shareManager];
        [manager dataWithClassID:dataTableView.classID
                            star:[NSString stringWithFormat:@"%zd", dataTableView.star]
                         success:^(NSArray *array) {
                             [dataTableView endRefreshing];
                             if ((!array) || array.count <= 0) {
                                 [dataTableView setHideMJFooter:YES];
                                 [MBProgressHUD showFailureInView:ws.view mesg:@"沒有更多數據了"];
                                 return ;
                             }
                             NSMutableArray *dataList = [dataTableView.dataList mutableCopy];
                             for (int i = 0; i < array.count; i++) {
                                 NSDictionary *dict = array[i];
                                 DataModel *data = [DataModel dataWithDict:dict];
                                 [ws caculateHeightWithModel:data];
                                 [dataList addObject:data];
                             }
                             dataTableView.star     = dataTableView.star + 20;
                             dataTableView.dataList = dataList;
                             [dataTableView.tableView reloadData];
                         } failure:^(NSString *error) {
                             [dataTableView endRefreshing];
                             [MBProgressHUD showFailureInView:ws.view mesg:error];
                         }];
    }
}
#pragma mark end DataTableViewDelegate

#pragma mark - start 网络请求
- (void)getNetDataWithHUD:(BOOL)needHUD
{
    DataTableView *tableView = [self getCurrentTableViewWithTag:self.type];
    __weak typeof(self) ws   = self;
    NetworkManager *manager  = [NetworkManager shareManager];
    MBProgressHUD *hud       = nil;
    if (needHUD) {
        hud = [MBProgressHUD hudView:self.view text:@"正在加載中..." removeOnHide:YES];
    }
    [manager dataWithUrl:[self getCurrentUrlWithTag:self.type]
                 success:^(NSArray *array) {
                     [tableView endRefreshing];
                     [hud hideAnimated:YES];
                     if (array.count >= pageSize) {
                         [tableView setHideMJFooter:NO];
                     }
                     NSMutableArray *dataList = [NSMutableArray array];
                     tableView.star = starBegin;
                     for (int i = 0; i < array.count; i++) {
                         NSDictionary *dict = array[i];
                         DataModel *data = [DataModel dataWithDict:dict];
                         [ws caculateHeightWithModel:data];
                         [dataList addObject:data];
                     }
                     tableView.dataList = dataList;
                     [tableView.tableView reloadData];
                 } failure:^(NSString *error) {
                     [hud hideAnimated:YES];
                     [tableView endRefreshing];
                     [MBProgressHUD showFailureInView:ws.view mesg:error];
                 }];
}
#pragma mark end 网络请求
@end
