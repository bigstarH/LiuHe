//
//  PicDetailViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/3.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "PicDetailViewController.h"
#import "PicLibraryModel.h"
#import "NetworkManager.h"
#import "XQToast.h"

@interface PicDetailViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, weak) UIImageView *imageView;
/** imageView原来的位置尺寸 */
@property (nonatomic) CGRect originFrame;

@property (nonatomic, weak) UIImageView *bigImageView;

@end

@implementation PicDetailViewController

- (void)dealloc
{
    NSLog(@"PicDetailViewController dealloc");
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createView];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = _model.title;
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *collect = [[XQBarButtonItem alloc] initWithTitle:@"收藏"];
    [collect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collect setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [collect addTarget:self action:@selector(collectEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = collect;
    self.navigationBar.leftBarButtonItem  = leftItem;
}

/** 按钮收藏事件 */
- (void)collectEvent
{
    [SVProgressHUD show];
    [[NetworkManager shareManager] collectingWithClassID:self.classID
                                                      ID:_model.sid
                                                 success:^(NSString *string) {
                                                     [SVProgressHUD dismiss];
                                                     [[XQToast makeText:string] show];
                                                 } failure:^(NSString *error) {
                                                     [SVProgressHUD showErrorWithStatus:error];
                                                 }];
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
- (void)createView
{
    CGFloat originY = 64 + HEIGHT(10);
    if (_model.qishu) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(30))];
        label.text     = [NSString stringWithFormat:@"第%@期", _model.qishu];
        label.font     = [UIFont systemFontOfSize:fontSize(14)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [self.view addSubview:label];
        originY = CGRectGetMaxY(label.frame);
    }
    
    CGFloat imageX  = WIDTH(20);
    CGFloat imageW  = SCREEN_WIDTH - imageX * 2;
    _originFrame    = CGRectMake(imageX, originY, imageW, imageW * 1.2);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_originFrame];
    imageView.contentMode  = UIViewContentModeScaleAspectFill;
    self.imageView         = imageView;
    [imageView.layer setMasksToBounds:YES];
    [imageView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [SVProgressHUD show];
    __weak typeof(self) ws = self;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.urlString]
                 placeholderImage:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            [SVProgressHUD dismiss];
                            if (error == nil) {
                                [ws dealWithImage:image];
                            }
                        }];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)]];
    [self.view addSubview:imageView];
}
#pragma mark end 初始化控件

#pragma mark - start 手势事件
/** 显示大图 */
- (void)showBigPic
{
    UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    maskView.alpha   = 0.0;
    self.maskView    = maskView;
    [maskView setBackgroundColor:[UIColor blackColor]];
    [KeyWindow addSubview:maskView];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:maskView.frame];
    scrollView.delegate      = self;
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:1.6];
    [scrollView setMultipleTouchEnabled:YES];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigPic:)]];
    [KeyWindow addSubview:scrollView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.originFrame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.urlString] placeholderImage:nil];
    self.bigImageView      = imageView;
    self.imageView.hidden  = YES;
    [scrollView addSubview:imageView];
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame     = imageView.frame;
        frame.size       = CGSizeMake(SCREEN_WIDTH - WIDTH(10), SCREEN_HEIGHT);
        imageView.frame  = frame;
        imageView.center = self.view.center;
        maskView.alpha   = 1.0;
    }];
}

/** 移除大图，恢复原图 */
- (void)removeBigPic:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    
    CGRect frame = [self.view convertRect:self.originFrame toView:scrollView];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha     = 0.0;
        self.bigImageView.frame = frame;
    } completion:^(BOOL finished) {
        self.imageView.hidden = NO;
        [self.maskView removeFromSuperview];
        [self.bigImageView removeFromSuperview];
        [scrollView removeFromSuperview];
    }];
}
#pragma mark end 手势事件

#pragma mark - start 私有方法
/** 处理图片显示 */
- (void)dealWithImage:(UIImage *)image
{
    CGRect frame = _imageView.frame;
    if (image.size.width >= image.size.height) {  // 宽 >= 高
        CGFloat imageH    = frame.size.width * image.size.height / image.size.width;
        frame.size.height = imageH;
        _imageView.frame  = frame;
    }else {
        CGFloat imageH    = frame.size.height;
        CGFloat imageW    = imageH * image.size.width / image.size.height;
        frame.size.width  = imageW;
        frame.origin.x    = (SCREEN_WIDTH - imageW) * 0.5;
        _imageView.frame  = frame;
    }
    _originFrame = _imageView.frame;
}
#pragma mark end 私有方法

#pragma mark - start UIScrollViewDelegate
/** 实现图片的缩放 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

/** 实现图片在缩放过程中居中 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _bigImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark end UIScrollViewDelegate
@end
