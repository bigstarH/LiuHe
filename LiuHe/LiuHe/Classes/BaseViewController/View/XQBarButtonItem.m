//
//  XQBarButtonItem.m
//  MyProject
//
//  Created by ufuns on 16/2/18.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import "XQBarButtonItem.h"

@implementation XQBarButtonItem

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self setTitleColor:[UIColor colorWithRed:14/255.0 green:107/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:131/255.0 green:174/255.0 blue:237/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    if (self = [super init]) {
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    if (self = [super init]) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title
{
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self setImage:image forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:14/255.0 green:107/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:131/255.0 green:174/255.0 blue:237/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage title:(NSString *)title
{
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
        [self setTitleColor:[UIColor colorWithRed:14/255.0 green:107/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:131/255.0 green:174/255.0 blue:237/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                        title:(NSString *)title
             titleNormalColor:(UIColor *)titleNormalColor
{
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
        [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                        title:(NSString *)title
             titleNormalColor:(UIColor *)titleNormalColor
        titleHighlightedColor:(UIColor *)titleHighlightedColor
{
    if (self = [super init]) {
        [self setTitle:title forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:highlightedImage forState:UIControlStateHighlighted];
        [self setTitleColor:titleNormalColor forState:UIControlStateNormal];
        [self setTitleColor:titleHighlightedColor forState:UIControlStateHighlighted];
    }
    return self;
}

- (CGSize)barButtonItemSize
{
    CGFloat width   = 0;
    CGFloat height  = 0;
    NSString *title = self.titleLabel.text;
    if (title) {
        NSDictionary *dict = @{NSFontAttributeName : self.titleLabel.font};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(XQScreenWidth, 30)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:dict
                                          context:nil];
        width  = width + rect.size.width;
        height = height + rect.size.height;
    }
    UIImageView *imageView = self.imageView;
    if (imageView) {
        width  = width  + imageView.image.size.width;
        height = height + imageView.image.size.height;
    }
    return CGSizeMake(width + XQEdgeInsertW, height + XQEdgeInsertW);
}

- (CGFloat)titleLabelWidth
{
    CGFloat width   = 0;
    NSString *title = self.titleLabel.text;
    if (title) {
        NSDictionary *dict = @{NSFontAttributeName : self.titleLabel.font};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(XQScreenWidth, 30)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:dict
                                          context:nil];
        width = width + rect.size.width;
    }
    return width;
}

- (CGFloat)ImageViewWidth
{
    CGFloat width   = 0;
    UIImageView *imageView = self.imageView;
    if (imageView) {
        width = width + imageView.image.size.width;
    }
    return width;
}

@end
