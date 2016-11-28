//
//  XQSegmentedControl.m
//  Example
//
//  Created by NB-022 on 16/5/19.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#define EdgeInsets 0

#import "XQSegmentedControl.h"

@interface XQSegmentedControl ()

/** segment内容数组(text或者image) */
@property (nonatomic, strong) NSArray *items;

/** 包含未选中状态的segment */
@property (nonatomic, weak) UIView *contentView;

/** 包含选中状态的segment */
@property (nonatomic, weak) UIView *selectedContentView;

/** 遮罩层 */
@property (nonatomic, strong) UIView *segmentMask;

/** 遮罩层的frame */
@property (nonatomic, assign) CGRect segmentMaskRect;

/** 拖动时，上次拖动的位置 */
@property (nonatomic, assign) CGPoint lastTouchPoint;

/** 每个segment的宽度 */
@property (nonatomic, assign) CGFloat segmentWidth;

/** 拖动，慢速移动手势 */
@property (nonatomic, weak) UIPanGestureRecognizer *pan;

@end

IB_DESIGNABLE
@implementation XQSegmentedControl

+ (instancetype)segmentedControlWithItems:(NSArray *)items
{
    return [[self alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray *)items
{
    if (self = [super initWithFrame:CGRectZero]) {
        [self initDefaultValue];
        self.items = items;
        [self initView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initDefaultValue];
        [self initView];
    }
    return self;
}

- (void)initDefaultValue
{
    _font                    = [UIFont systemFontOfSize:14];
    _tintColor               = [UIColor redColor];
    _textColor               = [UIColor whiteColor];
    _cornerRadius            = 0.0;
    _selectedTextColor       = [UIColor redColor];
    _selectedBackgroundColor = [UIColor whiteColor];
}

- (void)initView
{
    UIView *contentView         = [[UIView alloc] init];
    UIView *selectedContentView = [[UIView alloc] init];
    self.contentView            = contentView;
    self.selectedContentView    = selectedContentView;
    [self addSubview:contentView];
    [self addSubview:selectedContentView];
    [contentView setBackgroundColor:self.tintColor];
    [selectedContentView setBackgroundColor:self.selectedBackgroundColor];
    
    // 遮罩层
    self.segmentMask                 = [[UIView alloc] init];
    self.segmentMask.backgroundColor = self.selectedBackgroundColor;
    selectedContentView.layer.mask   = self.segmentMask.layer;
    
    // 添加手势
    [self addGesture];
}

- (void)layoutSubviews
{
    self.contentView.frame         = self.bounds;
    self.selectedContentView.frame = self.bounds;
    
    if (_numberOfSegments != 0) [self setUpSegmentsFrame];
}

#pragma mark - start 添加手势
- (void)addGesture
{
    // 轻触手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    // 拖动，慢速移动手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
    self.pan = pan;
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
}

- (void)tapEvent:(UITapGestureRecognizer *)tap
{
    CGPoint touchPoint = [tap locationInView:self];
    NSArray *array     = self.contentView.subviews;
    for (int i = 0; i < array.count; i++) {
        UIView *item   = [array objectAtIndex:i];
        if (CGRectContainsPoint(item.frame, touchPoint)) {
            _selectedSegmentIndex = i;
            [UIView animateWithDuration:0.2
                             animations:^{
                                 [self.segmentMask setCenter:item.center];
                             } completion:nil];
            break;
        }
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

/** 拖动事件 */
- (void)panEvent:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.segmentMaskRect = self.segmentMask.frame;
        self.lastTouchPoint  = [pan locationInView:self];
        
    }else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint touchPoint   = [pan locationInView:self];
        CGRect frame         = self.segmentMaskRect;
        frame.origin.x      += touchPoint.x - self.lastTouchPoint.x;
        if (frame.origin.x < 2) frame.origin.x = 2;
        if (frame.origin.x > self.bounds.size.width - frame.size.width - 2)
            frame.origin.x = self.bounds.size.width - frame.size.width - 2;
        self.segmentMask.frame = frame;
        
    }else if (pan.state == UIGestureRecognizerStateEnded ||
              pan.state == UIGestureRecognizerStateFailed ||
              pan.state == UIGestureRecognizerStateCancelled) {
        CGPoint touchPoint  = [pan locationInView:self];
        if (touchPoint.x < 0) touchPoint.x = 0;
        if (touchPoint.x > self.bounds.size.width)
            touchPoint.x = self.bounds.size.width - 1;
        BOOL toRight = touchPoint.x > self.lastTouchPoint.x;
        for (int i = 0; i < self.contentView.subviews.count; i++) {
            UIView *item = [self.contentView.subviews objectAtIndex:i];
            if (CGRectContainsPoint(item.frame, touchPoint)) {
                if (toRight) {
                    if (CGRectGetMaxX(item.frame) >= touchPoint.x) {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.segmentMask.center = item.center;
                        }];
                        _selectedSegmentIndex = i;
                    }else {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.segmentMask.center = CGPointMake(item.center.x + self.segmentWidth, item.center.y);
                        }];
                        _selectedSegmentIndex = i + 1;
                    }
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }else {
                    if (CGRectGetMinX(item.frame) <= touchPoint.x) {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.segmentMask.center = item.center;
                        }];
                        _selectedSegmentIndex = i;
                    }else {
                        [UIView animateWithDuration:0.2 animations:^{
                            self.segmentMask.center = CGPointMake(item.center.x - self.segmentWidth, item.center.y);
                        }];
                        _selectedSegmentIndex = i - 1;
                    }
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                }
                break;
            }
        }
    }
}
#pragma mark end 添加手势

