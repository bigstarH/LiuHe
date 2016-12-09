//
//  MyDataViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "MBProgressHUD+Extension.h"
#import "MyDataViewController.h"
#import "UIImage+Extension.h"
#import "NetworkManager.h"
#import "XQActionSheet.h"
#import "UserModel.h"

@interface MyDataViewController () <XQActionSheetDelegate>

@property (nonatomic) BOOL isOriginImage;
/** 头像 */
@property (nonatomic, weak) UIImageView *header;
/** 真实姓名 */
@property (nonatomic, weak) UITextField *realNameTF;
/** 手机 */
@property (nonatomic, weak) UITextField *phoneTF;
/** QQ */
@property (nonatomic, weak) UITextField *QQTF;
/** 微信 */
@property (nonatomic, weak) UITextField *weChatTF;

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) UIView *keyBoardToolBar;

@end

@implementation MyDataViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    
    // 添加键盘出现／消失通知
    [self addNotification];
    
    [self createView];
    
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager userInfoWithSuccess:^(NSDictionary *dict) {
        [hud hideAnimated:YES];
        UserModel *model = [UserModel userModelWithDict:dict];
        model.headUrlStr = dict[@"userpic"];
        [model saveUserInfoWithMyData];
        [ws setMyInfoWithModel:model];
    } failure:^(NSString *error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showFailureInView:ws.view mesg:error];
    }];
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

