//
//  LoginViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "LoginViewController.h"
#import "XQTextField.h"
#import "UIImage+Extension.h"
#import "RegisteViewController.h"

@interface LoginViewController ()

@property (nonatomic, weak) XQTextField *accountTF;

@property (nonatomic, weak) XQTextField *passwordTF;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createBackgroundView];
    [self createView];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar = YES;
    self.title = @"登錄";
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
    CGFloat tfH = HEIGHT(30);
    
    CGFloat accountTFX     = WIDTH(50);
    CGFloat accountTFW     = SCREEN_WIDTH - accountTFX * 2;
    CGFloat accountTFY     = 64 + HEIGHT(100);
    XQTextField *accountTF = [[XQTextField alloc] initWithFrame:CGRectMake(accountTFX, accountTFY, accountTFW, tfH)];
    self.accountTF         = accountTF;
    accountTF.borderStyle  = UITextBorderStyleNone;
    accountTF.placeholder  = @"賬戶";
    accountTF.textColor    = [UIColor whiteColor];
    accountTF.font         = [UIFont systemFontOfSize:fontSize(15)];
    accountTF.leftViewMode = UITextFieldViewModeAlways;
    accountTF.leftImage    = [UIImage imageNamed:@"user_name_text_field"];
    [accountTF setPlaceholderColor:[UIColor whiteColor]];
    [self.view addSubview:accountTF];
    
    CGFloat lineY = CGRectGetMaxY(accountTF.frame);
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(accountTFX, lineY, accountTFW, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    CGFloat pswTFY     = CGRectGetMaxY(line.frame) + HEIGHT(3);
    XQTextField *pswTF = [[XQTextField alloc] initWithFrame:CGRectMake(accountTFX, pswTFY, accountTFW, tfH)];
    self.passwordTF    = pswTF;
    pswTF.borderStyle  = UITextBorderStyleNone;
    pswTF.placeholder  = @"密碼";
    pswTF.textColor    = [UIColor whiteColor];
    pswTF.font         = [UIFont systemFontOfSize:fontSize(15)];
    pswTF.leftViewMode = UITextFieldViewModeAlways;
    pswTF.leftImage    = [UIImage imageNamed:@"password_text_field"];
    [pswTF setPlaceholderColor:[UIColor whiteColor]];
    [pswTF setSecureTextEntry:YES];
    [self.view addSubview:pswTF];
    
    lineY = CGRectGetMaxY(pswTF.frame);
    line  = [[UIView alloc] initWithFrame:CGRectMake(accountTFX, lineY, accountTFW, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    
    // 登录按钮
    CGFloat buttonH    = HEIGHT(36);
    CGFloat loginBtnY  = CGRectGetMaxY(line.frame) + HEIGHT(70);
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame     = CGRectMake(accountTFX, loginBtnY, accountTFW, buttonH);
    [loginBtn setTitle:@"登錄" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize(15)]];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:buttonH * 0.5];
    [loginBtn addTarget:self action:@selector(loginEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    // 注册按钮
    CGFloat regBtnY  = CGRectGetMaxY(loginBtn.frame) + HEIGHT(20);
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame     = CGRectMake(accountTFX, regBtnY, accountTFW, buttonH);
    [regBtn setTitle:@"註冊賬號" forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize(15)]];
    [regBtn.layer setMasksToBounds:YES];
    [regBtn.layer setCornerRadius:buttonH * 0.5];
    [regBtn addTarget:self action:@selector(registeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
}

- (void)loginEvent:(UIButton *)sender
{
    NSLog(@"loginEvent");
}

- (void)registeEvent:(UIButton *)sender
{
    RegisteViewController *regVC = [[RegisteViewController alloc] init];
    [self.navigationController pushViewController:regVC animated:YES];
}
@end
