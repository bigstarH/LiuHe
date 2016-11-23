//
//  XQFasciatePageControl.m
//  Example
//
//  Created by 胡兴钦 on 2016/11/18.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#define animationTime 0.18

#import "XQFasciatePageControl.h"

@interface XQFasciatePageControl ()

@property (nonatomic) CGFloat pageDistance;

@property (nonatomic, weak) CAShapeLayer *currentLayer;

@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation XQFasciatePageControl
{
    BOOL _needLayout;
}

+ (instancetype)pageControl
{
    return [self pageControlWithFrame:CGRectZero];
}

+ (instancetype)pageControlWithFrame:(CGRect)frame
{
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initDefaultValue];
        [self createLayer];
    }
    return self;
}

- (void)initDefaultValue
{
    _needLayout    = YES;
    _numberOfPages = 0;
    _sizeForPages  = CGSizeMake(WIDTH(6), WIDTH(6));
    _pageDistance  = _sizeForPages.width + 2;
    _currentPage   = 0;
    _currentPageIndicatorTintColor = [UIColor redColor];
    _pageIndicatorTintColor        = [UIColor yellowColor];
}

- (void)createLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    self.currentLayer   = layer;
    [layer setZPosition:100];
    [self.layer addSublayer:layer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_needLayout) return;
    
    [self.array removeAllObjects];
    
    CGFloat width    = self.bounds.size.width;
    CGFloat height   = self.bounds.size.height;
    CGFloat originY  = (height - _sizeForPages.height) * 0.5;
    
    CGFloat currentWidth = _sizeForPages.width * 2;
    CGFloat originX  = (width - ((_sizeForPages.width + _pageDistance) * (_numberOfPages - 1) + currentWidth)) * 0.5;
    CGFloat currentX = _currentPage ? (_currentPage * (_sizeForPages.width + _pageDistance)) + originX : originX;
    [self.currentLayer setFillColor:_currentPageIndicatorTintColor.CGColor];
    [self.currentLayer setFrame:CGRectMake(currentX, originY, currentWidth, _sizeForPages.height)];
    [self.currentLayer setPath:[UIBezierPath bezierPathWithRoundedRect:self.currentLayer.bounds
                                                     byRoundingCorners:UIRectCornerAllCorners
                                                           cornerRadii:CGSizeMake(_sizeForPages.width * 0.5, _sizeForPages.width * 0.5)].CGPath];
    
    originX = _currentPage ? originX : (originX + currentWidth + _pageDistance);
    for (int i = 0; i < _numberOfPages; i++) {
        if (i == _currentPage) {
            if (_currentPage != 0) {
                originX += (currentWidth + _pageDistance);
            }
            [self.array addObject:self.currentLayer];
            continue;
        }
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor     = _pageIndicatorTintColor.CGColor;
        [layer setZPosition:-1];
        [layer setFrame:CGRectMake(originX, originY, _sizeForPages.width, _sizeForPages.height)];
        [layer setPath:[UIBezierPath bezierPathWithOvalInRect:layer.bounds].CGPath];
        [self.layer addSublayer:layer];
        [self.array addObject:layer];
        originX += (_pageDistance + _sizeForPages.width);
    }
    
    _needLayout = NO;
}

#pragma mark - start 动画移动当前页
- (void)movePageWithCurrentPage:(NSInteger)currentPage targetPage:(NSInteger)targetPage
{
    if (self.array.count <= 0) return;
    
    CAShapeLayer *layer = [self.array objectAtIndex:targetPage];
    CGRect targetFrame  = layer.frame;
    
    // 修改currentLayer的frame
    CGRect originFrame = self.currentLayer.frame;
    CGRect frame       = self.currentLayer.frame;
    if (targetPage > currentPage) {
        frame.origin.x = CGRectGetMaxX(targetFrame) - frame.size.width;
    }else {
        frame.origin.x = targetFrame.origin.x;
    }
    [UIView animateWithDuration:animationTime animations:^{
        self.currentLayer.frame = frame;
    }];
    
    // 修改otherpage的frame
    if (targetPage > currentPage) {
        targetFrame.origin.x = originFrame.origin.x;
        CGFloat originX      = CGRectGetMinX(frame);
        for (NSInteger i = targetPage - 1, j = 1; i > currentPage; i--, j++) {
            CAShapeLayer *shapeLayer = [self.array objectAtIndex:i];
            CGRect sFrame   = shapeLayer.frame;
            sFrame.origin.x = originX - j * (sFrame.size.width + _pageDistance);
            [UIView animateWithDuration:animationTime animations:^{
                shapeLayer.frame = sFrame;
            }];
        }
    }else {
        targetFrame.origin.x = CGRectGetMaxX(originFrame) - targetFrame.size.width;
        CGFloat originX  = CGRectGetMaxX(frame) + _pageDistance;
        for (NSInteger i = targetPage + 1, j = 0; i < currentPage; i++, j++) {
            CAShapeLayer *shapeLayer = [self.array objectAtIndex:i];
            CGRect sFrame   = shapeLayer.frame;
            sFrame.origin.x = originX + j * (sFrame.size.width + _pageDistance);
            [UIView animateWithDuration:animationTime animations:^{
                shapeLayer.frame = sFrame;
            }];
        }
    }
    [UIView animateWithDuration:animationTime animations:^{
        layer.frame = targetFrame;
    }];
    
    // 交换
    self.array[currentPage] = layer;
    self.array[targetPage]  = self.currentLayer;
}
#pragma mark end 动画移动当前页

#pragma mark - start 懒加载
- (NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}
#pragma mark end 懒加载

#pragma mark - start setter
- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage == _currentPage) return;
    [self movePageWithCurrentPage:_currentPage targetPage:currentPage];
    _currentPage = currentPage;
}
#pragma mark end setter

@end
