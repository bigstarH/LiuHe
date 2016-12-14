//
//  MenuItem.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MenuItem.h"
#import "NSString+Extension.h"

@interface MenuItem ()

@property (nonatomic, weak) UIView *backgroundView;

@property (nonatomic, copy) void (^block)(NSInteger);

@end

@implementation MenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _highlightedType       = MenuItemHighlightedTypeDefault;
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _backgroundView        = backgroundView;
        backgroundView.hidden  = YES;
        [backgroundView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.3)];
        [self addSubview:backgroundView];
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidClick:)]];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.hidden = NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    if ([self boundsContainsPoint:location bounds:self.bounds scale:1.5]) {
        self.backgroundView.hidden = NO;
    }else {
        self.backgroundView.hidden = YES;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _backgroundView.frame = self.bounds;
    
    switch (_highlightedType) {
        case MenuItemHighlightedTypeWhiteAndFront:
        {
            _backgroundView.backgroundColor = RGBACOLOR(255, 255, 255, 0.5);
            [self bringSubviewToFront:_backgroundView];
            break;
        }
        default:
            break;
    }
    
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
    _titleSize  = [title realSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) font:font];
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

- (BOOL)boundsContainsPoint:(CGPoint)point bounds:(CGRect)bounds scale:(CGFloat)scale
{
    CGFloat originX = bounds.origin.x;
    CGFloat originY = bounds.origin.y;
    CGFloat width   = bounds.size.width;
    CGFloat height  = bounds.size.height;
    CGRect rect     = CGRectMake(originX - width * (scale - 1) * 0.5 , originY - height * (scale - 1) * 0.5, width * scale, height * scale);
    return CGRectContainsPoint(rect, point);
}

@end
