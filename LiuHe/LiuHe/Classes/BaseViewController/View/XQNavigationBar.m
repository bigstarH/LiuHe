//
//  XQNavigationBar.m
//  MyProject
//
//  Created by ufuns on 16/2/17.
//  Copyright © 2016年 ufuns. All rights reserved.
//  373

#import "XQNavigationBar.h"

@implementation XQNavigationBar
{
    CGFloat _titleW;
    CGFloat _titleRX;
    CGFloat _titleLX;
    BOOL _needsLayout;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatView];
        [self setDefaultValue];
    }
    return self;
}

- (void)dealloc
{
    _leftBarButtonItems  = nil;
    _rightBarButtonItems = nil;
}

#pragma mark - start 初始化事件
- (void)setDefaultValue
{
    _titleW               = 0;
    _needsLayout          = YES;
    self.backgroundColor  = [UIColor clearColor];
    self.backButtonHidden = YES;
    self.imageView.backgroundColor = [UIColor whiteColor];
}

- (void)creatView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    UIView *shadowView     = [[UIView alloc] init];
    _imageView             = imageView;
    _shadowView            = shadowView;
    
    [shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    
    [self addSubview:imageView];
    [self addSubview:shadowView];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [shadowView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addLeftConstraintWithItem:imageView toView:self attribute:NSLayoutAttributeLeading constant:0];
    [self addTopConstraintWithItem:imageView toView:self attribute:NSLayoutAttributeTop constant:0];
    [self addWidthConstraintWithItem:imageView toView:self attribute:NSLayoutAttributeWidth constant:0 addToView:self];
    [self addHeightConstraintItem:imageView height:64];
    
    [self addLeftConstraintWithItem:shadowView toView:self attribute:NSLayoutAttributeLeading constant:0];
    [self addTopConstraintWithItem:shadowView toView:imageView attribute:NSLayoutAttributeBottom constant:-1];
    [self addRightConstraintItem:shadowView toView:self attribute:NSLayoutAttributeTrailing constant:0];
    [self addHeightConstraintItem:shadowView height:1];
}
#pragma mark end 初始化事件

- (void)layoutSubviews
{
    if (!_needsLayout) return;
    
    [self updateTitleViewConstraint];
    
    _needsLayout = NO;
}

#pragma mark - start 私有方法
/** 判断XQBarButtonItem是否同时拥有图片和文字 */
- (BOOL)bothImageAndTitle:(XQBarButtonItem *)button
{
    UIImage *mImage = button.imageView.image;
    NSString *text  = button.titleLabel.text;
    if ((mImage) && (text) && (![text isEqualToString:@""])) return YES;
    return NO;
}

/** 按钮是否设有边距 */
- (BOOL)isSetEdgeInsert:(XQBarButtonItem *)button
{
    if (UIEdgeInsetsEqualToEdgeInsets(button.titleEdgeInsets, UIEdgeInsetsZero) && UIEdgeInsetsEqualToEdgeInsets(button.imageEdgeInsets, UIEdgeInsetsZero)) {
        return NO;
    }
    return YES;
}

/** 添加UIView的约束 */
- (void)addConstraint:(UIView *)btn toView:(UIView *)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant width:(CGFloat)width height:(CGFloat)height
{
    [btn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addLeftConstraintWithItem:btn toView:toView attribute:attr constant:constant];
    [self addTopConstraintWithItem:btn toView:self attribute:NSLayoutAttributeTop constant:28];
    [self addWidthConstraintItem:btn width:width];
    [self addHeightConstraintItem:btn height:height];
}

