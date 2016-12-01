//
//  XQSpringMenuItme.m
//  Example
//
//  Created by NB-022 on 16/4/29.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import "XQSpringMenuItem.h"

@interface XQSpringMenuItem ()

@property (nonatomic, assign) CGSize imageSize;

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation XQSpringMenuItem
{
    BOOL _needSetLayout;
}

- (instancetype)initWithImage:(UIImage *)menuImage title:(NSString *)menuTitle
{
    if (self = [super init]) {
        _imageSize = menuImage.size;
        _menuImage = menuImage;
        _menuTitle = menuTitle;
        [self creatView];
    }
    return self;
}

- (void)dealloc
{
    _menuImage = nil;
    _menuTitle = nil;
}

- (void)creatView
{
    _needSetLayout         = YES;
    UIImageView *imageView = [[UIImageView alloc] init];
    UILabel *textLabel     = [[UILabel alloc] init];
    
    [self addSubview:imageView];
    [self addSubview:textLabel];
    
    _imageView = imageView;
    _textLabel = textLabel;
    
    _imageView.image = self.menuImage;
    _textLabel.text  = self.menuTitle;
    
    [_imageView.layer setMasksToBounds:YES];
    [_textLabel setTextColor:[UIColor blackColor]];
    [_textLabel setTextAlignment:NSTextAlignmentCenter];
    [_textLabel setFont:[UIFont systemFontOfSize:fontSize(13)]];
}

- (void)layoutSubviews
{
    if (!_needSetLayout) return;
    
    [self addConstraints];
    
    _needSetLayout = NO;
}

/** 添加约束 */
- (void)addConstraints
{
    CGFloat scale      = self.imageSize.height / self.imageSize.width;
    
    CGFloat imageViewW = self.bounds.size.width;
    CGFloat imageViewH = self.bounds.size.width * scale;
    _imageView.frame   = CGRectMake(0, 0, imageViewW, imageViewH);
    _imageView.layer.cornerRadius = imageViewW * 0.5;
    
    CGFloat textLabelY = CGRectGetMaxY(_imageView.frame) + 3;
    CGFloat textLabelW = imageViewW;
    CGFloat textLabelH = self.bounds.size.height - textLabelY;
    _textLabel.frame   = CGRectMake(0, textLabelY, textLabelW, textLabelH);
}

- (void)setFontSzie:(CGFloat)fontSize
{
    [self.textLabel setFont:[UIFont systemFontOfSize:fontSize]];
}

@end
