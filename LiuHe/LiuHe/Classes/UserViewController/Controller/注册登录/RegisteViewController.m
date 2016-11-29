//
//  RegisteViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "RegisteViewController.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "XQTextField.h"
#import "XQToast.h"

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
    self.title = @"註冊賬號";
    self.navigationBar.imageView.alpha = 0;
    
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
    NSString *userName = self.userNameTF.text;
    NSString *password = self.pswTF.text;
    NSString *repsw    = self.confirmPswTF.text;
    NSString *phone    = self.accountTF.text;
    
    if ((!userName) || [userName isEqualToString:@""]) {
        [[XQToast makeText:@"請輸入用戶名"] show];
        return;
    }
    if ((!password) || [password isEqualToString:@""]) {
        [[XQToast makeText:@"請輸入密碼"] show];
        return;
    }
    if (![password isEqualToString:repsw]) {
        [[XQToast makeText:@"兩次輸入的密碼不同"] show];
        return;
    }
    
    [SVProgressHUD show];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager userRegisterWithUserName:userName
                             password:password
                           repassword:repsw
                                phone:phone
                                email:nil
                              success:^{
                                  [SVProgressHUD showSuccessWithStatus:@"恭喜您，会员注册成功"];
                                  [NotificationCenter postNotificationName:USER_REGISTER_SUCCESS object:nil userInfo:@{@"username" : userName}];
                                  [ws.navigationController popViewControllerAnimated:YES];
                              } failure:^(NSString *error) {
                                  [SVProgressHUD showErrorWithStatus:error];
                              }];
}

@end
