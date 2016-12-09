//
//  FeedBackViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/11/26.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "FeedBackViewController.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "XQTextView.h"
#import "XQToast.h"

@interface FeedBackViewController ()

@property (nonatomic, weak) UITextField *nameTF;

@property (nonatomic, weak) UITextField *phoneTF;

@property (nonatomic, weak) XQTextView *contentTV;

@property (nonatomic, weak) UIView *keyBoardToolBar;

@end

@implementation FeedBackViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    
    [self addNotification];
    
    [self createView];
}

- (void)setNavigationBarStyle
{
    self.title = @"用戶反饋";
    
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

- (void)createView
{
    CGFloat originY = 64 + HEIGHT(15);
    CGFloat tfH     = HEIGHT(35);
    CGRect frame    = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
    self.nameTF     = [self createTFWithFrame:frame placeholder:@"請輸入您的稱呼"];
    
    originY     += tfH;
    frame        = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
    self.phoneTF = [self createTFWithFrame:frame placeholder:@"請輸入手機號碼"];
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    
    originY += tfH;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, HEIGHT(120))];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    CGFloat contentTVX    = WIDTH(9);
    CGFloat contentTVW    = SCREEN_WIDTH - contentTVX * 2;
    XQTextView *contentTV = [[XQTextView alloc] initWithFrame:CGRectMake(contentTVX, 0, contentTVW, HEIGHT(120))];
    self.contentTV        = contentTV;
    contentTV.placeholder = @"請輸入反饋內容";
    contentTV.font        = [UIFont systemFontOfSize:fontSize(15)];
    [contentTV setPlaceholderColor:[UIColor lightGrayColor]];
    [contentTV setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [view addSubview:contentTV];
    
    // 修改资料按钮
    CGFloat buttonH     = HEIGHT(40);
    CGFloat buttonY     = SCREEN_HEIGHT - buttonH - HEIGHT(20);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(WIDTH(15), buttonY, SCREEN_WIDTH - WIDTH(30), buttonH)];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:HEIGHT(5)];
    [submitBtn addTarget:self action:@selector(submitEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    // 键盘上方的ToolBar
    CGFloat barH    = HEIGHT(38);
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, barH)];
    self.keyBoardToolBar = toolBar;
    [toolBar setBackgroundColor:RGBCOLOR(235, 235, 235)];
    [self.view addSubview:toolBar];
    
    CGFloat buttonW   = WIDTH(65);
    CGFloat sureBtnX  = SCREEN_WIDTH - buttonW;
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:fontSize(15)]];
    [sureBtn setFrame:CGRectMake(sureBtnX, 0, buttonW, barH)];
    [sureBtn addTarget:self action:@selector(sureEvent:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:sureBtn];
}

- (UITextField *)createTFWithFrame:(CGRect)frame placeholder:(NSString *)placeholder
{
    UITextField *textField  = [[UITextField alloc] initWithFrame:frame];
    textField.leftViewMode  = UITextFieldViewModeAlways;
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.placeholder   = placeholder;
    textField.font          = [UIFont systemFontOfSize:fontSize(15)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:textField];
    
    UIView *leftView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(12), frame.size.height)];
    textField.leftView  = leftView;
    UIView *rightView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(12), frame.size.height)];
    textField.rightView = rightView;
    
    CGFloat lineW = frame.size.width - WIDTH(24);
    CGFloat lineY = CGRectGetMaxY(frame) - 1;
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(12), lineY, lineW, 1)];
    [line setBackgroundColor:RGBCOLOR(203, 203, 203)];
    [self.view addSubview:line];
    return textField;
}

#pragma mark - start 按钮点击事件
/** “提交”按钮事件 */
- (void)submitEvent:(UIButton *)sender
{
    if ((!self.nameTF.text) || [self.nameTF.text isEqualToString:@""]) {
        [[XQToast makeText:@"稱呼是必填的哦"] show];
        return;
    }
    if ((!self.phoneTF.text) || [self.phoneTF.text isEqualToString:@""]) {
        [[XQToast makeText:@"手機號碼是必填的哦"] show];
        return;
    }
    if ((!self.contentTV.text) || [self.contentTV.text isEqualToString:@""]) {
        [[XQToast makeText:@"反饋內容是必填的哦"] show];
        return;
    }
    if (![self isValidateMobile:self.phoneTF.text]) {
        [[XQToast makeText:@"請輸入正確的手機號碼"] show];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] userFeedBackWithName:self.nameTF.text
                                                  phone:self.phoneTF.text
                                                content:self.contentTV.text
                                                success:^(NSString *str) {
                                                    [hud hideAnimated:YES];
                                                    [MBProgressHUD showSuccessInView:ws.view mesg:str];
                                                    [ws.navigationController popViewControllerAnimated:YES];
                                                } failure:^(NSString *error) {
                                                    [hud hideAnimated:YES];
                                                    [MBProgressHUD showFailureInView:ws.view mesg:error];
                                                }];
}

- (void)sureEvent:(UIButton *)sender
{
    [self.view endEditing:YES];
}
#pragma mark end 按钮点击事件

#pragma mark - start 私有方法
/** 手机号码是否是有效的 */
- (BOOL)isValidateMobile:(NSString *)mobile
{
    //手机号以13、15、18开头，八个\d数字字符
    NSString *phoneRegex = @"^(14[0-9]||(17[0-9])|(13[0-9])|(15[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
#pragma mark - start 私有方法

#pragma mark - start 键盘展示和消失通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect  frame  = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = frame.size.height + self.keyBoardToolBar.bounds.size.height;
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark end 键盘展示和消失通知事件

@end
