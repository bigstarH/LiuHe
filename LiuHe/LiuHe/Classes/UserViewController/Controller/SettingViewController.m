//
//  SettingViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 245, 245);
    
    [self createTableView];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar   = YES;
    self.navigationBar.shadowHidden = YES;
    self.title = @"設置";
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

- (UIColor *)setBarTintColor
{
    return MAIN_COLOR;
}

- (void)createTableView
{
    self.dataArray = @[@"免責聲明", @"用户反饋", @"關於應用", @"清除緩存"];
    CGFloat navigationBarH = 64;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navigationBarH, SCREEN_WIDTH, SCREEN_HEIGHT - navigationBarH)];
    self.tableView         = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [self.view addSubview:tableView];
}

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
#pragma mark end UITableViewDelegate, UITableViewDataSource
@end
