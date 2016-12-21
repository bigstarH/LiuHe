//
//  DataDetailViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "DataDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "NSString+Extension.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "UserModel.h"
#import "DataModel.h"
#import "XQToast.h"

@interface DataDetailViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic) CGFloat originY;

@end

@implementation DataDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 获取详情
    [self getDataDetail];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"详情";
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftItem;
    if (self.needCollectedBtn) {
        XQBarButtonItem *rightItem = [[XQBarButtonItem alloc] initWithTitle:@"收藏"];
        [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightItem setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        [rightItem addTarget:self action:@selector(collectEvent) forControlEvents:UIControlEventTouchUpInside];
        self.navigationBar.rightBarButtonItem = rightItem;
    }
}

/** 按钮“收藏”事件 */
- (void)collectEvent
{
    if ([UserModel getCurrentUser] == nil) {
        [[XQToast makeText:@"請先登錄"] show];
        [self.tabBarController setSelectedIndex:2];
        return;
    }
    [self collectingData];
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
- (void)createViewWithDict:(NSDictionary *)dict
{
    CGFloat scrollH = SCREEN_HEIGHT - 64;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, scrollH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    NSString *title = dict[@"title"];
    title           = [title stringByReplacingOccurrencesOfString:@"六合管家" withString:@"六合藏宝"];
    UIFont *font    = [UIFont boldSystemFontOfSize:fontSize(17)];
    CGSize maxSize  = CGSizeMake(SCREEN_WIDTH - WIDTH(20), CGFLOAT_MAX);
    CGSize realSize = [title realSize:maxSize font:font];
    
    CGFloat labelH  = realSize.height + HEIGHT(16);
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(10), 0, maxSize.width, labelH)];
    label.font      = font;
    label.text      = title;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [scrollView addSubview:label];
    
    CGFloat labelY  = CGRectGetMaxY(label.frame) + HEIGHT(5);
    labelH          = HEIGHT(28);
    CGFloat labelX  = (SCREEN_WIDTH - WIDTH(160)) * 0.5;
    CGFloat imageH  = HEIGHT(15);
    CGFloat imageY  = labelY + (labelH - imageH) * 0.5;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(labelX, imageY, imageH, imageH)];
    imageView.image = [UIImage imageNamed:@"news_item_date_hl"];
    [scrollView addSubview:imageView];
    
    labelX          = CGRectGetMaxX(imageView.frame) + WIDTH(5);
    label           = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, WIDTH(140), labelH)];
    label.font      = [UIFont systemFontOfSize:fontSize(14)];
    label.text      = [SystemManager dateStringWithTime:[dict[@"newstime"] doubleValue]
                                              formatter:@"yyyy-MM-dd HH:mm:ss"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:label];
    
    NSString *newstext = dict[@"newstext"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[newstext dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    font     = [UIFont systemFontOfSize:fontSize(15)];
    maxSize  = CGSizeMake(SCREEN_WIDTH - WIDTH(30), CGFLOAT_MAX);
    realSize = [str.string realSize:maxSize font:font];
    
    CGFloat labelW = SCREEN_WIDTH - WIDTH(20);
    labelY         = CGRectGetMaxY(label.frame) + HEIGHT(8);
    labelH         = realSize.height + HEIGHT(16);
    CGRect frame   = CGRectMake(WIDTH(10), labelY, labelW, labelH);
    UIView *view   = [[UIView alloc] initWithFrame:frame];
    [view.layer setMasksToBounds:YES];
    [view.layer setBorderWidth:1.0];
    [view.layer setCornerRadius:WIDTH(5)];
    [scrollView addSubview:view];
    
    frame      = CGRectMake(WIDTH(5), 0, maxSize.width, labelH);
    label      = [[UILabel alloc] initWithFrame:frame];
    label.font = font;
    label.text = str.string;
    [label setNumberOfLines:0];
    [view addSubview:label];
    
    CGFloat height  = CGRectGetMaxY(view.frame) + HEIGHT(10);
    [scrollView setContentSize:CGSizeMake(0, height)];
}
#pragma mark end 初始化控件

#pragma mark - start 网络请求
/** 获取详情 */
- (void)getDataDetail
{
    __weak typeof(self) ws  = self;
    MBProgressHUD *hud      = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    NetworkManager *manager = [NetworkManager shareManager];
    [manager dataDetailWithSid:_sid
                       success:^(NSDictionary *dict) {
                           [hud hideAnimated:YES];
                           [ws createViewWithDict:dict];
                       } failure:^(NSString *error) {
                           [hud hideAnimated:YES];
                           [MBProgressHUD showFailureInView:ws.view mesg:error];
                       }];
}

/** 收藏资料 */
- (void)collectingData
{
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    [[NetworkManager shareManager] collectingWithClassID:_classID
                                                      ID:_sid
                                                 success:^(NSString *string) {
                                                     [hud hideAnimated:YES];
                                                     [[XQToast makeText:string] show];
                                                 } failure:^(NSString *error) {
                                                     [hud hideAnimated:YES];
                                                     [MBProgressHUD showFailureInView:self.view mesg:error];
                                                 }];
}
#pragma mark end 网络请求
@end
