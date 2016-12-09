//
//  XQTextView.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/11/26.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "XQTextView.h"

@interface XQTextView () <UITextViewDelegate>

@property (nonatomic, weak) UILabel *label;

@end

@implementation XQTextView

@synthesize text = _text;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
        [self setDefaultValue];
    }
    return self;
}

- (void)setDefaultValue
{
    self.placeholder   = @"";
    self.text          = @"";
    self.textColor     = [UIColor blackColor];
    self.font          = [UIFont systemFontOfSize:fontSize(14)];
    self.textAlignment    = NSTextAlignmentLeft;
    self.placeholderColor = nil;
}

- (void)createView
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    _textView            = textView;
    textView.delegate    = self;
    [self addSubview:textView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.label     = label;
    label.enabled  = NO;
    [textView addSubview:label];
}

- (void)layoutSubviews
{
    if (!CGRectEqualToRect(self.textView.frame, CGRectZero)) return;
    
    self.textView.frame = self.bounds;
    CGFloat labelW      = self.bounds.size.width - 2 * WIDTH(5);
    self.label.frame    = CGRectMake(WIDTH(5), HEIGHT(2), labelW, HEIGHT(30));
}

#pragma mark - start getter
- (NSString *)text
{
    return self.textView.text;
}
#pragma mark end getter

#pragma mark - start setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    _label.text  = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor    = placeholderColor;
    if (placeholderColor == nil) return;
    
    _label.enabled   = YES;
    _label.textColor = placeholderColor;
}

- (void)setText:(NSString *)text
{
    _text          = text;
    _textView.text = text;
    if (text && ![text isEqualToString:@""]) {
        _label.text = @"";
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _textView.textColor = textColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _textView.font = font;
    _label.font    = font;
}

- (void)setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType
{
    _autocapitalizationType          = autocapitalizationType;
    _textView.autocapitalizationType = autocapitalizationType;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    _textView.textAlignment = textAlignment;
    _label.textAlignment    = textAlignment;
}

- (BOOL)resignFirstResponder
{
    [_textView resignFirstResponder];
    return [super resignFirstResponder];
}
#pragma mark end setter

#pragma mark - start UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.delegate textViewShouldBeginEditing:self.textView];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.delegate textViewShouldEndEditing:self.textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.delegate textViewDidBeginEditing:self.textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.delegate textViewDidEndEditing:self.textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.delegate textView:self.textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

/** textView内容变化时调用 */
- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    if ([text isEqualToString:@""]) { // 没有内容时，显示提示语
        self.label.text = self.placeholder;
    }else {
        self.label.text = @"";
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.delegate textViewDidChange:self.textView];
    }
}
#pragma mark end UITextViewDelegate
@end
