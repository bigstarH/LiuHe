//
//  MyCollectionViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "MyCollectionViewController.h"
#import "CollectionModel.h"
#import "NetworkManager.h"
#import "XQAlertView.h"

@interface MyCollectionViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation MyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    [self createView];
    [self getMyCollectionData];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar   = YES;
    self.title = @"我的收藏";
    self.navigationBar.shadowHidden = YES;
    
    XQBarButtonItem *leftBtn  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftBtn;
    self.navigationBar.rightBarButtonItem = shareBtn;
}

- (void)shareEvent
{
    NSLog(@"分享");
}

- (void)createView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(30))];
    label.text     = @"提示：向左滑動可以取消收藏";
    label.font     = [UIFont systemFontOfSize:fontSize(12)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    CGFloat tableY = CGRectGetMaxY(label.frame);
    CGFloat tableH = SCREEN_HEIGHT - tableY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, tableH)];
    self.tableView         = tableView;
    tableView.dataSource   = self;
    tableView.delegate     = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tableView];
}

/** 取消收藏 */
- (void)cancelCollecting
{
    XQAlertView *alert = [[XQAlertView alloc] initWithTitle:@"提示" message:@"確定要取消收藏麽？"];
    alert.themeColor   = RGBCOLOR(238, 154, 0);
    alert.titleColor   = [UIColor whiteColor];
    [alert addButtonWithTitle:@"再想一想" style:XQAlertButtonStyleCancel handle:nil];
    [alert addButtonWithTitle:@"確定" style:XQAlertButtonStyleDefault handle:^{
        
    }];
    [alert show];
}

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) ws     = self;
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"取消收藏"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      [ws cancelCollecting];
                                                                  }];
    edit.backgroundColor = [UIColor redColor];
    return @[edit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CollectionModel *model = self.array[indexPath.row];
    cell.textLabel.text    = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start 网络请求——获取我的收藏
- (void)getMyCollectionData
{
    [SVProgressHUD showWithStatus:@"正在加载数据..."];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] userCollectionWithSuccess:^(NSArray *array) {
        [SVProgressHUD dismiss];
        NSMutableArray *data = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict     = array[i];
            CollectionModel *model = [CollectionModel collectionModelWithDict:dict];
            [data addObject:model];
        }
        ws.array = data;
        [ws.tableView reloadData];
    } failure:^(NSString *error) {
        [SVProgressHUD showErrorWithStatus:error];
    }];
}
#pragma mark end 网络请求——获取我的收藏
@end
