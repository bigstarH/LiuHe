//
//  PictureCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/6.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "PictureCell.h"
#import "XQCircleProgressView.h"

@interface PictureCell ()

@property (nonatomic, weak) UIImageView *contentImage;

@property (nonatomic, weak) XQCircleProgressView *progressView;

@end

@implementation PictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode  = UIViewContentModeScaleAspectFill;
    self.contentImage      = imageView;
    [imageView setBackgroundColor:[UIColor lightGrayColor]];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)]];
    [self.contentView addSubview:imageView];
    
    XQCircleProgressView *progressView = [XQCircleProgressView progressViewWithStyle:XQProgressViewStyleBackgroudCircle];
    self.progressView = progressView;
    progressView.progressTintColor = MAIN_COLOR;
    [self.contentView addSubview:progressView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX  = WIDTH(20);
    CGFloat imageW  = self.bounds.size.width - imageX * 2;
    CGFloat imageY  = (self.bounds.size.height - imageW) * 0.5;
    self.contentImage.frame = CGRectMake(imageX, imageY, imageW, imageW);
    
    CGFloat progressW = 60;
    CGFloat progressX = (self.bounds.size.width - progressW) * 0.5;
    CGFloat progressY = (self.bounds.size.height - progressW) * 0.5;
    self.progressView.frame = CGRectMake(progressX, progressY, progressW, progressW);
}

- (void)setImageWithUrl:(NSString *)imageUrl
{
    __weak typeof(self) ws = self;
    self.progressView.progress = 0;
    self.progressView.hidden   = NO;
    [self.contentImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                         placeholderImage:[UIImage imageNamed:@"empty_photo"]
                                  options:SDWebImageRetryFailed | SDWebImageLowPriority
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     NSLog(@"%f", receivedSize * 1.0 / expectedSize);
                                     ws.progressView.progress = receivedSize * 1.0 / expectedSize;
                                 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     if (error == nil) {
                                         [ws dealWithImage:image];
                                     }else {
                                     }
                                     ws.progressView.hidden = YES;
                                 }];
}

/** 处理图片显示 */
- (void)dealWithImage:(UIImage *)image
{
    CGRect frame = _contentImage.frame;
    if (image.size.width >= image.size.height) {  // 宽 >= 高
        CGFloat imageH      = frame.size.width * image.size.height / image.size.width;
        frame.size.height   = imageH;
        frame.origin.y      = (self.bounds.size.height - imageH) * 0.5;
        _contentImage.frame = frame;
    }else {
        CGFloat imageH      = frame.size.height;
        CGFloat imageW      = imageH * image.size.width / image.size.height;
        frame.size.width    = imageW;
        frame.origin.x      = (SCREEN_WIDTH - imageW) * 0.5;
        _contentImage.frame = frame;
    }
}

/** 显示大图 */
- (void)showBigPic
{
//    UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    maskView.alpha   = 0.0;
//    self.maskView    = maskView;
//    [maskView setBackgroundColor:[UIColor blackColor]];
//    [KeyWindow addSubview:maskView];
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:maskView.frame];
//    scrollView.delegate      = self;
//    [scrollView setMinimumZoomScale:1.0];
//    [scrollView setMaximumZoomScale:1.6];
//    [scrollView setMultipleTouchEnabled:YES];
//    [scrollView setBackgroundColor:[UIColor clearColor]];
//    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigPic:)]];
//    [KeyWindow addSubview:scrollView];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.originFrame];
//    [imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [imageView sd_setImageWithURL:[NSURL URLWithString:_model.urlString] placeholderImage:nil];
//    self.bigImageView      = imageView;
//    self.imageView.hidden  = YES;
//    [scrollView addSubview:imageView];
//    
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame     = imageView.frame;
//        frame.size       = CGSizeMake(SCREEN_WIDTH - WIDTH(10), SCREEN_HEIGHT);
//        imageView.frame  = frame;
//        imageView.center = self.view.center;
//        maskView.alpha   = 1.0;
//    }];
}
@end
