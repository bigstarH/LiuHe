//
//  AboutUsViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/11/26.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "AboutUsViewController.h"
#import "NSString+Extension.h"

@interface AboutUsViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation AboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}

- (void)setNavigationBarStyle
{
    self.title = @"關於應用";
    
    XQBarButtonItem *leftBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem = leftBtn;
}

- (void)createView
{
    CGFloat scrollH          = SCREEN_HEIGHT - 64;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, scrollH)];
    self.scrollView          = scrollView;
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    NSString *text = @"    曾道人是香港六合寶典科技有限公司開發的一款基於曾道人先机為內容主體，集視頻開獎，六合大全，用戶論壇為一體的六和彩資訊應用。\n\n    曾道人是具有資源佔用低、操作簡潔、數據齊全、分析準確等特點，是目前最受歡迎的的六和彩資訊應用之一。\n\n    版權所有@香港六合寶典科技有限公司";
    
    CGFloat labelW = scrollView.bounds.size.width - WIDTH(10) * 2;
    UIFont *font   = [UIFont systemFontOfSize:fontSize(15)];
    CGSize size    = [text realSize:CGSizeMake(labelW, CGFLOAT_MAX) font:font];
    CGFloat labelH = size.height + HEIGHT(18);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(10), 0, labelW, labelH)];
    label.font     = font;
    label.text     = text;
    [label setNumberOfLines:0];
    [scrollView addSubview:label];
    [scrollView setContentSize:CGSizeMake(0, CGRectGetMaxY(label.frame))];
}

@end
