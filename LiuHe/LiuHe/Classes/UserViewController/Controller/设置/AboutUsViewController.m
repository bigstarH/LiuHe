//
//  AboutUsViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/11/26.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Photos/Photos.h>
#import <UIImageView+WebCache.h>
#import "AboutUsViewController.h"
#import "NSString+Extension.h"
#import "SystemManager.h"
#import "XQActionSheet.h"
#import "XQToast.h"

@interface AboutUsViewController () <XQActionSheetDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation AboutUsViewController

- (void)dealloc
{
    NSLog(@"AboutUsViewController dealloc");
}

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
    
    labelH         = HEIGHT(50);
    CGFloat labelY = scrollH - labelH - HEIGHT(10);
    
    CGFloat imageW = WIDTH(150);
    CGFloat imageX = (SCREEN_WIDTH - imageW) * 0.5;
    CGFloat imageY = labelY - imageW;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
    self.imageView         = imageView;
    [imageView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[SystemManager qrcodeURL]]
                 placeholderImage:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (error == nil) {
                                UILabel *tmpLab = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH(10), labelY, labelW, labelH)];
                                tmpLab.font = [UIFont systemFontOfSize:fontSize(14)];
                                tmpLab.text = @"您可邀請好友掃描上方的二維碼來下載曾道人哦,也可以直接點擊圖片保存到系統相冊。";
                                [tmpLab setNumberOfLines:0];
                                [tmpLab setTextAlignment:NSTextAlignmentCenter];
                                [scrollView addSubview:tmpLab];
                                [imageView setUserInteractionEnabled:YES];
                            }
                        }];
    [scrollView addSubview:imageView];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)]];
}

- (void)saveImage:(UITapGestureRecognizer *)tap
{
    XQActionSheet *sheet = [[XQActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"保存圖片到相冊", nil];
    [sheet showInView:self.view];
}

- (void)actionSheetButtonDidClick:(XQActionSheet *)actionSheet ButtonType:(int)buttonType
{
    if (buttonType == 1) {
        UIImage *image = self.imageView.image;
        [self loadImageFinished:image];
    }
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [[XQToast makeText:@"保存成功"] show];
    }else {
        [[XQToast makeText:@"保存失敗"] show];
    }
}
@end
