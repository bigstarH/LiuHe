//
//  RegisteViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "RegisteViewController.h"

@interface RegisteViewController ()

@end

@implementation RegisteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBackgroundView];
    [self createView];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar = YES;
    self.title = @"註冊賬號";
    self.navigationBar.imageView.alpha  = 0;
    self.navigationBar.shadowHidden     = YES;
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

- (void)createBackgroundView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    imageView.image        = [UIImage imageNamed:@"denglubeijingtu"];
    [self.view insertSubview:imageView belowSubview:self.navigationBar];
}

- (void)createView
{
    
}

@end
