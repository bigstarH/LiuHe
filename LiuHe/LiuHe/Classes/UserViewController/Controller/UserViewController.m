//
//  UserViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "PostReleaseViewController.h"
#import "MBProgressHUD+Extension.h"
#import "ModifyPswViewController.h"
#import "SettingViewController.h"
#import "MyReplyViewController.h"
#import "MyDataViewController.h"
#import "MyPostViewController.h"
#import "LoginViewController.h"
#import "UserViewController.h"
#import "NetworkManager.h"
#import "MineHeadView.h"
#import "XQToast.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource, MineHeadViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation UserViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 登录成功时通知
    [NotificationCenter addObserver:self selector:@selector(userDidLoginSuccess:) name:USER_LOGIN_SUCCESS object:nil];
    // 注销成功时通知
    [NotificationCenter addObserver:self selector:@selector(userDidLogoutSuccess:) name:USER_LOGOUT_SUCCESS object:nil];
    // 修改用户信息成功时通知
    [NotificationCenter addObserver:self selector:@selector(userDidModifySuccess:) name:USER_MODIFY_SUCCESS object:nil];
    // 修改用户密码成功时通知
    [NotificationCenter addObserver:self selector:@selector(userDidModifyPswSuccess:) name:USER_MODIFYPSW_SUCCESS object:nil];
    
    [self createView];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"我的";
    
    XQBarButtonItem *rightBtn1 = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"signIn"]];
    [rightBtn1 setTag:1];
    [rightBtn1 addTarget:self action:@selector(barButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    XQBarButtonItem *rightBtn2 = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post_forum"]];
    [rightBtn2 setTag:2];
    [rightBtn2 addTarget:self action:@selector(barButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItems = @[rightBtn1, rightBtn2];
}
#pragma mark end 设置导航栏

- (void)createView
{
    self.array = @[@"我的資料", @"我的收藏", @"我的帖子", @"我的回復", @"設置"];
    self.imageArray = @[@"user_data", @"user_collection", @"user_post", @"user_reply", @"user_setting"];
    
    MineHeadView *header   = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, HEIGHT(235))];
    header.delegate        = self;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _tableView             = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.rowHeight    = HEIGHT(50);
    [tableView setTableHeaderView:header];
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setScrollEnabled:IPHONE_4S];
    [self.view insertSubview:tableView belowSubview:self.navigationBar];
    
    UserModel *model = [UserModel getCurrentUser];
    if (model) {
        [header refreshHeaderDataWithModel:model];
    }
}

#pragma mark - start 通知事件
/** 用户登录成功时通知回调 */
- (void)userDidLoginSuccess:(NSNotification *)notification
{
    UserModel *model = (UserModel *)[[notification userInfo] objectForKey:@"userInfo"];
    MineHeadView *header = (MineHeadView *)[self.tableView tableHeaderView];
    [header refreshHeaderDataWithModel:model];
}

/** 用户注销成功时通知回调 */
- (void)userDidLogoutSuccess:(NSNotification *)notification
{
    MineHeadView *header = (MineHeadView *)[self.tableView tableHeaderView];
    [header resetHeaderData];
    UserModel *model = [UserModel getCurrentUser];
    if (model) {
        [[NetworkManager shareManager] userLogoutWithSuccess:nil failure:nil];
    }
    [UserModel removeCurrentUser];
}

/** 用户修改信息成功时通知回调 */
- (void)userDidModifySuccess:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    UIImage *image     = [dict objectForKey:@"headImage"];
    if (image) {
        MineHeadView *header  = (MineHeadView *)[self.tableView tableHeaderView];
        header.headView.image = image;
    }
}

/** 用户修改密码成功时通知回调 */
- (void)userDidModifyPswSuccess:(NSNotification *)notification
{
    [UserDefaults setBool:NO forKey:USER_DIDLOGIN];
    [NotificationCenter postNotificationName:USER_LOGOUT_SUCCESS object:nil];
}
#pragma mark end 通知事件

#pragma mark - start 按钮事件监听
- (void)barButtonItemEvent:(XQBarButtonItem *)sender
{
    BOOL didLogin = [UserDefaults boolForKey:USER_DIDLOGIN];
    if (!didLogin) {
        [[XQToast makeText:@"請先登錄"] show];
        return;
    }
    if (sender.tag == 1) {  // 签到
        __weak typeof(self) ws = self;
        MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
        [[NetworkManager shareManager] userSignInWithSuccess:^(NSDictionary *dict) {
            [hud hideAnimated:YES];
            NSString *ts         = [dict objectForKey:@"ts"];
            MineHeadView *header = (MineHeadView *)[ws.tableView tableHeaderView];
            [header setIntegral:[[dict objectForKey:@"fen"] intValue]];
            XQToast *toast   = [XQToast makeText:ts];
            toast.centerShow = YES;
            [toast show];
        } failure:^(NSString *error) {
            [hud hideAnimated:YES];
            XQToast *toast   = [XQToast makeText:error];
            toast.centerShow = YES;
            [toast show];
        }];
    }else {  // 发帖
        PostReleaseViewController *vc = [[PostReleaseViewController alloc] initWithHidesBottomBar:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - end 按钮事件监听

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell.textLabel setFont:[UIFont systemFontOfSize:fontSize(16)]];
    }
    cell.textLabel.text  = self.array[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL didLogin = [UserDefaults boolForKey:USER_DIDLOGIN];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:  // 我的资料
        {
            if (!didLogin) {
                [[XQToast makeText:@"請先登錄"] show];
                return;
            }
            MyDataViewController *vc = [[MyDataViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:  // 我的收藏
        {
            if (!didLogin) {
                [[XQToast makeText:@"請先登錄"] show];
                return;
            }
            MyCollectionViewController *vc = [[MyCollectionViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:  // 我的帖子
        {
            if (!didLogin) {
                [[XQToast makeText:@"請先登錄"] show];
                return;
            }
            MyPostViewController *vc = [[MyPostViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:  // 我的回复
        {
            if (!didLogin) {
                [[XQToast makeText:@"請先登錄"] show];
                return;
            }
            MyReplyViewController *vc = [[MyReplyViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:  // 设置
        {
            SettingViewController *setVC = [[SettingViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:setVC animated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start MineHeadViewDelegate
/** 头像点击事件 */
- (void)mineHeadView:(MineHeadView *)header didLogin:(BOOL)login
{
    if (login) {  // 已经登录了
        MyDataViewController *vc = [[MyDataViewController alloc] initWithHidesBottomBar:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else {  // 还没有登录
        LoginViewController *loginVC = [[LoginViewController alloc] initWithHidesBottomBar:YES];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

/** 修改密码 */
- (void)mineHeadView:(MineHeadView *)header modifyPasswordAndDidLogin:(BOOL)login
{
    if (login) {  // 已经登录，可以修改密码
        ModifyPswViewController *vc = [[ModifyPswViewController alloc] initWithHidesBottomBar:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }else {  // 还未登录，提示先登录
        [[XQToast makeText:@"請先登錄"] show];
    }
}
#pragma mark end MineHeadViewDelegate
@end
