//
//  DataViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "DataDetailViewController.h"
#import "DataViewController.h"
#import "NSString+Extension.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "XQSpringMenu.h"
#import "DataCell.h"

@interface DataViewController () <UITableViewDelegate, UITableViewDataSource, XQSpringMenuDelegate>

@property (nonatomic, weak) UITableView *tableView;
/** 标题数组 */
@property (nonatomic, strong) NSArray *titleList;
/** 分页数组 */
@property (nonatomic, strong) NSMutableArray *starList;
/** 心水资料数组 */
@property (nonatomic, strong) NSArray *favorList;
/** 文字资料数组 */
@property (nonatomic, strong) NSArray *textList;
/** 高手资料数组 */
@property (nonatomic, strong) NSArray *superList;
/** 公式资料数组 */
@property (nonatomic, strong) NSArray *fxList;
/** 精品杀项数组 */
@property (nonatomic, strong) NSArray *boutiqueList;
/** 香港挂牌数组 */
@property (nonatomic, strong) NSArray *cardList;
/** 全年资料数组 */
@property (nonatomic, strong) NSArray *yearList;
/** 当前的类型 */
@property (nonatomic) NSInteger type;

@end

@implementation DataViewController

- (void)dealloc
{
    NSLog(@"DataViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.type = 0;
    
    // 初始化控件
    [self createView];
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
/** 创建图片轮播 */
- (void)createView
{
    CGFloat tableY = 64;
    CGFloat tableH = SCREEN_HEIGHT - tableY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, tableH)];
    self.tableView         = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [self.view addSubview:tableView];
    
    __weak typeof(self) ws = self;
    tableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [ws getDataWitMore:NO];
    }];
    tableView.mj_footer    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [ws getDataWitMore:YES];
    }];
    [tableView.mj_header beginRefreshing];
    
    CGFloat moreBtnW  = WIDTH(45);
    CGFloat moreBtnX  = SCREEN_WIDTH - moreBtnW - WIDTH(25);
    CGFloat moreBtnY  = SCREEN_HEIGHT - moreBtnW - HEIGHT(110);
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreBtn setBackgroundColor:MAIN_COLOR];
    [moreBtn setImage:[UIImage imageNamed:@"btn_more"] forState:UIControlStateNormal];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(WIDTH(10), WIDTH(10), WIDTH(10), WIDTH(10))];
    [moreBtn setFrame:CGRectMake(moreBtnX, moreBtnY, moreBtnW, moreBtnW)];
    [moreBtn.layer setMasksToBounds:YES];
    [moreBtn.layer setCornerRadius:moreBtnW * 0.5];
    [moreBtn addTarget:self action:@selector(showMoreMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moreBtn];
}

- (void)showMoreMenu
{
    XQSpringMenuItem *favor = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(183, 97, 226)] title:@"心水資料"];
    XQSpringMenuItem *text  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(228, 82, 124)] title:@"文字資料"];
    XQSpringMenuItem *sup   = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(240, 110, 99)] title:@"高手資料"];
    XQSpringMenuItem *fx    = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(253, 161, 40)] title:@"公式資料"];
    XQSpringMenuItem *jp    = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(61, 183, 129)] title:@"精品殺項"];
    XQSpringMenuItem *card  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(95, 180, 216)] title:@"香港掛牌"];
    XQSpringMenuItem *year  = [[XQSpringMenuItem alloc] initWithImage:[UIImage imageWithColor:RGBCOLOR(106, 204, 203)] title:@"全年资料"];
    
    NSArray *array     = @[favor, text, sup, fx, jp, card, year];
    XQSpringMenu *menu = [XQSpringMenu springMenuWithItems:array];
    menu.delegate      = self;
    menu.animationTime = 0.56;
    menu.animationDelay = 0.017;
    menu.dismissAnimationTime = 0.3;
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

- (NSMutableArray *)starList
{
    if (!_starList) {
        _starList = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            [_starList addObject:@"0"];
        }
    }
    return _starList;
}
#pragma mark end 懒加载

#pragma mark - start 私有方法
/** 设置当前数组 */
- (void)setCurrentListWithArray:(NSMutableArray *)array tag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            self.favorList = array;
            break;
        case 1:
            self.textList = array;
            break;
        case 2:
            self.superList = array;
            break;
        case 3:
            self.fxList = array;
            break;
        case 4:
            self.boutiqueList = array;
            break;
        case 5:
            self.cardList = array;
            break;
        default:
            self.yearList = array;
            break;
    }
}

/** 返回当前的数组 */
- (NSArray *)getCurrentListWithTag:(NSInteger)tag
{
    switch (tag) {
        case 0:
            return self.favorList;
        case 1:
            return self.textList;
        case 2:
            return self.superList;
        case 3:
            return self.fxList;
        case 4:
            return self.boutiqueList;
        case 5:
            return self.cardList;
        default:
            return self.yearList;
    }
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

/** 停止刷新 */
- (void)endRefreshing
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    self.title = self.titleList[index];
    self.type = index;
    NSArray *currentList = [self getCurrentListWithTag:index];
    [self.tableView reloadData];
    if (!(currentList && currentList.count > 0)) {
        [self.tableView.mj_header beginRefreshing];
    }
}
#pragma mark end XQSpringMenuDelegate

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *currentList = [self getCurrentListWithTag:self.type];
    return currentList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *currentList = [self getCurrentListWithTag:self.type];
    DataModel *model     = currentList[indexPath.row];
    return model.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DataCell *cell = [DataCell dataCell:tableView];
    NSArray *currentList = [self getCurrentListWithTag:self.type];
    DataModel *model     = currentList[indexPath.row];
    [cell setCellData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *currentList = [self getCurrentListWithTag:self.type];
    DataModel *model     = currentList[indexPath.row];
    DataDetailViewController *vc = [[DataDetailViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start 网络请求
- (void)getDataWitMore:(BOOL)more
{
    if (more == NO) {
        self.starList[self.type] = @"0";
    }
    NSString *classID = [self getCurrentClassIDWithTag:self.type];
    NSString *star    = self.starList[self.type];
    
    NSArray *currentList    = [self getCurrentListWithTag:self.type];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager dataWithClassID:classID
                        star:star
                     success:^(NSArray *array) {
                         [ws endRefreshing];
                         NSMutableArray *dataList = [NSMutableArray array];
                         if (more) {
                             if ((!array) || array.count <= 0) {
                                 ws.tableView.mj_footer.hidden = YES;
                                 [SVProgressHUD showErrorWithStatus:@"沒有更多數據了"];
                                 return ;
                             }
                             [dataList addObjectsFromArray:currentList];
                         }else {
                             if (array.count >= 20) {
                                 ws.tableView.mj_footer.hidden = NO;
                             }
                         }
                         for (int i = 0; i < array.count; i++) {
                             NSDictionary *dict = array[i];
                             DataModel *data = [DataModel dataWithDict:dict];
                             [ws caculateHeightWithModel:data];
                             [dataList addObject:data];
                         }
                         ws.starList[ws.type] = [NSString stringWithFormat:@"%d", [star intValue] + 20];
                         [ws setCurrentListWithArray:dataList tag:ws.type];
                         [ws.tableView reloadData];
                     } failure:^(NSString *error) {
                         [ws endRefreshing];
                         [SVProgressHUD showErrorWithStatus:error];
                     }];
}
#pragma mark end 网络请求
@end
