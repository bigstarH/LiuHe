//
//  XQTextField.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "XQTextField.h"

@interface XQTextField () <UITextFieldDelegate>

@property (nonatomic, weak) UITextField *textField;

@property (nonatomic, weak) UILabel *label;

@end

@implementation XQTextField

@synthesize text = _text;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UITextField *textField = [[UITextField alloc] init];
    self.textField         = textField;
    textField.delegate     = self;
    [textField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:textField];
    
    UILabel *label = [[UILabel alloc] init];
    self.label     = label;
    [textField addSubview:label];
}

- (void)layoutSubviews
{
    CGFloat width   = self.bounds.size.width;
    CGFloat height  = self.bounds.size.height;
    self.textField.frame = self.bounds;
    
    CGFloat originX = 0;
    if (_leftView) {
        CGSize leftSize  = _leftView.bounds.size;
        CGFloat leftVH   = leftSize.height > height ? height : leftSize.height;
        CGFloat leftVW   = leftVH * leftSize.width / leftSize.height;
        CGFloat leftVY   = (height - leftVH) * 0.5;
        _leftView.frame  = CGRectMake(0, leftVY, leftVW, leftVH);
        originX += leftVW;
    }
    CGFloat labelW  = width - originX;
    if (_rightView) {
        CGSize rightSize = _rightView.bounds.size;
        CGFloat rightVH  = rightSize.height > height ? height : rightSize.height;
        CGFloat rightVW  = rightVH * rightSize.width / rightSize.height;
        CGFloat rightVY  = (height - rightVH) * 0.5;
        _rightView.frame = CGRectMake(0, rightVY, rightVW, rightVH);
        labelW           = labelW - rightVW;
    }
    self.label.frame     = CGRectMake(originX, 0, labelW, height);
}

#pragma mark - start getter
- (NSString *)text
{
    return self.textField.text;
}
#pragma mark end getter

#pragma mark - start setter
- (void)setText:(NSString *)text
{
    _text = text;
    self.textField.text = text;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder    = placeholder;
    self.label.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    self.label.textColor = placeholderColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textField.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    self.label.font     = font;
    self.textField.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    self.label.textAlignment     = textAlignment;
    self.textField.textAlignment = textAlignment;
}

- (void)setLeftViewMode:(UITextFieldViewMode)leftViewMode
{
    _leftViewMode = leftViewMode;
    self.textField.leftViewMode = leftViewMode;
}

- (void)setRightViewMode:(UITextFieldViewMode)rightViewMode
{
    _rightViewMode = rightViewMode;
    self.textField.rightViewMode = rightViewMode;
}

- (void)setBorderStyle:(UITextBorderStyle)borderStyle
{
    _borderStyle = borderStyle;
    self.textField.borderStyle = borderStyle;
}

- (void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;
    CGFloat imageW = leftImage.size.width + WIDTH(14);
    CGFloat imageH = leftImage.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    imageView.image        = leftImage;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    UIView *view   = [[UIView alloc] initWithFrame:CGRectMake(0, 0, imageW + WIDTH(10), imageH)];
    [view addSubview:imageView];
    self.leftView  = view;
}

- (void)setRightImage:(UIImage *)rightImage
{
    _rightImage    = rightImage;
    CGFloat imageW = rightImage.size.width + WIDTH(14);
    CGFloat imageH = rightImage.size.height;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageW, imageH)];
    imageView.image        = rightImage;
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    UIView *view   = [[UIView alloc] initWithFrame:CGRectMake(WIDTH(10), 0, imageW + WIDTH(10), imageH)];
    [view addSubview:imageView];
    self.rightView = view;
}

- (void)setLeftView:(UIView *)leftView
{
    [self.textField setLeftView:leftView];
    _leftView = leftView;
}

- (void)setRightView:(UIView *)rightView
{
    [self.textField setRightView:rightView];
    _rightView = rightView;
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry
{
    _secureTextEntry = secureTextEntry;
    self.textField.secureTextEntry = secureTextEntry;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.textField.tag = tag;
}
#pragma mark end setter
- (void)textfieldDidChange:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""]) {
        self.label.text = self.placeholder;
    }else {
        self.label.text = @"";
    }
}
#pragma mark - start UITextFieldDelegate

#pragma mark end UITextFieldDelegate
@end
