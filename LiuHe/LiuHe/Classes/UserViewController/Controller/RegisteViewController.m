//
//  RegisteViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "RegisteViewController.h"
#import "UIImage+Extension.h"
#import "XQTextField.h"

@interface RegisteViewController ()

@property (nonatomic, weak) XQTextField *userNameTF;

@property (nonatomic, weak) XQTextField *pswTF;

@property (nonatomic, weak) XQTextField *confirmPswTF;

@property (nonatomic, weak) XQTextField *accountTF;

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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
    
    CGFloat userNameX = WIDTH(50);
    CGFloat userNameY = 64 + HEIGHT(72);
    CGFloat userNameW = SCREEN_WIDTH - userNameX * 2;
    XQTextField *textField = [self createTFWithFrame:CGRectMake(userNameX, userNameY, userNameW, tfH)
                                         placeholder:@"請輸入用户名"
                                           leftImage:[UIImage imageNamed:@"user_name_text_field"]];
    self.userNameTF        = textField;
    [self.view addSubview:textField];
    
    CGFloat pswY = CGRectGetMaxY(textField.frame) + HEIGHT(10);
    textField    = [self createTFWithFrame:CGRectMake(userNameX, pswY, userNameW, tfH)
                               placeholder:@"請輸入密碼"
                                 leftImage:[UIImage imageNamed:@"password_text_field"]];
    self.pswTF   = textField;
    [textField setSecureTextEntry:YES];
    [self.view addSubview:textField];
    
    CGFloat confirmY  = CGRectGetMaxY(textField.frame) + HEIGHT(10);
    textField         = [self createTFWithFrame:CGRectMake(userNameX, confirmY, userNameW, tfH)
                                    placeholder:@"請再次輸入密碼"
                                      leftImage:[UIImage imageNamed:@"password_text_field"]];
    self.confirmPswTF = textField;
    [textField setSecureTextEntry:YES];
    [self.view addSubview:textField];
    
    CGFloat accountY = CGRectGetMaxY(textField.frame) + HEIGHT(10);
    textField        = [self createTFWithFrame:CGRectMake(userNameX, accountY, userNameW, tfH)
                                   placeholder:@"請輸入手機號碼"
                                     leftImage:[UIImage imageNamed:@"account_text_field"]];
    self.accountTF   = textField;
    [self.view addSubview:textField];
    
    // 注册按钮
    CGFloat regBtnY  = CGRectGetMaxY(textField.frame) + HEIGHT(50);
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    regBtn.frame     = CGRectMake(userNameX, regBtnY, userNameW, HEIGHT(36));
    [regBtn setTitle:@"註冊" forState:UIControlStateNormal];
    [regBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [regBtn setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateHighlighted];
    [regBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize(15)]];
    [regBtn.layer setMasksToBounds:YES];
    [regBtn.layer setCornerRadius:HEIGHT(18)];
    [regBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [regBtn.layer setBorderWidth:1];
    [regBtn addTarget:self action:@selector(registeEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
}

- (XQTextField *)createTFWithFrame:(CGRect)frame placeholder:(NSString *)placeholder leftImage:(UIImage *)leftImage
{
    XQTextField *textField = [[XQTextField alloc] initWithFrame:frame];
    textField.borderStyle  = UITextBorderStyleNone;
    textField.placeholder  = placeholder;
    textField.textColor    = [UIColor whiteColor];
    textField.font         = [UIFont systemFontOfSize:fontSize(15)];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftImage    = leftImage;
    [textField setPlaceholderColor:[UIColor whiteColor]];
    
    CGFloat lineY = CGRectGetMaxY(textField.frame);
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, lineY, frame.size.width, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:line];
    return textField;
}

- (void)registeEvent:(UIButton *)sender
{
    NSLog(@"registeEvent");
}

@end
