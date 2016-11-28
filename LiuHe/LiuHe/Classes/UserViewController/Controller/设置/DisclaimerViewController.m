//
//  DisclaimerViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/11/26.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "NSString+Extension.h"

@interface DisclaimerViewController ()

@property (nonatomic, weak) UIScrollView *scrollView;

@end

@implementation DisclaimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
}

- (void)setNavigationBarStyle
{
    self.needsCustomNavigationBar   = YES;
    self.navigationBar.shadowHidden = YES;
    self.title = @"免責聲明";
    
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
    
    NSString *text = @"友情提醒：\n\n    在使用本應用的所有功能之前，請您務必仔細閱讀並透徹理解本聲明。您可以選擇不使用本應用，但如果您使用本應用，您的使用行為將被視為對本聲明全部內容的認可。\n\n免責聲明：\n\n    鑒於本應用使用非人工檢索/分析方式，無法確定您輸入的條件進行是否合法，所以本應用對檢索/分析出的結果不承擔責任。如果因以本應用的檢索/分析結果作為任何投註形為或者博彩研究的依據而產生不良後果，本應用不承擔任何法律責任，同時本應用嚴正告誡您的形為必須遵守所在當地的法律法規。\n\n    本應用所有頁面提供的廣告、鏈接、圖片、視頻、文字等壹切信息均不代表本應用立場，壹切內容均由第三方公司提供。鑒於本應用無法驗證信息內容真實性，無法確定第三方的形為是否合法。所以本應用對壹切內容不承擔責任，敬請您知悉。\n\n關於隱私權：\n\n    訪問者在本應用註冊時提供的壹些個人資料，本應用除您本人同意外不會將用戶的任何資料以任何方式泄露給第三方。\n\n    本應用之聲明以及其修改權、更新權及最終解釋權均屬本應用所有。";
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
