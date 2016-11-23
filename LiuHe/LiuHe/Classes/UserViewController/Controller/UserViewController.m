//
//  UserViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "UserViewController.h"
#import "ForumViewController.h"
#import "MineHeadView.h"

@interface UserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@end

@implementation UserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self createView];
}

- (void)setNavigationBar
{
    self.navigationController.navigationBar.hidden = YES;
    self.needsCustomNavigationBar      = YES;
    self.title = @"我的";
    self.navigationBar.shadowHidden    = YES;
    self.navigationBar.imageView.alpha = 0;
    self.navigationBar.mOpaque         = 64;
    
    XQBarButtonItem *rightBtn1 = [[XQBarButtonItem alloc] initWithTitle:@"修改信息"];
    [rightBtn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    XQBarButtonItem *rightBtn2 = [[XQBarButtonItem alloc] initWithTitle:@"发帖"];
    [rightBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.navigationBar.rightBarButtonItems = @[rightBtn1, rightBtn2];
    
    XQBarButtonItem *leftBtn   = [[XQBarButtonItem alloc] initWithTitle:@"签到"];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
}

- (UIColor *)setBarTintColor
{
    return [UIColor redColor];
}

- (void)createView
{
    self.array = @[@"我的资料", @"我的收藏", @"我的帖子", @"我的回复", @"设置"];
    
    CGFloat buttonH        = HEIGHT(40);
    MineHeadView *header   = [[MineHeadView alloc] initWithFrame:CGRectMake(0, 0, 0, HEIGHT(235))];
    UIView *footer         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, buttonH + HEIGHT(20))];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 49)];
    _tableView             = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    tableView.rowHeight    = HEIGHT(50);
    [tableView setTableHeaderView:header];
    [tableView setTableFooterView:footer];
    [self.view insertSubview:tableView belowSubview:self.navigationBar];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    [logout setFrame:CGRectMake(WIDTH(15), HEIGHT(10), self.view.bounds.size.width - WIDTH(30), buttonH)];
    [logout setTitle:@"註銷登錄" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor yellowColor] forState:UIControlStateHighlighted];
    [logout setBackgroundColor:[UIColor redColor]];
    [logout addTarget:self action:@selector(logoutEvent:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:logout];
}

- (void)logoutEvent:(UIButton *)sender
{
    NSLog(@"logoutEvent");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

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
