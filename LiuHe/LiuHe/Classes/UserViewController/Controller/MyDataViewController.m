//
//  MyDataViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MyDataViewController.h"

@interface MyDataViewController ()

@end

@implementation MyDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    
    [self createView];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar   = YES;
    self.title = @"我的資料";
    self.navigationBar.shadowHidden = YES;
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

- (UIColor *)setBarTintColor
{
    return MAIN_COLOR;
}

- (void)createView
{
    // 头像
    CGFloat originY = 64 + HEIGHT(12);
    CGFloat viewH   = HEIGHT(80);
    UIView *view    = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, viewH)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    
    
}

@end