- (void)setNavigationBarStyle
{
    self.title = @"我的資料";
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

#pragma mark - start 初始化创建View
- (void)createView
{
    _isOriginImage   = YES;
    UIFont *font     = [UIFont systemFontOfSize:fontSize(15)];
    UserModel *model = [UserModel getCurrentUser];
    
    // 头像
    CGFloat originY  = 64 + HEIGHT(12);
    CGFloat viewH    = HEIGHT(80);
    UIView *view     = [[UIView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, viewH)];
    [view setBackgroundColor:[UIColor whiteColor]];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                       action:@selector(selectHeader:)]];
    [self.view insertSubview:view belowSubview:self.navigationBar];
    
    CGFloat originX  = WIDTH(10);
    CGFloat headLabW = WIDTH(80);
    UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0, headLabW, viewH)];
    [headLab setText:@"頭像"];
    [headLab setFont:font];
    [view addSubview:headLab];
    
    CGFloat arrowW   = WIDTH(15);
    CGFloat arrowX   = SCREEN_WIDTH - arrowW - originX;
    CGFloat arrowY   = (viewH - arrowW) * 0.5;
    UIImageView *rightArrow = [[UIImageView alloc] initWithFrame:CGRectMake(arrowX, arrowY, arrowW, arrowW)];
    [rightArrow setImage:[UIImage imageNamed:@"btn_more"]];
    [view addSubview:rightArrow];
    
    CGFloat headerW     = WIDTH(60);
    CGFloat headerX     = arrowX - headerW - WIDTH(20);
    CGFloat headerY     = (viewH - headerW) * 0.5;
    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(headerX, headerY, headerW, headerW)];
    self.header         = header;
    [header.layer setMasksToBounds:YES];
    [header.layer setCornerRadius:headerW * 0.5];
    [header setContentMode:UIViewContentModeScaleAspectFill];
    [view addSubview:header];
    
    // 真实姓名
    originY += viewH + HEIGHT(12);
    CGFloat tfH      = HEIGHT(36);
    CGRect frame     = CGRectMake(0, originY, SCREEN_WIDTH, tfH * 4);
    UIView *contentV = [[UIView alloc] initWithFrame:frame];
    self.contentView = contentV;
    [contentV setBackgroundColor:[UIColor whiteColor]];
    [self.view insertSubview:contentV belowSubview:self.navigationBar];
    
    frame = CGRectMake(0, 0, SCREEN_WIDTH, tfH);
    self.realNameTF = [self createTFWithFrame:frame placeholder:@"請輸入真實姓名" leftStr:@"姓名" hideBottomLine:NO];
    
    // 手机
    frame        = CGRectMake(0, tfH, SCREEN_WIDTH, tfH);
    self.phoneTF = [self createTFWithFrame:frame placeholder:@"請輸入手機號碼" leftStr:@"手機號碼" hideBottomLine:NO];
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // QQ
    frame     = CGRectMake(0, tfH * 2, SCREEN_WIDTH, tfH);
    self.QQTF = [self createTFWithFrame:frame placeholder:@"請輸入QQ號碼" leftStr:@"QQ" hideBottomLine:NO];
    
    // 微信
    frame         = CGRectMake(0, tfH * 3, SCREEN_WIDTH, tfH);
    self.weChatTF = [self createTFWithFrame:frame placeholder:@"請輸入微信號" leftStr:@"微信" hideBottomLine:YES];
    
    if (model) {
        [header sd_setImageWithURL:[NSURL URLWithString:model.headUrlStr] placeholderImage:[UIImage imageNamed:@"user_head_hl"]];
        [self setMyInfoWithModel:model];
    }
    
    // 修改资料按钮
    CGFloat buttonH  = HEIGHT(40);
    CGFloat buttonY  = SCREEN_HEIGHT - buttonH - HEIGHT(20);
    UIButton *modity = [UIButton buttonWithType:UIButtonTypeCustom];
    [modity setFrame:CGRectMake(WIDTH(15), buttonY, SCREEN_WIDTH - WIDTH(30), buttonH)];
    [modity setTitle:@"修改資料" forState:UIControlStateNormal];
    [modity setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forState:UIControlStateNormal];
    [modity.layer setMasksToBounds:YES];
    [modity.layer setCornerRadius:HEIGHT(5)];
    [modity addTarget:self action:@selector(modityEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:modity];
    
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

- (UITextField *)createTFWithFrame:(CGRect)frame placeholder:(NSString *)placeholder leftStr:(NSString *)leftStr hideBottomLine:(BOOL)hide
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder  = placeholder;
    textField.font         = [UIFont systemFontOfSize:fontSize(15)];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.contentView addSubview:textField];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH(90), frame.size.height)];
    CGFloat leftLabX = WIDTH(10);
    CGFloat leftLabW = WIDTH(90) - WIDTH(10);
    UILabel *leftLab = [[UILabel alloc] initWithFrame:CGRectMake(leftLabX, 0, leftLabW, frame.size.height)];
    leftLab.text     = leftStr;
    leftLab.font     = [UIFont systemFontOfSize:fontSize(15)];
    [leftLab setTextColor:[UIColor lightGrayColor]];
    [leftView addSubview:leftLab];
    textField.leftView = leftView;
    
    if (!hide) {
        CGFloat lineW = frame.size.width - leftLabX * 2;
        CGFloat lineY = CGRectGetMaxY(frame) - 1;
        UIView *line  = [[UIView alloc] initWithFrame:CGRectMake(leftLabX, lineY, lineW, 1)];
        [line setBackgroundColor:RGBCOLOR(203, 203, 203)];
        [self.contentView addSubview:line];
    }
    return textField;
}

- (void)setMyInfoWithModel:(UserModel *)model
{
    [self.header sd_setImageWithURL:[NSURL URLWithString:model.headUrlStr] placeholderImage:[UIImage imageNamed:@"user_head_hl"]];
    self.realNameTF.text = model.trueName ? model.trueName : @"";
    self.phoneTF.text    = model.phone ? model.phone : @"";
    self.QQTF.text       = model.QQ ? model.QQ : @"";
    self.weChatTF.text   = model.weChat ? model.weChat : @"";
}
#pragma mark - start 初始化创建View

