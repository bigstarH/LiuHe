//
//  MyDataViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import <UIImageView+WebCache.h>
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

@end

@implementation MyDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    
    [self createView];
    
    [SVProgressHUD show];
    __weak typeof(self) ws  = self;
    NetworkManager *manager = [NetworkManager shareManager];
    [manager userInfoWithSuccess:^(NSDictionary *dict) {
        [SVProgressHUD dismiss];
        UserModel *model = [UserModel userModelWithDict:dict];
        model.headUrlStr = dict[@"userpic"];
        [model saveUserInfoWithMyData];
        [ws setMyInfoWithModel:model];
    } failure:^(NSString *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
    [self.view addSubview:view];
    
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
    CGFloat tfH     = HEIGHT(36);
    CGRect frame    = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
    self.realNameTF = [self createTFWithFrame:frame placeholder:@"請輸入真實姓名" leftStr:@"姓名" hideBottomLine:NO];
    
    // 手机
    originY += tfH;
    frame        = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
    self.phoneTF = [self createTFWithFrame:frame placeholder:@"請輸入手機號碼" leftStr:@"手機號碼" hideBottomLine:NO];
    self.phoneTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    // QQ
    originY += tfH;
    frame     = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
    self.QQTF = [self createTFWithFrame:frame placeholder:@"請輸入QQ號碼" leftStr:@"QQ" hideBottomLine:NO];
    
    // 微信
    originY += tfH;
    frame         = CGRectMake(0, originY, SCREEN_WIDTH, tfH);
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
}

- (UITextField *)createTFWithFrame:(CGRect)frame placeholder:(NSString *)placeholder leftStr:(NSString *)leftStr hideBottomLine:(BOOL)hide
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.placeholder  = placeholder;
    textField.font         = [UIFont systemFontOfSize:fontSize(15)];
    [textField setBackgroundColor:[UIColor whiteColor]];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.view addSubview:textField];
    
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
        [self.view addSubview:line];
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
    
    [SVProgressHUD show];
    __weak typeof(self) ws = self;
    [manager modifyUserInfoWithTrueName:self.realNameTF.text
                                  phone:self.phoneTF.text
                               QQNumber:self.QQTF.text
                           weChatNumber:self.weChatTF.text
                              headImage:image
                                success:^(NSString *str) {
                                    [SVProgressHUD showSuccessWithStatus:str];
                                    [SVProgressHUD dismissWithDelay:1];
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
                                  [SVProgressHUD showErrorWithStatus:error];
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
@end
