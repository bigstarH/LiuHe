//
//  DataViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "DataDetailViewController.h"
#import "DataViewController.h"
#import "NSString+Extension.h"
#import "NetworkManager.h"
#import "DataTableView.h"
#import "SystemManager.h"
#import "XQSpringMenu.h"
#import "DataModel.h"

@interface DataViewController () <DataTableViewDelegate, XQSpringMenuDelegate>

@property (nonatomic, weak) UIButton *moreBtn;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleList;
/** 当前的类型 */
@property (nonatomic) NSInteger type;

@end

@implementation DataViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = 0;
    
    // 初始化控件
    [self createButtonMenu];
    [self createTableViewWithTag:0];
    
    // 加载数据
    [self getNetData];
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
    NSLog(@"分享");
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
    [tableView setHideMJHeader:YES];
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
    
    NSArray *array      = @[favor, text, sup, fx, jp, card, year];
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
                        @"精品殺項", @"香港掛牌", @"全年资料"];
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
        default:
            return @"14";
    }
}

- (void)caculateHeightWithModel:(DataModel *)model
{
    NSString *title = model.title;
    UIFont *font    = [UIFont systemFontOfSize:fontSize(15)];
    CGSize maxSize  = CGSizeMake(SCREEN_WIDTH - WIDTH(24), CGFLOAT_MAX);
    model.height    = [title realSize:maxSize font:font].height + HEIGHT(9) * 3 + HEIGHT(20);
    
    NSTimeInterval time = model.newstime.doubleValue;
    model.dateStr   = [SystemManager dateStringWithTime:time formatter:@"yyyy-MM-dd HH:mm:ss"];
}
#pragma mark end 私有方法

#pragma mark - start XQSpringMenuDelegate
- (void)springMenu:(XQSpringMenu *)menu didClickItemAtIdx:(NSInteger)index menuTitle:(NSString *)menuTitle
{
    self.type  = index;
    self.title = self.titleList[index];
    DataTableView *tableView = [self getCurrentTableViewWithTag:index];
    if (tableView == nil) {
        [self createTableViewWithTag:index];
        [self getNetData];
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
        dataTableView.star  = 0;
    }
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager dataWithClassID:dataTableView.classID
                        star:[NSString stringWithFormat:@"%zd", dataTableView.star]
                     success:^(NSArray *array) {
                         [dataTableView endRefreshing];
                         NSMutableArray *dataList = [NSMutableArray array];
                         if (more) {
                             if ((!array) || array.count <= 0) {
                                 [dataTableView setHideMJFooter:YES];
                                 [SVProgressHUD showErrorWithStatus:@"沒有更多數據了"];
                                 return ;
                             }
                             [dataList addObjectsFromArray:dataTableView.dataList];
                         }else {
                             if (array.count >= pageSize) {
                                 [dataTableView setHideMJFooter:NO];
                             }
                         }
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
                         [SVProgressHUD showErrorWithStatus:error];
                     }];
}
#pragma mark end DataTableViewDelegate

#pragma mark - start 网络请求
- (void)getNetData
{
    DataTableView *tableView = [self getCurrentTableViewWithTag:self.type];
    __weak typeof(self) ws   = self;
    NetworkManager *manager  = [NetworkManager shareManager];
    [SVProgressHUD showWithStatus:@"正在加載中..."];
    [manager dataWithClassID:tableView.classID
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
                             DataModel *data = [DataModel dataWithDict:dict];
                             [ws caculateHeightWithModel:data];
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