/** 头像选择 */
- (void)selectHeader:(UITapGestureRecognizer *)tap
{
    XQActionSheet *sheet = [[XQActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"相机", @"相册", nil];
    [sheet showInView:self.view];
}

- (void)sureEvent:(UIButton *)sender
{
    [self.view endEditing:YES];
}

/** "修改资料"按钮点击事件 */
- (void)modityEvent:(UIButton *)sender
{
    UserModel *model = [UserModel getCurrentUser];
    NetworkManager *manager = [NetworkManager shareManager];
    
    UIImage *image   = self.header.image;
    if ([image isEqual:[UIImage imageNamed:@"user_head_hl"]]) {
        image = nil;
    }
    if (_isOriginImage) {
        image = nil;
    }
    
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    __weak typeof(self) ws = self;
    [manager modifyUserInfoWithTrueName:self.realNameTF.text
                                  phone:self.phoneTF.text
                               QQNumber:self.QQTF.text
                           weChatNumber:self.weChatTF.text
                              headImage:image
                                success:^(NSString *str) {
                                    [hud hideAnimated:YES];
                                    [MBProgressHUD showSuccessInView:KeyWindow mesg:str];
                                    model.trueName = ws.realNameTF.text;
                                    model.phone    = ws.phoneTF.text;
                                    model.weChat   = ws.weChatTF.text;
                                    model.QQ       = self.QQTF.text;
                                    [model saveUserInfoWithMyData];
                                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                    [dict setObject:@(1) forKey:@"code"];
                                    if (image) {
                                        [dict setObject:image forKey:@"headImage"];
                                    }
                                    [NotificationCenter postNotificationName:USER_MODIFY_SUCCESS object:nil userInfo:dict];
                                    [ws.navigationController popViewControllerAnimated:YES];
                                } failure:^(NSString *error) {
                                    [hud hideAnimated:YES];
                                    [MBProgressHUD showFailureInView:ws.view mesg:error];
                                }];
}

#pragma mark - start XQActionSheetDelegate
- (void)actionSheetButtonDidClick:(XQActionSheet *)actionSheet ButtonType:(int)buttonType
{
    switch (buttonType) {
        case 1:  // 相机
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            picker.sourceType    = UIImagePickerControllerSourceTypeCamera;
            picker.delegate      = self;
            picker.cameraDevice  = UIImagePickerControllerCameraDeviceFront;
            picker.allowsEditing = YES;
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
            picker.showsCameraControls = YES;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
        case 2:  // 相册
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            picker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate      = self;
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}
#pragma mark end XQActionSheetDelegate

#pragma mark - start UIImagePickerControllerDelegate
/** 图片选择完毕 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    _isOriginImage    = NO;
    UIImage *image    = [info objectForKey:UIImagePickerControllerEditedImage];
    self.header.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

/** 取消图片选择 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark end UIImagePickerControllerDelegate

#pragma mark - start 键盘展示和消失通知事件
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.keyBoardToolBar.transform  = CGAffineTransformIdentity;
    self.contentView.transform      = CGAffineTransformIdentity;
    self.header.superview.transform = CGAffineTransformIdentity;
    
    CGRect  frame  = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = frame.size.height + self.keyBoardToolBar.bounds.size.height;
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
    
    CGFloat keyBoardMinY = SCREEN_HEIGHT - height;
    CGFloat distance     = 0;
    if ([self.realNameTF isFirstResponder]) {
        CGRect mFrame = [self.contentView convertRect:self.realNameTF.frame toView:self.view];
        CGFloat realNameMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < realNameMaxY) {
            distance  = keyBoardMinY - realNameMaxY;
        }
    }else if ([self.phoneTF isFirstResponder]) {
        CGRect mFrame = [self.contentView convertRect:self.phoneTF.frame toView:self.view];
        CGFloat phoneMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < phoneMaxY) {
            distance  = keyBoardMinY - phoneMaxY;
        }
    }else if ([self.QQTF isFirstResponder]) {
        CGRect mFrame  = [self.contentView convertRect:self.QQTF.frame toView:self.view];
        CGFloat qqMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < qqMaxY) {
            distance   = keyBoardMinY - qqMaxY;
        }
    }else {
        CGRect mFrame  = [self.contentView convertRect:self.weChatTF.frame toView:self.view];
        CGFloat weChatMaxY = CGRectGetMaxY(mFrame);
        if (keyBoardMinY < weChatMaxY) {
            distance  = keyBoardMinY - weChatMaxY;
        }
    }
    [UIView animateWithDuration:animateTime animations:^{
        self.contentView.transform = CGAffineTransformMakeTranslation(0, distance);
        self.header.superview.transform = CGAffineTransformMakeTranslation(0, distance);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    CGFloat animateTime = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animateTime animations:^{
        self.keyBoardToolBar.transform  = CGAffineTransformIdentity;
        self.contentView.transform      = CGAffineTransformIdentity;
        self.header.superview.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark end 键盘展示和消失通知事件
@end