#pragma mark - start 根据item数组的内容，初始化label和imageView视图
- (void)setItems:(NSArray *)items
{
    if (_items) return;
    
    _items            = items;
    _numberOfSegments = items.count;
    for (int i = 0; i < _numberOfSegments; i++) {
        id item = [items objectAtIndex:i];
        if ([item isKindOfClass:[NSString class]]) {
            UILabel *label = [self createLabelWithText:item textColor:self.textColor];
            UILabel *selectedLabel = [self createLabelWithText:item textColor:self.selectedTextColor];
            [self.contentView addSubview:label];
            [self.selectedContentView addSubview:selectedLabel];
        }else if ([item isKindOfClass:[UIImage class]]) {
            UIImageView *imageView = [self createImageViewWithImage:item];
            UIImageView *selectedImageView = [self createImageViewWithImage:item];
            [self.contentView addSubview:imageView];
            [self.selectedContentView addSubview:selectedImageView];
        }
    }
    
    if (!CGRectEqualToRect(self.bounds, CGRectZero)) {
        [self setUpSegmentsFrame];
    }
}

/** 快速创建一个UILabel */
- (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor
{
    UILabel *label = [[UILabel alloc] init];
    [label setText:text];
    [label setTextColor:textColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:self.font];
    return label;
}

/** 快速创建一个UIImageView */
- (UIImageView *)createImageViewWithImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image        = image;
    imageView.contentMode  = UIViewContentModeCenter;
    return imageView;
}

/** 设置每个segment的frame */
- (void)setUpSegmentsFrame
{
    self.segmentWidth        = self.contentView.bounds.size.width / _numberOfSegments;
    CGFloat segmentH         = self.contentView.bounds.size.height;
    NSArray *array           = self.contentView.subviews;
    NSArray *selectedArray   = self.selectedContentView.subviews;
    for (int i = 0; i < _numberOfSegments; i++) {
        CGFloat segmentX     = i * self.segmentWidth;
        UIView *item         = [array objectAtIndex:i];
        UIView *selectedItem = [selectedArray objectAtIndex:i];
        item.frame           = CGRectMake(segmentX, 0, self.segmentWidth, segmentH);
        selectedItem.frame   = CGRectMake(segmentX, 0, self.segmentWidth, segmentH);
        
        if (i == 0) { // 默认遮罩层的frame在第一个segment上
            self.segmentMask.frame = CGRectInset(item.frame, EdgeInsets, EdgeInsets);
        }
    }
}
#pragma mark end 根据item数组的内容，初始化label和imageView视图

#pragma mark - start 重写set方法
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius                 = cornerRadius;
    self.layer.cornerRadius       = cornerRadius;
    self.layer.masksToBounds      = YES;
    self.segmentMask.layer.cornerRadius = cornerRadius - EdgeInsets;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (UIView *item in _contentView.subviews) {
        if ([item isKindOfClass:[UILabel class]]) {
            UILabel *label  = (UILabel *)item;
            label.textColor = textColor;
        }
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    _selectedTextColor = selectedTextColor;
    for (UIView *item in _selectedContentView.subviews) {
        if ([item isKindOfClass:[UILabel class]]) {
            UILabel *label  = (UILabel *)item;
            label.textColor = selectedTextColor;
        }
    }
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    _selectedBackgroundColor = selectedBackgroundColor;
    self.selectedContentView.backgroundColor = selectedBackgroundColor;
    self.segmentMask.backgroundColor         = self.selectedBackgroundColor;
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    self.contentView.backgroundColor = tintColor;
}

- (void)setPanEnabled:(BOOL)panEnabled
{
    _panEnabled = panEnabled;
    if (!panEnabled) {
        [self removeGestureRecognizer:self.pan];
    }
}

- (void)setFont:(UIFont *)font
{
    _font                  = font;
    NSArray *array         = self.contentView.subviews;
    NSArray *selectedArray = self.selectedContentView.subviews;
    for (int i = 0; i < _numberOfSegments; i++) {
        UIView *item  = [array objectAtIndex:i];
        UIView *sitem = [selectedArray objectAtIndex:i];
        if ([item isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)item;
            label.font     = font;
        }
        if ([sitem isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)sitem;
            label.font     = font;
        }
    }
}
#pragma mark end 重写set方法

@end