- (void)updateTitleViewConstraint
{
    if ((!_leftBarButtonItems) && (!_rightBarButtonItems)) {
        [self setTitleViewFrame:YES toView:nil attr:NSLayoutAttributeNotAnAttribute constant:0];
        return ;
    }
    
    XQBarButtonItem *leftBtn  = [self.leftBarButtonItems lastObject];
    XQBarButtonItem *rightBtn = [self.rightBarButtonItems lastObject];
    if (!leftBtn) leftBtn     = self.backBarButtonItem;
    if (leftBtn && (!rightBtn)) {
        if (_titleLX + 6 > (XQScreenWidth - _titleW) * 0.5) {
            [self setTitleViewFrame:NO toView:leftBtn attr:NSLayoutAttributeTrailing constant:6];
        }else {
            [self setTitleViewFrame:YES toView:nil attr:NSLayoutAttributeNotAnAttribute constant:0];
        }
        return ;
    }
    
    if (rightBtn && (!leftBtn)) {
        if (XQScreenWidth + _titleRX < (XQScreenWidth + _titleW) * 0.5) {
            [self setTitleViewFrame:NO toView:rightBtn attr:NSLayoutAttributeLeading constant:-(6 + _titleW)];
        }else {
            [self setTitleViewFrame:YES toView:nil attr:NSLayoutAttributeNotAnAttribute constant:0];
        }
        return ;
    }
    
    if (leftBtn && rightBtn) {
        if (XQScreenWidth + _titleRX < (XQScreenWidth + _titleW) * 0.5) {
            [self setTitleViewFrame:NO toView:rightBtn attr:NSLayoutAttributeLeading constant:-(6 + _titleW)];
        }else if (_titleLX + 6 > (XQScreenWidth - _titleW) * 0.5) {
            [self setTitleViewFrame:NO toView:leftBtn attr:NSLayoutAttributeTrailing constant:6];
        }else {
            [self setTitleViewFrame:YES toView:nil attr:NSLayoutAttributeNotAnAttribute constant:0];
        }
    }
}

- (void)setTitleViewFrame:(BOOL)isCenter toView:(UIView *)toView attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    [_titleView setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSArray *titleConstraint = self.titleView.constraints;
    if (titleConstraint) {
        [self.titleView removeConstraints:titleConstraint];
    }
    
    if (isCenter) {
        [self addCenterXConstraintItem:_titleView toView:self attribute:NSLayoutAttributeCenterX constant:0];
        [self addCenterYConstraintItem:_titleView toView:self attribute:NSLayoutAttributeCenterY constant:9.5];
    }else {
        [self addTopConstraintWithItem:_titleView toView:self attribute:NSLayoutAttributeTop constant:28];
        [self addLeftConstraintWithItem:_titleView toView:toView attribute:attr constant:constant];
    }
    [self addWidthConstraintItem:_titleView width:_titleW];
    [self addHeightConstraintItem:_titleView height:27];
}
#pragma mark end 私有方法

#pragma mark - start 对外提供的API接口
- (void)setShadowHidden:(BOOL)shadowHidden
{
    self.shadowView.hidden = shadowHidden;
}

/** 设置导航栏背景颜色 */
- (void)setBarTintColor:(UIColor *)color
{
    self.imageView.image = nil;
    if (self.imageView.backgroundColor != color) {
        self.imageView.backgroundColor = color;
    }
}

/** 设置背景图片 */
- (void)setBackgroundImage:(UIImage *)image
{
    if (self.imageView.image != image) {
        self.imageView.image = image;
    }
}

/** 设置标题 */
- (void)setTitleView:(UIView *)titleView
{
    if (_titleView != titleView) {
        [_titleView removeFromSuperview];
        [titleView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:titleView];
        _titleView = titleView;
        _titleW    = CGRectGetWidth(titleView.frame);
    }
}

/** 设置"返回按钮"字体颜色 */
- (void)setBackButtonTitleColor:(UIColor *)color
{
    [self.backBarButtonItem setTitleColor:color forState:UIControlStateNormal];
}

