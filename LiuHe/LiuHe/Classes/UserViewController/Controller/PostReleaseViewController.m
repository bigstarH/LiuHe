//
//  PostReleaseViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "PostReleaseViewController.h"
#import "MBProgressHUD+Extension.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "XQTextView.h"
#import "XQToast.h"

@interface PostReleaseViewController ()

@property (nonatomic, weak) UITextField *titleTF;

@property (nonatomic, weak) XQTextView *contentTV;

@property (nonatomic, weak) UIView *keyBoardToolBar;

@property (nonatomic, weak) UIView *contentView;

@end

@implementation PostReleaseViewController

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
    
    if (self.type == VCTypePostEdit) {
        [self getMyPostDetail];
    }
}

- (void)setNavigationBarStyle
{
    if (self.type == VCTypePostNew) {
        self.title = @"發表帖子";
    }else {
        self.title = @"我的帖子";
    }
    
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
    CGFloat originY  = 64 + HEIGHT(18);
    CGFloat tfH      = HEIGHT(36);
    CGFloat tvH      = HEIGHT(120);
    CGFloat viewH    = tfH + tvH;
    UIView *view     = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, viewH)];
    self.contentView = view;
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:view belowSubview:self.navigationBar];
    
    CGRect frame     = CGRectMake(0, 0, SCREEN_WIDTH, tfH);
    self.titleTF     = [self createTFWithFrame:frame placeholder:@"請輸入標題"];
    
    CGFloat contentTVX    = WIDTH(9);
    CGFloat contentTVW    = SCREEN_WIDTH - contentTVX * 2;
    XQTextView *contentTV = [[XQTextView alloc] initWithFrame:CGRectMake(contentTVX, tfH, contentTVW, tvH)];
    self.contentTV        = contentTV;
    contentTV.placeholder = @"請輸入內容";
    contentTV.font        = [UIFont systemFontOfSize:fontSize(15)];
    [contentTV setPlaceholderColor:[UIColor lightGrayColor]];
    [contentTV setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [view addSubview:contentTV];
    
    // 修改资料按钮
    CGFloat buttonH     = HEIGHT(40);
    CGFloat buttonY     = SCREEN_HEIGHT - buttonH - HEIGHT(30);
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setFrame:CGRectMake(WIDTH(15), buttonY, SCREEN_WIDTH - WIDTH(30), buttonH)];
    [submitBtn setTitle:@"發佈" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [submitBtn.layer setMasksToBounds:YES];
    [submitBtn.layer setCornerRadius:HEIGHT(5)];
    [submitBtn addTarget:self action:@selector(releaseEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.contentView addSubview:textField];
    
    UIView *leftView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(12), frame.size.height)];
    textField.leftView  = leftView;
    UIView *rightView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(12), frame.size.height)];
    textField.rightView = rightView;
    
    CGFloat lineW = frame.size.width - WIDTH(24);
    CGFloat lineY = CGRectGetMaxY(frame) - 1;
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(12), lineY, lineW, 1)];
    [line setBackgroundColor:RGBCOLOR(203, 203, 203)];
    [self.contentView addSubview:line];
    return textField;
}

#pragma mark - start 按钮点击事件
- (void)releaseEvent:(UIButton *)sender
{
    if ((!self.titleTF.text) || [self.titleTF.text isEqualToString:@""]) {
        [[XQToast makeText:@"標題不能為空哦"] show];
        return;
    }
    if ((!self.contentTV.text) || [self.contentTV.text isEqualToString:@""]) {
        [[XQToast makeText:@"內容不能為空哦"] show];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    NSString *enews = self.type == VCTypePostNew ? @"AppMAddInfo" : @"AppMEditInfo";
    NSString *sid   = self.type == VCTypePostNew ? nil : self.sid;
    [manager postReleaseWithEnews:enews
                              sid:sid
                            title:self.titleTF.text
                          content:self.contentTV.text
                          success:^(NSString *str) {
                              [hud hideAnimated:YES];
                              [MBProgressHUD showSuccessInView:ws.view mesg:str];
                              if (ws.type == VCTypePostEdit) {
                                  [NotificationCenter postNotificationName:POST_EDIT_SUCCESS object:nil userInfo:nil];
                              }
                              [ws.navigationController popViewControllerAnimated:YES];
                          } failure:^(NSString *error) {
                              [hud hideAnimated:YES];
                              [MBProgressHUD showSuccessInView:ws.view mesg:error];
                          }];
}

- (void)sureEvent:(UIButton *)sender
{
    [self.view endEditing:YES];
}
#pragma mark end 按钮点击事件

#pragma mark - start 获取“我的帖子”详情
- (void)getMyPostDetail
{
    NSString *enews = @"MybbsE1";
    if (self.status == 1) {
        enews = @"MybbsE";
    }
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager userPostDetailWithEnews:enews
                                 sid:self.sid
                             success:^(NSDictionary *dict) {
                                 [hud hideAnimated:YES];
                                 NSString *title   = dict[@"bt"];
                                 NSString *content = dict[@"nr"];
                                 ws.titleTF.text   = title;
                                 ws.contentTV.text = content;
                             } failure:^(NSString *error) {
                                 [hud hideAnimated:YES];
                                 [MBProgressHUD showSuccessInView:ws.view mesg:error];
                             }];
}
#pragma mark end 获取“我的帖子”详情

#pragma mark - start 键盘展示和消失通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect  frame  = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = frame.size.height + self.keyBoardToolBar.bounds.size.height;
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
    
    if ([self.titleTF isFirstResponder]) {
        CGRect mFrame = [self.contentView convertRect:self.titleTF.frame toView:self.view];
        CGFloat contentMaxY  = CGRectGetMaxY(mFrame);
        CGFloat keyBoardMinY = SCREEN_HEIGHT - height;
        CGFloat dis          = keyBoardMinY - contentMaxY;
        if (dis < 0) {
            [UIView animateWithDuration:animateTime animations:^{
                self.contentView.transform = CGAffineTransformMakeTranslation(0, dis);
            }];
        }
    }else {
        CGRect mFrame = [self.contentView convertRect:self.contentTV.frame toView:self.view];
        CGFloat contentMaxY  = CGRectGetMaxY(mFrame);
        CGFloat keyBoardMinY = SCREEN_HEIGHT - height;
        CGFloat dis          = keyBoardMinY - contentMaxY;
        if (dis < 0) {
            [UIView animateWithDuration:animateTime animations:^{
                self.contentView.transform = CGAffineTransformMakeTranslation(0, dis);
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform = CGAffineTransformIdentity;
        self.contentView.transform     = CGAffineTransformIdentity;
    }];
}
#pragma mark end 键盘展示和消失通知事件
@end
