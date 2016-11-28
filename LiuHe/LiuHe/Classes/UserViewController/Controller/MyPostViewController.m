//
//  MyPostViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "PostReleaseViewController.h"
#import "MyPostViewController.h"
#import "XQSegmentedControl.h"
#import "NetworkManager.h"
#import "PostModel.h"

@interface MyPostViewController () <UITableViewDelegate, UITableViewDataSource>

/** 0: 未审核， 1: 已审核 */
@property (nonatomic) NSInteger type;

@property (nonatomic, weak) UITableView *tableView;
/** 已审核的帖子 */
@property (nonatomic, strong) NSArray *postArray;
/** 未审核的帖子 */
@property (nonatomic, strong) NSArray *unPostArray;

@end

@implementation MyPostViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    self.type = 1;
    
    // 帖子编辑成功时通知
    [NotificationCenter addObserver:self selector:@selector(postEditSuccess:) name:POST_EDIT_SUCCESS object:nil];
    
    // 初始化控件
    [self createView];
    
    // 网络请求
    [self getMyPostWithType:self.type];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar   = YES;
    self.navigationBar.shadowHidden = YES;
    
    XQBarButtonItem *leftBtn  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftBtn;
    self.navigationBar.rightBarButtonItem = shareBtn;
}

- (UIView *)setTitleView
{
    XQSegmentedControl *segControl = [[XQSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 120, 28)];
    segControl.selectedTextColor   = MAIN_COLOR;
    segControl.textColor           = [UIColor whiteColor];
    segControl.tintColor           = [UIColor clearColor];
    segControl.layer.masksToBounds = YES;
    segControl.layer.borderColor   = [UIColor whiteColor].CGColor;
    segControl.layer.borderWidth   = 1.0;
    segControl.layer.cornerRadius  = 3;
    segControl.panEnabled          = NO;
    [segControl setItems:@[@"已审核", @"未审核"]];
    [segControl setFont:[UIFont systemFontOfSize:13]];
    [segControl addTarget:self action:@selector(segmentEvent:) forControlEvents:UIControlEventValueChanged];
    return segControl;
}

#pragma mark - start 编辑帖子成功时通知
- (void)postEditSuccess:(NSNotification *)notification
{
    [self getMyPostWithType:self.type];
}
#pragma mark end 编辑帖子成功时通知

- (void)shareEvent
{
    NSLog(@"分享");
}

- (void)createView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(30))];
    label.text     = @"提示：向左滑動可對帖子進行修改";
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

- (void)segmentEvent:(XQSegmentedControl *)sender
{
    self.type = !sender.selectedSegmentIndex;
    if (self.type == 0 && !self.unPostArray) {
        [self getMyPostWithType:self.type];
    }else if (self.type == 1 && !self.postArray) {
        [self getMyPostWithType:self.type];
    }else {
        [self.tableView reloadData];
    }
}

/** 编辑帖子的详情 */
- (void)goToPostDetailVCWithRow:(NSInteger)row
{
    NSString *sid = @"";
    if (self.type == 0) {
        PostModel *model = [self.unPostArray objectAtIndex:row];
        sid = model.sid;
    }else {
        PostModel *model = [self.postArray objectAtIndex:row];
        sid = model.sid;
    }
    PostReleaseViewController *vc = [[PostReleaseViewController alloc] init];
    vc.type   = VCTypePostEdit;
    vc.status = self.type;
    vc.sid    = sid;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.type == 1 ? self.postArray.count : self.unPostArray.count;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) ws = self;
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"编辑"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      [ws goToPostDetailVCWithRow:indexPath.row];
                                                                  }];
    edit.backgroundColor = MAIN_COLOR;
    return @[edit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (self.type == 0) { // 未审核
        PostModel *model    = self.unPostArray[indexPath.row];
        cell.textLabel.text = model.title;
    }else {  // 已审核
        PostModel *model    = self.postArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start 网络请求
- (void)getMyPostWithType:(NSInteger)type
{
    NSString *enews = @"Mybbs";
    if (type == 0) { // 未审核
        enews = @"Mybbs1";
    }
    [SVProgressHUD show];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] userPostWithEnews:enews
                                             success:^(NSArray *array) {
                                                 [SVProgressHUD dismiss];
                                                 NSMutableArray *data = [NSMutableArray array];
                                                 for (int i = 0; i < array.count; i++) {
                                                     NSDictionary *dict = array[i];
                                                     PostModel *model   = [PostModel postModelWithDict:dict];
                                                     [data addObject:model];
                                                 }
                                                 if (ws.type == 0) {
                                                     ws.unPostArray = data;
                                                 }else {
                                                     ws.postArray = data;
                                                 }
                                                 [ws.tableView reloadData];
                                             } failure:^(NSString *error) {
                                                 [SVProgressHUD showErrorWithStatus:error];
                                             }];
}
#pragma mark end 网络请求
@end
