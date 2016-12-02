//
//  DataDetailViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "DataDetailViewController.h"
#import "NSString+Extension.h"
#import "NetworkManager.h"
#import "DataModel.h"

@interface DataDetailViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic) CGFloat originY;

@end

@implementation DataDetailViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化控件
    [self createView];
    // 获取详情
    [self getDataDetail];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"详情";
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
    NSLog(@"分享");
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
- (void)createView
{
    CGFloat scrollH = SCREEN_HEIGHT - 64;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, scrollH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    UIFont *font    = [UIFont boldSystemFontOfSize:fontSize(17)];
    CGSize maxSize  = CGSizeMake(SCREEN_WIDTH - WIDTH(20), CGFLOAT_MAX);
    CGSize realSize = [_model.title realSize:maxSize font:font];
    
    CGFloat labelH  = realSize.height + HEIGHT(16);
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(10), 0, maxSize.width, labelH)];
    label.font      = font;
    label.text      = _model.title;
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
    label.text      = _model.dateStr;
    [label setTextAlignment:NSTextAlignmentCenter];
    [scrollView addSubview:label];
    
    self.originY    = CGRectGetMaxY(label.frame) + HEIGHT(8);
}
#pragma mark end 初始化控件

#pragma mark - start 网络请求
- (void)getDataDetail
{
    __weak typeof(self) ws  = self;
    [SVProgressHUD show];
    NetworkManager *manager = [NetworkManager shareManager];
    [manager dataDetailWithSid:_model.sid
                       success:^(NSDictionary *dict) {
                           [SVProgressHUD dismiss];
                           NSString *newstext = dict[@"newstext"];
                           NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[newstext dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                           UIFont *font    = [UIFont systemFontOfSize:fontSize(15)];
                           CGSize maxSize  = CGSizeMake(SCREEN_WIDTH - WIDTH(30), CGFLOAT_MAX);
                           CGSize realSize = [str.string realSize:maxSize font:font];
                           
                           CGFloat labelW  = SCREEN_WIDTH - WIDTH(20);
                           CGFloat labelH  = realSize.height + HEIGHT(16);
                           CGRect frame    = CGRectMake(WIDTH(10), ws.originY, labelW, labelH);
                           UIView *view    = [[UIView alloc] initWithFrame:frame];
                           [view.layer setMasksToBounds:YES];
                           [view.layer setBorderWidth:1.0];
                           [view.layer setCornerRadius:WIDTH(5)];
                           [ws.scrollView addSubview:view];
                           
                           frame           = CGRectMake(WIDTH(5), 0, maxSize.width, labelH);
                           UILabel *label  = [[UILabel alloc] initWithFrame:frame];
                           label.font      = font;
                           label.text      = str.string;
                           [label setNumberOfLines:0];
                           [view addSubview:label];
                           
                           CGFloat height  = CGRectGetMaxY(view.frame) + HEIGHT(10);
                           [ws.scrollView setContentSize:CGSizeMake(0, height)];
                           
                       } failure:^(NSString *error) {
                           [SVProgressHUD showErrorWithStatus:error];
                       }];
}
#pragma mark end 网络请求
@end
