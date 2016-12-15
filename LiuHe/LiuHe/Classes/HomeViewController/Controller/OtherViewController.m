//
//  OtherViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/14.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "TreasureViewController.h"
#import "LotteryViewController.h"
#import "OtherViewController.h"
#import "WebViewController.h"
#import "ShareManager.h"
#import "NetworkUrl.h"
#import "ShareMenu.h"
#import "MenuItem.h"

@interface OtherViewController () <ShareMenuDelegate>

@end

@implementation OtherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"其他功能";
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = shareBtn;
    self.navigationBar.leftBarButtonItem  = leftItem;
}
/** 按钮分享事件 */
- (void)shareEvent
{
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
- (void)createView
{
    __weak typeof(self) ws = self;
    NSArray *array  = @[@"彩票專區", @"時時彩",  @"足球比分", @"娛樂城",
                        @"百家樂", @"皇冠網", @"六合尋寶"];
    CGFloat itemW   = SCREEN_WIDTH / 3;
    CGFloat originY = WIDTH(5) + 64;
    CGFloat labelH  = HEIGHT(20);
    for (int i = 0; i < array.count; i++) {
        CGFloat itemX  = (i % 3) * itemW;
        CGFloat itemY  = originY + (i / 3) * itemW;
        MenuItem *item = [[MenuItem alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemW)];
        item.tag       = i;
        [item setMenuTitle:array[i] font:[UIFont systemFontOfSize:fontSize(14)]];
        [item setMenuImage:[UIImage imageNamed:array[i]]];
        [item setHighlightedType:MenuItemHighlightedTypeWhiteAndFront];
        
        CGFloat imageW = i == 1 ? WIDTH(45) : WIDTH(35);
        CGFloat imageX = (itemW - imageW) * 0.5;
        CGFloat imageY = (itemW - WIDTH(35) - labelH - HEIGHT(10)) * 0.5;
        CGFloat labelY = imageY + WIDTH(35) + HEIGHT(10);
        item.imageView.frame = CGRectMake(imageX, imageY, imageW, imageW);
        item.label.frame     = CGRectMake(0, labelY, itemW, labelH);
        [self.view addSubview:item];
        
        [item setMenuClickBlock:^(NSInteger tag) {
            [ws menuItemDidClickWithTag:tag];
        }];
    }
}

- (void)menuItemDidClickWithTag:(NSInteger)tag
{
    switch (tag) {
        case 0:  // 彩票专区
        {
            LotteryViewController *vc = [[LotteryViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:  // 足球比分
        {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.mTitle     = @"足球比分";
            vc.requestUrl = FOOTBAL_SCORE_URL;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:  // 百家樂
        {
            WebViewController *vc = [[WebViewController alloc] init];
            vc.mTitle     = @"百家樂";
            vc.requestUrl = BAIJIALE_URL;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:  // 时时彩
        case 3:  // 娛樂城
        case 5:  // 皇冠網
        case 6:  // 六合尋寶
        {
            TreasureViewController *vc = [[TreasureViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
}
#pragma mark end 初始化控件

#pragma mark - start ShareMenuDelegate
/** 分享事件 */
- (void)shareMenu:(ShareMenu *)shareMenu didSelectMenuItemWithType:(ShareMenuItemType)type
{
    switch (type) {
        case ShareMenuItemTypeWeChat:  // 微信
            [ShareManager weChatShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeWechatTimeLine:  // 朋友圈
            [ShareManager weChatTimeLineShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQQ:  // QQ
            [ShareManager QQShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQZone:  // QQ空间
            [ShareManager QZoneWithCurrentVC:self success:nil failure:nil];
            break;
        default:
            break;
    }
}
#pragma mark end ShareMenuDelegate
@end
