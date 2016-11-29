//
//  SettingViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImage+Extension.h"
#import "FeedBackViewController.h"
#import "AboutUsViewController.h"
#import "DisclaimerViewController.h"
#import "SystemManager.h"
#import "XQAlertView.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, weak) UIButton *logoutBtn;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    
    [self createTableView];
}

- (void)setNavigationBarStyle
{
    self.title = @"設置";
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

- (void)createTableView
{
    self.dataArray = @[@[@"免責聲明"], @[@"用户反饋"], @[@"關於應用"], @[@"清除緩存"]];
    CGFloat navigationBarH = 64;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarH, SCREEN_WIDTH, SCREEN_HEIGHT - navigationBarH)];
    self.tableView         = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.rowHeight    = HEIGHT(40);
    [tableView setScrollEnabled:NO];
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tableView];
    
    CGFloat buttonH  = HEIGHT(40);
    CGFloat buttonY  = SCREEN_HEIGHT - buttonH - HEIGHT(20);
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutBtn   = logout;
    [logout setFrame:CGRectMake(WIDTH(15), buttonY, SCREEN_WIDTH - WIDTH(30), buttonH)];
    [logout setTitle:@"註銷登錄" forState:UIControlStateNormal];
    [logout setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [logout.layer setMasksToBounds:YES];
    [logout.layer setCornerRadius:HEIGHT(5)];
    [logout addTarget:self action:@selector(logoutEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
    
    logout.hidden = ![UserDefaults boolForKey:USER_DIDLOGIN];
}

/** 注销事件 */
- (void)logoutEvent:(UIButton *)sender
{
    [UserDefaults setBool:NO forKey:USER_DIDLOGIN];
    [NotificationCenter postNotificationName:USER_LOGOUT_SUCCESS object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEIGHT(15);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!view) {
        view = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"header"];
    }
    [view.contentView setBackgroundColor:RGBCOLOR(245, 242, 241)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TableViewCellID";
    UITableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell.textLabel setFont:[UIFont systemFontOfSize:WIDTH(15)]];
    }
    if (indexPath.section != 3) {
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        UILabel *label = [cell viewWithTag:101];
        if (!label) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH(200), HEIGHT(44))];
            [label setTag:101];
            [label setTextAlignment:NSTextAlignmentRight];
        }
        label.text = [SystemManager getCacheSize];
        cell.accessoryView  = label;
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:  // 免责声明
        {
            DisclaimerViewController *vc = [[DisclaimerViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:  // 用户反馈
        {
            FeedBackViewController *vc = [[FeedBackViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:  // 关于应用
        {
            AboutUsViewController *vc = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:  // 清除缓存
        {
            XQAlertView *alert = [[XQAlertView alloc] initWithTitle:@"提示" message:@"確定要清楚緩存嗎？"];
            alert.themeColor   = MAIN_COLOR;
            alert.titleColor   = [UIColor whiteColor];
            [alert addButtonWithTitle:@"再想一想" style:XQAlertButtonStyleCancel handle:nil];
            [alert addButtonWithTitle:@"確定" style:XQAlertButtonStyleDefault handle:^{
                [SystemManager clearCache];
                [tableView reloadData];
            }];
            [alert show];
            break;
        }
        default:
            break;
    }
}
#pragma mark end UITableViewDelegate, UITableViewDataSource
@end
