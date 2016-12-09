//
//  RegisteViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
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

@property (nonatomic, weak) UIView *contentView;

@end

@implementation RegisteViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
    NSLog(@"RegisteViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNotification];
    
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

- (void)addNotification
{
    [NotificationCenter addObserver:self
                           selector:@selector(keyboardWillShow:)
                               name:UIKeyboardWillShowNotification
                             object:nil];
    
    [NotificationCenter addObserver:self
                           selector:@selector(keyboardWillHide:)
                               name:UIKeyboardWillHideNotification
                             object:nil];
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
    CGFloat viewY = 64 + HEIGHT(70);
    CGFloat viewH = tfH * 4 + HEIGHT(10) * 3;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    self.contentView  = view;
    [self.view insertSubview:view belowSubview:self.navigationBar];
    
    CGFloat userNameX = WIDTH(50);
    CGFloat userNameW = SCREEN_WIDTH - userNameX * 2;
    self.userNameTF   = [self createTFWithFrame:CGRectMake(userNameX, 0, userNameW, tfH)
                                    placeholder:@"請輸入用户名"
                                      leftImage:[UIImage imageNamed:@"user_name_text_field"]];
    
    CGFloat pswY = CGRectGetMaxY(self.userNameTF.frame) + HEIGHT(10);
    self.pswTF   = [self createTFWithFrame:CGRectMake(userNameX, pswY, userNameW, tfH)
                               placeholder:@"請輸入密碼"
                                 leftImage:[UIImage imageNamed:@"password_text_field"]];
    [self.pswTF setSecureTextEntry:YES];
    
    CGFloat confirmY  = CGRectGetMaxY(self.pswTF.frame) + HEIGHT(10);
    self.confirmPswTF = [self createTFWithFrame:CGRectMake(userNameX, confirmY, userNameW, tfH)
                                    placeholder:@"請再次輸入密碼"
                                      leftImage:[UIImage imageNamed:@"password_text_field"]];
    [self.confirmPswTF setSecureTextEntry:YES];
    
    CGFloat accountY = CGRectGetMaxY(self.confirmPswTF.frame) + HEIGHT(10);
    self.accountTF   = [self createTFWithFrame:CGRectMake(userNameX, accountY, userNameW, tfH)
                                   placeholder:@"請輸入手機號碼"
                                     leftImage:[UIImage imageNamed:@"account_text_field"]];
    [self.accountTF setKeyboardType:UIKeyboardTypePhonePad];
    
    // 注册按钮
    CGFloat regBtnY  = CGRectGetMaxY(self.contentView.frame) + HEIGHT(50);
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
    [self.contentView addSubview:textField];
    
    CGFloat lineY = CGRectGetMaxY(textField.frame);
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, lineY, frame.size.width, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:line];
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
    
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager userRegisterWithUserName:userName
                             password:password
                           repassword:repsw
                                phone:phone
                                email:nil
                              success:^{
                                  [hud hideAnimated:YES];
                                  [MBProgressHUD showSuccessInView:KeyWindow mesg:@"恭喜您，会员注册成功"];
                                  [NotificationCenter postNotificationName:USER_REGISTER_SUCCESS object:nil userInfo:@{@"username" : userName}];
                                  [ws.navigationController popViewControllerAnimated:YES];
                              } failure:^(NSString *error) {
                                  [hud hideAnimated:YES];
                                  [MBProgressHUD showFailureInView:KeyWindow mesg:error];
                              }];
}

#pragma mark - start 键盘展示和消失通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect  frame  = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    
    self.contentView.transform = CGAffineTransformIdentity;
    CGFloat keyBoardMinY = SCREEN_HEIGHT - height;
    CGFloat distance     = 0;
    if ([self.userNameTF.textField isFirstResponder]) {
        CGRect mFrame = [self.contentView convertRect:self.userNameTF.frame toView:self.view];
        CGFloat userMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < userMaxY) {
            distance  = keyBoardMinY - userMaxY;
        }
    }else if ([self.pswTF.textField isFirstResponder]) {
        CGRect mFrame   = [self.contentView convertRect:self.pswTF.frame toView:self.view];
        CGFloat pswMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < pswMaxY) {
            distance  = keyBoardMinY - pswMaxY;
        }
    }else if ([self.confirmPswTF.textField isFirstResponder]) {
        CGRect mFrame     = [self.contentView convertRect:self.confirmPswTF.frame toView:self.view];
        CGFloat rePswMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < rePswMaxY) {
            distance   = keyBoardMinY - rePswMaxY;
        }
    }else {
        CGRect mFrame    = [self.contentView convertRect:self.accountTF.frame toView:self.view];
        CGFloat accMaxY  = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < accMaxY) {
            distance   = keyBoardMinY - accMaxY;
        }
    }
    [UIView animateWithDuration:animateTime animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, distance);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animateTime animations:^{
        self.contentView.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark end 键盘展示和消失通知事件
@end
