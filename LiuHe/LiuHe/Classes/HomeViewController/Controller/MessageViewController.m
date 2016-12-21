//
//  MessageViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/19.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MessageViewController.h"
#import "ShareManager.h"
#import "ShareMenu.h"

@interface MessageViewController () <ShareMenuDelegate>

@property (nonatomic, weak) UITextView *textView;

@end

@implementation MessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat labelX = WIDTH(20);
    CGFloat labelW = SCREEN_WIDTH - labelX * 2;
    CGFloat labelH = HEIGHT(32);
    CGFloat labelY = 64 + HEIGHT(30);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    label.font     = [UIFont systemFontOfSize:fontSize(17)];
    label.text     = @"消息";
    [label setTextColor:MAIN_COLOR];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.view addSubview:label];
    
    CGFloat textVX    = labelX;
    CGFloat textVW    = labelW;
    CGFloat textVH    = HEIGHT(200);
    CGFloat textVY    = CGRectGetMaxY(label.frame) + HEIGHT(16);
    UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(textVX, textVY, textVW, textVH)];
    self.textView     = textV;
    textV.text        = self.message;
    textV.font        = [UIFont systemFontOfSize:fontSize(15)];
    textV.editable    = NO;
    [textV setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.view addSubview:textV];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"六合藏宝图";
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = shareBtn;
    self.navigationBar.leftBarButtonItem  = leftItem;
}

- (void)goBackVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 按钮分享事件 */
- (void)shareEvent
{
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}
#pragma mark end 设置导航栏

#pragma mark - start ShareMenuDelegate
/** 分享事件 */
- (void)shareMenu:(ShareMenu *)shareMenu didSelectMenuItemWithType:(ShareMenuItemType)type
{
    switch (type) {
        case ShareMenuItemTypeWeChat:  // 微信
            [ShareManager weChatShareWithText:self.message currentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeWechatTimeLine:  // 朋友圈
            [ShareManager weChatTimeLineShareWithText:self.message currentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQQ:  // QQ
            [ShareManager QQShareWithText:self.message currentVC:self success:nil failure:nil];
            break; 
        case ShareMenuItemTypeQZone:  // QQ空间
            [ShareManager QZoneShareWithText:self.message currentVC:self success:nil failure:nil];
            break;
        default:
            break;
    }
}
#pragma mark end ShareMenuDelegate

@end
