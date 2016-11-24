//
//  UserViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "NetworkManager.h"
#import "MineHeadView.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource, MineHeadViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, weak) UIButton *logoutBtn;

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
    [NotificationCenter addObserver:self selector:@selector(userDidLoginSuccess:) name:USER_LOGIIN_SUCCESS object:nil];
    
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
    
    CGFloat buttonH        = HEIGHT(40);
    MineHeadView *header   = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, HEIGHT(235))];
    header.delegate        = self;
    UIView *footer         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, buttonH + HEIGHT(20))];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _tableView             = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.rowHeight    = HEIGHT(50);
    [tableView setTableHeaderView:header];
    [tableView setTableFooterView:footer];
    [tableView setShowsVerticalScrollIndicator:NO];
    [self.view insertSubview:tableView belowSubview:self.navigationBar];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutBtn   = logout;
    [logout setHidden:YES];
    [logout setFrame:CGRectMake(WIDTH(15), HEIGHT(10), SCREEN_WIDTH - WIDTH(30), buttonH)];
    [logout setTitle:@"註銷登錄" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [logout.layer setMasksToBounds:YES];
    [logout.layer setCornerRadius:HEIGHT(5)];
    [logout setBackgroundColor:MAIN_COLOR];
    [logout addTarget:self action:@selector(logoutEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:logout];
    
    UserModel *model = [UserModel getCurrentUser];
    if (model) {
        [header refreshHeaderDataWithModel:model];
        [logout setHidden:NO];
    }
}

/** 用户登录成功时通知回调 */
- (void)userDidLoginSuccess:(NSNotification *)notification
{
    UserModel *model = (UserModel *)[[notification userInfo] objectForKey:@"userInfo"];
    MineHeadView *header = (MineHeadView *)[self.tableView tableHeaderView];
    [header refreshHeaderDataWithModel:model];
    [self.logoutBtn setHidden:NO];
}

#pragma mark - start 按钮事件监听
/** 注销事件 */
- (void)logoutEvent:(UIButton *)sender
{
    [UserDefaults setBool:NO forKey:USER_DIDLOGIN];
    [self.logoutBtn setHidden:YES];
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
    }
    cell.textLabel.text  = self.array[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:  // 我的资料
        {
            break;
        }
        case 1:  // 我的收藏
        {
            break;
        }
        case 2:  // 我的帖子
        {
            break;
        }
        case 3:  // 我的回复
        {
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
