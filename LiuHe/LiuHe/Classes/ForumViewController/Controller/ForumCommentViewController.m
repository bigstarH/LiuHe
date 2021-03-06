//
//  ForumCommentViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ForumCommentViewController.h"
#import "MBProgressHUD+Extension.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "XQTextView.h"
#import "XQToast.h"

@interface ForumCommentViewController ()

@property (nonatomic, copy) NSString *linkid;

@property (nonatomic, weak) UITextField *titleTF;

@property (nonatomic, weak) XQTextView *contentTV;

@property (nonatomic, weak) UIView *keyBoardToolBar;

@end

@implementation ForumCommentViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    [self addNotification];
    [self createView];
    
    if (self.type == FCVCTypeEdit) {
        [self getCommentDetail];
    }
}

- (void)setNavigationBarStyle
{
    if (self.type == FCVCTypeNew) {
        self.title = @"回復帖子";
    }else {
        self.title = @"我的回復";
    }
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

#pragma mark - start 初始化控件
- (void)createView
{
    CGFloat originY   = 64 + HEIGHT(18);
    CGFloat tfH       = HEIGHT(36);
    CGRect frame      = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
    self.titleTF      = [self createTFWithFrame:frame placeholder:@""];
    self.titleTF.text = self.mTitle;
    self.titleTF.enabled = NO;
    
    originY += tfH;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, HEIGHT(130))];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:view belowSubview:self.navigationBar];
    CGFloat contentTVX    = WIDTH(9);
    CGFloat contentTVW    = SCREEN_WIDTH - contentTVX * 2;
    XQTextView *contentTV = [[XQTextView alloc] initWithFrame:CGRectMake(contentTVX, 0, contentTVW, HEIGHT(120))];
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
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view insertSubview:textField belowSubview:self.navigationBar];
    
    UIView *leftView    = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(12), frame.size.height)];
    textField.leftView  = leftView;
    UIView *rightView   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(12), frame.size.height)];
    textField.rightView = rightView;
    
    CGFloat lineW = frame.size.width;
    CGFloat lineY = CGRectGetHeight(frame) - 1;
    UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(0, lineY, lineW, 1)];
    [line setBackgroundColor:RGBCOLOR(203, 203, 203)];
    [textField addSubview:line];
    return textField;
}
#pragma mark - start 初始化控件

#pragma mark - start 按钮点击事件
- (void)releaseEvent:(UIButton *)sender
{
    if ((!self.contentTV.text) || [self.contentTV.text isEqualToString:@""]) {
        [[XQToast makeText:@"內容不能為空哦"] show];
        return;
    }
    if (self.type == FCVCTypeNew) {
        [self releaseNewComment];
    }else {
        [self releaseEditComment];
    }
}

- (void)sureEvent:(UIButton *)sender
{
    [self.view endEditing:YES];
}
#pragma mark end 按钮点击事件

#pragma mark - start 键盘展示和消失通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGRect  frame  = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat height = frame.size.height + self.keyBoardToolBar.bounds.size.height;
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
    CGFloat keyBoardMinY  = SCREEN_HEIGHT - height;
    CGFloat distance      = 0;
    if ([self.titleTF isFirstResponder]) {
        CGFloat titleMaxY = CGRectGetMaxY(self.titleTF.frame);
        if (keyBoardMinY < titleMaxY) {
            distance      = keyBoardMinY - titleMaxY;
        }
    }else {
        CGFloat contentMaxY = CGRectGetMaxY(self.contentTV.superview.frame);
        if (keyBoardMinY < contentMaxY) {
            distance      = keyBoardMinY - contentMaxY;
        }
    }
    [UIView animateWithDuration:animateTime animations:^{
        self.titleTF.transform = CGAffineTransformMakeTranslation(0, distance);
        self.contentTV.superview.transform = CGAffineTransformMakeTranslation(0, distance);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animateTime animations:^{
        self.titleTF.transform = CGAffineTransformIdentity;
        self.contentTV.superview.transform = CGAffineTransformIdentity;
        self.keyBoardToolBar.transform     = CGAffineTransformIdentity;
    }];
}
#pragma mark end 键盘展示和消失通知事件

#pragma mark - start 网络请求
- (void)getCommentDetail
{
    NSString *enews = @"MyrepE1";
    if (self.status == 1) {
        enews = @"MyrepE";
    }
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager userReplyDetailWithEnews:enews
                                  sid:self.mSid
                              success:^(NSDictionary *dict) {
                                  [hud hideAnimated:YES];
                                  NSString *title   = dict[@"bt"];
                                  NSString *content = dict[@"nr"];
                                  ws.titleTF.text   = title;
                                  ws.contentTV.text = content;
                                  ws.linkid         = dict[@"linkid"];
                              } failure:^(NSString *error) {
                                  [hud hideAnimated:YES];
                                  [MBProgressHUD showFailureInView:ws.view mesg:error];
                              }];
}

- (void)releaseNewComment
{
    __weak typeof(self) ws  = self;
    MBProgressHUD *hud      = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    NetworkManager *manager = [NetworkManager shareManager];
    [manager forumPostReplyWithEnews:@"AppMAddInfo"
                                 sid:nil
                             classID:@"2"
                              linkid:self.mSid
                               title:self.titleTF.text
                                text:self.contentTV.text
                             success:^(NSString *str) {
                                 [hud hideAnimated:YES];
                                 [[XQToast makeText:str] show];
                                 [ws.navigationController popViewControllerAnimated:YES];
                             } failure:^(NSString *error) {
                                 [hud hideAnimated:YES];
                                 [MBProgressHUD showFailureInView:ws.view mesg:error];
                             }];
}

- (void)releaseEditComment
{
    __weak typeof(self) ws  = self;
    MBProgressHUD *hud      = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    NetworkManager *manager = [NetworkManager shareManager];
    [manager forumPostReplyWithEnews:@"AppMEditInfo"
                                 sid:self.mSid
                             classID:@"2"
                              linkid:self.linkid
                               title:self.titleTF.text
                                text:self.contentTV.text
                             success:^(NSString *str) {
                                 [hud hideAnimated:YES];
                                 [[XQToast makeText:str] show];
                                 if (ws.type == FCVCTypeEdit) {
                                     [NotificationCenter postNotificationName:FORUM_REPLY_EDIT_SUCCESS object:nil userInfo:nil];
                                 }
                                 [ws.navigationController popViewControllerAnimated:YES];
                             } failure:^(NSString *error) {
                                 [hud hideAnimated:YES];
                                 [MBProgressHUD showFailureInView:ws.view mesg:error];
                             }];
}
#pragma mark end 网络请求
@end
