//
//  MenuItem.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MenuItem.h"

@interface MenuItem ()

@property (nonatomic, weak) UIView *backgroundView;

@property (nonatomic, copy) void (^block)(NSInteger);

@end

@implementation MenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView        = backgroundView;
        backgroundView.hidden  = YES;
        [backgroundView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
        [self addSubview:backgroundView];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidClick:)]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _backgroundView.hidden = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _backgroundView.hidden = YES;
}

- (void)layoutSubviews
{
    _backgroundView.frame = self.bounds;
    
    if (!CGRectEqualToRect(_label.frame, CGRectZero)) return;
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat imageX   = width * 0.5 - _imageView.image.size.width - 5;
    CGFloat imageY   = (height - _imageView.image.size.height) * 0.5;
    _imageView.frame = CGRectMake(imageX, imageY, _imageView.image.size.width, _imageView.image.size.height);
    
    CGFloat labelX   = CGRectGetMaxX(_imageView.frame) + 10;
    CGFloat labelY   = (height - _titleSize.height) * 0.5;
    _label.frame     = CGRectMake(labelX, labelY, _titleSize.width, _titleSize.height);
}

- (void)setMenuTitle:(NSString *)title font:(UIFont *)font
{
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _label         = label;
        [label setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:label];
    }
    _label.text = title;
    _label.font = font ? font : [UIFont systemFontOfSize:17];
    _titleSize  = [self caculateSizeForTitle:title];
}

- (void)setMenuImage:(UIImage *)image
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.contentMode  = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        _imageView             = imageView;
    }
    _imageView.image = image;
}

- (void)setMenuClickBlock:(void (^)(NSInteger))block
{
    _block = block;
}

- (void)selfDidClick:(UITapGestureRecognizer *)tap
{
    _backgroundView.hidden = YES;
    if (!_block) return;
    
    NSInteger tag = [tap view].tag;
    self.block(tag);
}

- (CGSize)caculateSizeForTitle:(NSString *)title
{
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    CGRect frame = [title boundingRectWithSize:maxSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName : self.label.font} context:nil];
    return CGSizeMake(frame.size.width + 6, frame.size.height + 4);
}

@end
