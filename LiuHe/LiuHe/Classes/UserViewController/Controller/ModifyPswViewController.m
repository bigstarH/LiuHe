//
//  ModifyPswViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/25.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ModifyPswViewController.h"
#import "MBProgressHUD+Extension.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "UserModel.h"
#import "XQTextField.h"

@interface ModifyPswViewController ()
/** 原密码框 */
@property (nonatomic, weak) XQTextField *oldPswTF;
/** 新密码框 */
@property (nonatomic, weak) XQTextField *pswTF;
/** 确认密码框 */
@property (nonatomic, weak) XQTextField *rePswTF;

@property (nonatomic, weak) UIView *contentView;

@end

@implementation ModifyPswViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
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
    self.title = @"修改密碼";
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
    if (!([self.oldPswTF isExclusiveTouch] ||
         [self.rePswTF isExclusiveTouch]  ||
         [self.pswTF isExclusiveTouch])) {
        [self.view endEditing:YES];
    }
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
    CGFloat tfH   = HEIGHT(30);
    CGFloat viewY = 64 + HEIGHT(100);
    CGFloat viewH = tfH * 3 + HEIGHT(3) * 2;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    self.contentView  = view;
    [self.view insertSubview:view belowSubview:self.navigationBar];
    
    CGFloat passwordX = WIDTH(50);
    CGFloat passwordW = SCREEN_WIDTH - passwordX * 2;
    CGRect frame      = CGRectMake(passwordX, 0, passwordW, tfH);
    self.oldPswTF     = [self createTFWithFrame:frame
                                    placeholder:@"請輸入原密碼"
                                      leftImage:[UIImage imageNamed:@"password_text_field"]];
    
    CGFloat upPswY    = CGRectGetMaxY(self.oldPswTF.frame) + HEIGHT(3);
    frame             = CGRectMake(passwordX, upPswY, passwordW, tfH);
    self.pswTF        = [self createTFWithFrame:frame
                                    placeholder:@"請輸入新密碼"
                                      leftImage:[UIImage imageNamed:@"password_text_field"]];
    
    CGFloat confirmY  = CGRectGetMaxY(self.pswTF.frame) + HEIGHT(3);
    frame             = CGRectMake(passwordX, confirmY, passwordW, tfH);
    self.rePswTF      = [self createTFWithFrame:frame
                                    placeholder:@"請再次輸入新密碼"
                                      leftImage:[UIImage imageNamed:@"password_text_field"]];
    
    // 登录按钮
    CGFloat buttonH        = HEIGHT(36);
    CGFloat modifyPswY     = CGRectGetMaxY(self.contentView.frame) + HEIGHT(70);
    UIButton *modifyPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    modifyPswBtn.frame     = CGRectMake(passwordX, modifyPswY, passwordW, buttonH);
    [modifyPswBtn setTitle:@"修改密碼" forState:UIControlStateNormal];
    [modifyPswBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyPswBtn setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateHighlighted];
    [modifyPswBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize(15)]];
    [modifyPswBtn.layer setMasksToBounds:YES];
    [modifyPswBtn.layer setCornerRadius:buttonH * 0.5];
    [modifyPswBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [modifyPswBtn.layer setBorderWidth:1];
    [modifyPswBtn addTarget:self action:@selector(modifyPsw:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modifyPswBtn];
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
    [textField setSecureTextEntry:YES];
    [self.contentView addSubview:textField];
    
    CGFloat lineY = CGRectGetMaxY(textField.frame) - 1;
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, lineY, frame.size.width, 1)];
    [line setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:line];
    return textField;
}

/** 修改密码按钮点击事件 */
- (void)modifyPsw:(UIButton *)sender
{
    NSString *oldPsw = self.oldPswTF.text;
    if ((!oldPsw) || [oldPsw isEqualToString:@""]) {
        [MBProgressHUD showFailureInView:self.view mesg:@"請輸入原密碼"];
        return;
    }
    NSString *psw    = self.pswTF.text;
    if ((!psw) || [psw isEqualToString:@""]) {
        [MBProgressHUD showFailureInView:self.view mesg:@"請輸入新密碼"];
        return;
    }
    NSString *rePsw  = self.rePswTF.text;
    if ((!rePsw) || [rePsw isEqualToString:@""]) {
        [MBProgressHUD showFailureInView:self.view mesg:@"兩次輸入的密碼不同"];
        return;
    }
    if (![psw isEqualToString:rePsw]) {
        [MBProgressHUD showFailureInView:self.view mesg:@"兩次輸入的密碼不同"];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager modifyPswWithOldPsw:oldPsw
                             psw:psw
                      confirmPsw:rePsw
                         success:^(NSString *userName, NSString *ts) {
                             [hud hideAnimated:YES];
                             [MBProgressHUD showSuccessInView:KeyWindow mesg:ts];
                             [NotificationCenter postNotificationName:USER_MODIFYPSW_SUCCESS object:nil userInfo:@{@"username" : userName}];
                             [ws.navigationController popViewControllerAnimated:YES];
                         } failure:^(NSString *error) {
                             [hud hideAnimated:YES];
                             [MBProgressHUD showFailureInView:ws.view mesg:error];
                         }];
}

#pragma mark - start 键盘展示和消失通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.contentView.transform      = CGAffineTransformIdentity;
    
    CGRect  frame  = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height;
    
    CGFloat keyBoardMinY = SCREEN_HEIGHT - height;
    CGFloat distance     = 0;
    if ([self.oldPswTF.textField isFirstResponder]) {
        CGRect mFrame = [self.contentView convertRect:self.oldPswTF.frame toView:self.view];
        CGFloat oldPswMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < oldPswMaxY) {
            distance  = keyBoardMinY - oldPswMaxY;
        }
    }else if ([self.pswTF.textField isFirstResponder]) {
        CGRect mFrame   = [self.contentView convertRect:self.pswTF.frame toView:self.view];
        CGFloat pswMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < pswMaxY) {
            distance  = keyBoardMinY - pswMaxY;
        }
    }else {
        CGRect mFrame     = [self.contentView convertRect:self.rePswTF.frame toView:self.view];
        CGFloat rePswMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < rePswMaxY) {
            distance   = keyBoardMinY - rePswMaxY;
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
        self.contentView.transform      = CGAffineTransformIdentity;
    }];
}
#pragma mark end 键盘展示和消失通知事件
@end
