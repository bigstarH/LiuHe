//
//  PictureCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/6.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "PictureCell.h"

@interface PictureCell ()

@property (nonatomic, weak) UIImageView *contentImage;

@property (nonatomic) CGRect originFrame;

@property (nonatomic) CGRect defaultFrame;

@property (nonatomic) BOOL loadSuccess;

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
    [imageView setBackgroundColor:RGBCOLOR(246, 246, 246)];
    [imageView setUserInteractionEnabled:YES];
    [imageView.layer setMasksToBounds:YES];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic)]];
    [self.contentView addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX  = WIDTH(20);
    CGFloat imageW  = self.bounds.size.width - imageX * 2;
    CGFloat imageY  = (self.bounds.size.height - imageW) * 0.5;
    _defaultFrame   = CGRectMake(imageX, imageY, imageW, imageW);
    _contentImage.frame = _defaultFrame;
    if (_loadSuccess) {
        [self dealWithImage:self.contentImage.image];
    }
}

- (void)setImageWithUrl:(NSString *)imageUrl
{
    _contentImage.frame    = _defaultFrame;
    _loadSuccess           = NO;
    __weak typeof(self) ws = self;
    [_contentImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                     placeholderImage:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (error == nil) {
                                    [ws dealWithImage:image];
                                }
                            }];
}

/** 处理图片显示 */
- (void)dealWithImage:(UIImage *)image
{
    _loadSuccess = YES;
    CGRect frame = _defaultFrame;
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
    _originFrame = frame;
}

/** 显示大图 */
- (void)showBigPic
{
    if (_delegate && [_delegate respondsToSelector:@selector(pictureCell:didClickWithImageView:originFrame:)]) {
        CGRect frame = _defaultFrame;
        if (_loadSuccess) {
            frame    = _originFrame;
        }
        [_delegate pictureCell:self didClickWithImageView:_contentImage originFrame:frame];
    }
}
@end