/** 设置左部按钮 */
- (void)setLeftBarButtonItem:(XQBarButtonItem *)leftBarButtonItem
{
    if (!leftBarButtonItem) return;
    [_backBarButtonItem removeFromSuperview];
    [_leftBarButtonItem removeFromSuperview];
    if ([self bothImageAndTitle:leftBarButtonItem] && (![self isSetEdgeInsert:leftBarButtonItem])) {
        [leftBarButtonItem setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
        [leftBarButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
    }
    NSMutableArray *array   = [NSMutableArray arrayWithObject:leftBarButtonItem];
    [array addObjectsFromArray:_leftBarButtonItems];
    if (array.count > 1) {
        [array removeObjectAtIndex:1];
    }
    self.leftBarButtonItems = array;
}

/** 设置左部按钮数组 */
- (void)setLeftBarButtonItems:(NSArray<XQBarButtonItem *> *)leftBarButtonItems
{
    if (!leftBarButtonItems) return;
    if (_leftBarButtonItems) {
        for (XQBarButtonItem *leftBtn in _leftBarButtonItems) {
            [leftBtn removeFromSuperview];
        }
    }
    [_backBarButtonItem removeFromSuperview];
    
    _titleLX              = barButtonItemsDistance;
    _leftBarButtonItems   = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < leftBarButtonItems.count; i++) {
        XQBarButtonItem *btn = [leftBarButtonItems objectAtIndex:i];
        if ([self bothImageAndTitle:btn] && (![self isSetEdgeInsert:btn])) {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
        }
        CGFloat btnW = [btn barButtonItemWidth];
        [array addObject:btn];
        [self addSubview:btn];
        if (i == 0) {
            [self addConstraint:btn toView:self attribute:NSLayoutAttributeLeading constant:barButtonItemsDistance
                          width:btnW height:30];
        }else {
            XQBarButtonItem *lastbtn = [leftBarButtonItems objectAtIndex:i - 1];
            [self addConstraint:btn toView:lastbtn attribute:NSLayoutAttributeTrailing constant:barButtonItemsDistance
                          width:btnW height:30];
        }
        _titleLX += (btnW + barButtonItemsDistance);
    }
    _leftBarButtonItems = array;
    _leftBarButtonItem  = [_leftBarButtonItems firstObject];
}

/** 设置右边按钮 */
- (void)setRightBarButtonItem:(XQBarButtonItem *)rightBarButtonItem
{
    if (!rightBarButtonItem) return;
    
    [_rightBarButtonItem removeFromSuperview];
    if ([self bothImageAndTitle:rightBarButtonItem] && (![self isSetEdgeInsert:rightBarButtonItem])) {
        [rightBarButtonItem setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
        [rightBarButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithObject:rightBarButtonItem];
    [array addObjectsFromArray:_rightBarButtonItems];
    if (array.count > 1) {
        [array removeObjectAtIndex:1];
    }
    self.rightBarButtonItems = array;
}

/** 右边按钮数组 */
- (void)setRightBarButtonItems:(NSArray<XQBarButtonItem *> *)rightBarButtonItems
{
    if (!rightBarButtonItems) return;
    if (_rightBarButtonItems) {
        for (XQBarButtonItem *rightBtn in _rightBarButtonItems) {
            [rightBtn removeFromSuperview];
        }
    }
    _titleRX              = 0;
    _rightBarButtonItems  = nil;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < rightBarButtonItems.count; i++) {
        XQBarButtonItem *btn = [rightBarButtonItems objectAtIndex:i];
        if ([self bothImageAndTitle:btn] && (![self isSetEdgeInsert:btn])) {
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
        }
        CGFloat btnW      = [btn barButtonItemWidth];
        CGFloat buttonDis = -(barButtonItemsDistance + btnW);
        [array addObject:btn];
        [self addSubview:btn];
        if (i == 0) {
            [self addConstraint:btn toView:self attribute:NSLayoutAttributeTrailing constant:buttonDis width:btnW height:30];
        }else {
            XQBarButtonItem *lastbtn = [rightBarButtonItems objectAtIndex:i - 1];
            [self addConstraint:btn toView:lastbtn attribute:NSLayoutAttributeLeading constant:buttonDis width:btnW height:30];
        }
        _titleRX += buttonDis;
    }
    _rightBarButtonItems = array;
    _rightBarButtonItem  = [array firstObject];
}

/** 设置是否隐藏返回按钮 */
- (void)setBackButtonHidden:(BOOL)backButtonHidden
{
    _backButtonHidden  = backButtonHidden;
    if (backButtonHidden) return;
    [_backBarButtonItem removeFromSuperview]; 
    XQBarButtonItem *button = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_normal"]
                                                    highlightedImage:[UIImage imageNamed:@"back_press"]
                                                               title:@"返回"
                                                    titleNormalColor:RGBCOLOR(14, 107, 255)
                                               titleHighlightedColor:RGBCOLOR(131, 174, 237)];
    CGFloat backBtnW   = [button barButtonItemWidth];
    _backBarButtonItem = button;
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
    [button addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [self addConstraint:button toView:self attribute:NSLayoutAttributeLeading constant:barButtonItemsDistance width:backBtnW height:30];
}

/** 设置返回按钮 */
- (void)setBackBarButtonItem:(XQBarButtonItem *)backBarButtonItem
{
    if (self.isBackButtonHidden) return;
    UIImage *mImage  = [UIImage imageNamed:@"back_normal"];
    CGFloat backBtnW = [backBarButtonItem barButtonItemWidth];
    if (backBarButtonItem.imageView.image == nil) {
        [backBarButtonItem setImage:mImage forState:UIControlStateNormal];
        backBtnW = backBtnW + mImage.size.width;
    }
    if (backBtnW > 160) {
        backBtnW = 48;
        [backBarButtonItem setTitle:@"返回" forState:UIControlStateNormal];
    }else {
        [backBarButtonItem setImageEdgeInsets:UIEdgeInsetsMake(0, -1, 0, 1)];
        [backBarButtonItem setTitleEdgeInsets:UIEdgeInsetsMake(0, 1, 0, -1)];
    }
    [backBarButtonItem setImage:[UIImage imageNamed:@"back_press"] forState:UIControlStateHighlighted];
    [backBarButtonItem setTitleColor:RGBCOLOR(131, 174, 237) forState:UIControlStateHighlighted];
    [_backBarButtonItem removeFromSuperview];
    _backBarButtonItem = backBarButtonItem;
    [self addSubview:_backBarButtonItem];
    [self addConstraint:backBarButtonItem toView:self attribute:NSLayoutAttributeLeading constant:barButtonItemsDistance width:backBtnW height:30];
}
#pragma mark end 对外提供的API接口

#pragma mark - start 返回事件(XQNavigationBarDelegate协议)
- (void)goBack:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goBackWithNavigationBar:)]) {
        [self.delegate goBackWithNavigationBar:self];
    }
}
#pragma mark end 返回事件(XQNavigationBarDelegate协议)

#pragma mark - start 添加约束
- (void)addLeftConstraintWithItem:(UIView *)item toView:(id)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:constant];
    [item.superview addConstraint:layout];
}

- (void)addRightConstraintItem:(UIView *)item toView:(id)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:constant];
    [item.superview addConstraint:layout];
}

- (void)addTopConstraintWithItem:(UIView *)item toView:(id)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:constant];
    [item.superview addConstraint:layout];
}

- (void)addWidthConstraintWithItem:(UIView *)item toView:(id)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant addToView:(UIView *)addToView
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:constant];
    [addToView addConstraint:layout];
}

- (void)addWidthConstraintItem:(UIView *)item width:(CGFloat)width
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:width];
    [self addConstraint:layout];
}

- (void)addHeightConstraintItem:(UIView *)item height:(CGFloat)height
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:height];
    [self addConstraint:layout];
}

- (void)addCenterXConstraintItem:(UIView *)item toView:(id)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:constant];
    [item.superview addConstraint:layout];
}

- (void)addCenterYConstraintItem:(UIView *)item toView:(id)toView attribute:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:constant];
    [item.superview addConstraint:layout];
}
#pragma mark end 添加约束
@end
