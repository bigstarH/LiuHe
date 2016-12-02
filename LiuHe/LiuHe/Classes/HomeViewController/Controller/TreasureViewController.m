//
//  TreasureViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "TreasureViewController.h"
#import "NetworkManager.h"
#import "AdvertModel.h"

@interface TreasureViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation TreasureViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"六合尋寶";
    
    // 获取网络数据
    [self getNetData];
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
    NSLog(@"分享");
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
- (void)createView
{
    CGFloat rowHeight = (SCREEN_WIDTH * 200 / 1100) + HEIGHT(5);
    
    CGFloat tableH    = SCREEN_HEIGHT - 64;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, tableH)];
    _tableView             = tableView;
    tableView.rowHeight    = rowHeight;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
}
#pragma mark end 初始化控件

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    UIImageView *imageView = [cell viewWithTag:101];
    if (!imageView) {
        CGFloat imageY = HEIGHT(5);
        CGFloat imageH = tableView.rowHeight - imageY;
        imageView      = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageY, SCREEN_WIDTH, imageH)];
        imageView.tag  = 101;
        [imageView setBackgroundColor:RGBCOLOR(245, 242, 241)];
        [cell addSubview:imageView];
    }
    AdvertModel *model = self.dataList[indexPath.row];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.titlepic] placeholderImage:nil];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdvertModel *model = self.dataList[indexPath.row];
    if (![model.linkStr isEqualToString:@"#"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.linkStr]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start 网络请求
- (void)getNetData
{
    __weak typeof(self) ws = self;
    [SVProgressHUD show];
    [[NetworkManager shareManager] treasureWithSuccess:^(NSArray *array) {
        [SVProgressHUD dismiss];
        [ws createView];
        NSMutableArray *list   = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict = array[i];
            AdvertModel *model = [AdvertModel advertModelWithDict:dict];
            [list addObject:model];
        }
        ws.dataList = list;
        [ws.tableView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark end 网络请求
@end
