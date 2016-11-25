//
//  UserViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "UserViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MyDataViewController.h"
#import "NetworkManager.h"
#import "MineHeadView.h"

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
    
    [self createView];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    [super setNavigationBarStyle];
    self.navigationController.navigationBar.hidden = YES;
    self.needsCustomNavigationBar      = YES;
    self.title = @"我的";
    self.navigationBar.shadowHidden    = YES;
    self.navigationBar.imageView.alpha = 0;
    self.navigationBar.mOpaque         = 64;
    
    XQBarButtonItem *rightBtn1 = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"signIn"]];
    [rightBtn1 setTag:1];
    [rightBtn1 addTarget:self action:@selector(barButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    XQBarButtonItem *rightBtn2 = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"post_forum"]];
    [rightBtn2 setTag:2];
    [rightBtn2 addTarget:self action:@selector(barButtonItemEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItems = @[rightBtn1, rightBtn2];
}

- (UIColor *)setBarTintColor
{
    return MAIN_COLOR;
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
    [tableView setScrollEnabled:NO];
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
        [[NetworkManager shareManager] userLogoutWithUserID:model.uid
                                                   userName:model.userName
                                                        rnd:model.rnd
                                                    success:nil failure:nil];
    }
    [UserModel removeCurrentUser];
}
#pragma mark end 通知事件

#pragma mark - start 按钮事件监听
- (void)barButtonItemEvent:(XQBarButtonItem *)sender
{
    if (sender.tag == 1) {  // 签到
        
    }else {  // 发帖
        
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
//            if (!didLogin) {
//                [SVProgressHUD showErrorWithStatus:@"請先登錄"];
//                return;
//            }
            MyDataViewController *vc = [[MyDataViewController alloc] initWithHidesBottomBar:YES];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:  // 我的收藏
        {
            if (!didLogin) {
                [SVProgressHUD showErrorWithStatus:@"請先登錄"];
                return;
            }
            break;
        }
        case 2:  // 我的帖子
        {
            if (!didLogin) {
                [SVProgressHUD showErrorWithStatus:@"請先登錄"];
                return;
            }
            break;
        }
        case 3:  // 我的回复
        {
            if (!didLogin) {
                [SVProgressHUD showErrorWithStatus:@"請先登錄"];
                return;
            }
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
#pragma mark end MineHeadViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentY = scrollView.contentOffset.y;
    if (contentY < 0) {
        self.navigationBar.imageView.alpha = 1;
    }else {
        self.navigationBar.imageView.alpha = contentY / self.navigationBar.mOpaque;
    }
}
@end
