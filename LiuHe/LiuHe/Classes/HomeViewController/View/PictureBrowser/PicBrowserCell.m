//
//  PicBrowserCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/7.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "PicBrowserCell.h"
#import "XQCircleProgressView.h"

@interface PicBrowserCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) XQCircleProgressView *progressView;

@property (nonatomic) CGRect defaultFrame;

@property (nonatomic) BOOL loadSuccess;

@property (nonatomic) NSInteger index;

@end

@implementation PicBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate      = self;
    self.scrollView          = scrollView;
    [scrollView setMinimumZoomScale:1.0];
    [scrollView setMaximumZoomScale:3.0];
    [scrollView setMultipleTouchEnabled:YES];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:scrollView];
    
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDidClick)]];

    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView.layer setMasksToBounds:YES];
    self.imageView         = imageView;
    [scrollView addSubview:imageView];
    
    XQCircleProgressView *progressView = [XQCircleProgressView progressViewWithStyle:XQProgressViewStyleMix];
    self.progressView = progressView;
    self.progressView.progress     = 0;
    progressView.progressTintColor = [UIColor whiteColor];
    [scrollView addSubview:progressView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    
    CGFloat imageViewX = WIDTH(20);
    CGFloat imageViewW = self.bounds.size.width - imageViewX * 2;
    CGFloat imageViewY = (self.bounds.size.height - imageViewW) * 0.5;
    _defaultFrame      = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewW);
    _imageView.frame   = _defaultFrame;
    
    if (_loadSuccess) {
        [self dealWithImage:_imageView.image];
    }
    
    CGFloat progressViewW = WIDTH(45);
    CGFloat progressViewX = (self.bounds.size.width - progressViewW) * 0.5;
    CGFloat progressViewY = (self.bounds.size.height - progressViewW) * 0.5;
    _progressView.frame   = CGRectMake(progressViewX, progressViewY, progressViewW, progressViewW);
}

- (CGRect)convertImageViewFrameToMainScreen
{
    CGRect frame = [self.scrollView convertRect:self.imageView.frame toView:KeyWindow];
    return frame;
}

- (void)setCellData:(NSString *)imageUrlStr index:(NSInteger)index
{
    self.index             = index;
    _loadSuccess           = NO;
    _imageView.frame       = _defaultFrame;
    _progressView.progress = 0;
    _progressView.hidden   = NO;
    __weak typeof(self) ws = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlStr]
                      placeholderImage:nil
                               options:SDWebImageRetryFailed | SDWebImageLowPriority
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  CGFloat progress = receivedSize * 1.0 / expectedSize;
                                  if (ws.index == index) {
                                      ws.progressView.progress = progress;
                                  }
                              } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                  ws.progressView.hidden = YES;
                                  if (error == nil) {
                                      [ws dealWithImage:image];
                                  }else { // 失败
                                      [ws.imageView setImage:[UIImage imageNamed:@"loadImg_failure"]];
                                  }
                              }];
}

- (void)scrollViewDidClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(picBrowserCell:didClickWithIndex:)]) {
        [self.delegate picBrowserCell:self didClickWithIndex:self.index];
    }
}

/** 处理图片显示 */
- (void)dealWithImage:(UIImage *)image
{
    _loadSuccess      = YES;
    CGSize targetSize = CGSizeZero;
    CGFloat width     = image.size.width;
    CGFloat height    = image.size.height;
    if (width >= height) { // 宽 >= 高
        CGFloat tarW  = self.bounds.size.width - WIDTH(40);
        CGFloat scale = tarW / width;
        targetSize    = CGSizeMake(tarW, height * scale);
    }else {
        CGFloat tarH  = self.bounds.size.height - HEIGHT(80);
        CGFloat scale = tarH / height;
        targetSize    = CGSizeMake(width * scale, tarH);
    }
    CGRect frame      = CGRectZero;
    frame.size        = targetSize;
    frame.origin.x    = (self.bounds.size.width - targetSize.width) * 0.5;
    frame.origin.y    = (self.bounds.size.height - targetSize.height) * 0.5;
    _imageView.frame  = frame;
}

#pragma mark - start UIScrollViewDelegate
/** 实现图片的缩放 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

/** 实现图片在缩放过程中居中 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX   = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY   = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark end UIScrollViewDelegate
@end
