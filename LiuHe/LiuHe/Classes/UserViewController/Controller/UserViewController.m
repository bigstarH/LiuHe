//
//  UserViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "MineHeadView.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource, MineHeadViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

- (void)setNavigationBarStyle
{
    [super setNavigationBarStyle];
    self.navigationController.navigationBar.hidden = YES;
    self.needsCustomNavigationBar      = YES;
    self.title = @"我的";
    self.navigationBar.shadowHidden    = YES;
    self.navigationBar.imageView.alpha = 0;
    self.navigationBar.mOpaque         = 64;
    
    XQBarButtonItem *rightBtn1 = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"SignIn"]];
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

- (void)createView
{
    self.array = @[@"我的資料", @"我的收藏", @"我的帖子", @"我的回復", @"設置"];
    
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
    [logout setFrame:CGRectMake(WIDTH(15), HEIGHT(10), SCREEN_WIDTH - WIDTH(30), buttonH)];
    [logout setTitle:@"註銷登錄" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [logout.layer setMasksToBounds:YES];
    [logout.layer setCornerRadius:HEIGHT(5)];
    [logout setBackgroundColor:MAIN_COLOR];
    [logout addTarget:self action:@selector(logoutEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:logout];
}

- (void)logoutEvent:(UIButton *)sender
{
    NSLog(@"logoutEvent");
}

- (void)barButtonItemEvent:(XQBarButtonItem *)sender
{
    if (sender.tag == 1) {  // 签到
        
    }else {  // 发帖
        
    }
}

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
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
