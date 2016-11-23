//
//  XQCycleImageView.m
//  Example
//
//  Created by NB-022 on 16/5/14.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import "XQCycleImageView.h"

@interface XQCycleImageView ()
@property (nonatomic, weak) UIScrollView *scrollView;
/**
 *  上一张ImageView
 */
@property (nonatomic, weak) UIImageView *previousImageView;
/**
 *  当前显示的ImageView
 */
@property (nonatomic, weak) UIImageView *currentImageView;
/**
 *  下一张ImageView
 */
@property (nonatomic, weak) UIImageView *nextImageView;
/**
 *  计时器
 */
@property (nonatomic, strong) CADisplayLink *timer;
/**
 *  是否正在拖拽
 */
@property (nonatomic, assign) BOOL isDragging;
@end

@implementation XQCycleImageView
{
    int i;
    int repCount;
}

+ (instancetype)cycleImageView
{
    return [[self alloc] initWithImages:nil delegate:nil];
}

+ (instancetype)cycleImageViewWithImages:(NSArray<UIImage *> *)images delegate:(id<XQCycleImageViewDelegate>)delegate
{
    return [[self alloc] initWithImages:images delegate:delegate];
}

- (instancetype)initWithImages:(NSArray<UIImage *> *)images delegate:(id<XQCycleImageViewDelegate>)delegate
{
    if (self = [super init]) {
        self.images   = images;
        self.delegate = delegate;
        [self setDefaultValue];
        [self creatView];
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer      = nil;
    self.images     = nil;
    self.delegate   = nil;
}

/**
 *  初始化默认值
 */
- (void)setDefaultValue
{
    i        = 0;
    repCount = 0;
    self.autoDragging = NO;
    self.repeatSecond = 1;
}

/**
 *  初始化View
 */
- (void)creatView
{
    UIScrollView *scrollView  = [[UIScrollView alloc] init];
    scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    scrollView.delegate       = self;
    scrollView.bounces        = NO;
    scrollView.pagingEnabled  = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator   = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    [self addTopConstraintWithItem:scrollView toView:self attribute:NSLayoutAttributeTop];
    [self addLeftConstraintWithItem:scrollView toView:self attribute:NSLayoutAttributeLeading];
    [self addRightConstraintWithItem:scrollView toView:self attribute:NSLayoutAttributeTrailing];
    [self addBottomConstraintWithItem:scrollView toView:self attribute:NSLayoutAttributeBottom];
    
    UIImageView *previousView = [[UIImageView alloc] init];
    previousView.contentMode  = UIViewContentModeScaleAspectFill;
    self.previousImageView    = previousView;
    [self.scrollView addSubview:previousView];
    previousView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addWidthConstraintWithItem:previousView toView:self addToView:self];
    [self addHeightConstraintWithItem:previousView toView:self addToView:self];
    [self addTopConstraintWithItem:previousView toView:self.scrollView attribute:NSLayoutAttributeTop];
    [self addLeftConstraintWithItem:previousView toView:self.scrollView attribute:NSLayoutAttributeLeading];
    [self addBottomConstraintWithItem:previousView toView:self.scrollView attribute:NSLayoutAttributeBottom];
    
    UIImageView *currentView  = [[UIImageView alloc] init];
    currentView.contentMode   = UIViewContentModeScaleAspectFill;
    self.currentImageView     = currentView;
    [self.scrollView addSubview:currentView];
    currentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addWidthConstraintWithItem:currentView toView:self addToView:self];
    [self addTopConstraintWithItem:currentView toView:self.scrollView attribute:NSLayoutAttributeTop];
    [self addLeftConstraintWithItem:currentView toView:previousView attribute:NSLayoutAttributeTrailing];
    [self addBottomConstraintWithItem:currentView toView:self.scrollView attribute:NSLayoutAttributeBottom];
    
    UIImageView *nextView     = [[UIImageView alloc] initWithFrame:CGRectZero];
    nextView.contentMode      = UIViewContentModeScaleAspectFill;
    self.nextImageView        = nextView;
    [self.scrollView addSubview:nextView];
    nextView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addWidthConstraintWithItem:nextView toView:self addToView:self];
    [self addTopConstraintWithItem:nextView toView:self.scrollView attribute:NSLayoutAttributeTop];
    [self addLeftConstraintWithItem:nextView toView:currentView attribute:NSLayoutAttributeTrailing];
    [self addRightConstraintWithItem:nextView toView:self.scrollView attribute:NSLayoutAttributeTrailing];
    [self addBottomConstraintWithItem:nextView toView:self.scrollView attribute:NSLayoutAttributeBottom];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewWasClick)];
    [self addGestureRecognizer:tap];
}

- (void)circleViewWasClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleImageView:didClickAtIndex:)]) {
        [self.delegate cycleImageView:self didClickAtIndex:i];
    }
}

- (void)layoutSubviews
{
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
}

/**
 *  懒加载，创建计时器
 */
- (CADisplayLink *)timer
{
    if (_timer == nil) {
        _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateImageView)];
        _timer.frameInterval = 60 * self.repeatSecond;
    }
    return _timer;
}

/**
 *  开始播放ImageView
 */
- (void)startPlayImageView
{
    if (!self.autoDragging) return;
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/**
 *  停止播放ImageView
 */
- (void)stopPlayImageView
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateImageView
{
    if (self.isDragging) return;
    
    if (repCount < self.repeatSecond) {
        repCount += self.repeatSecond;
        return;
    }
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.x += self.scrollView.bounds.size.width;
    if (contentOffset.x > self.scrollView.bounds.size.width * 2) {
        contentOffset.x = self.scrollView.bounds.size.width;
    }
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

- (void)setImages:(NSArray *)images
{
    if (_images == images) return;
    _images = images;
    if (_images == nil) return;
    
    self.previousImageView.image = [images objectAtIndex:images.count - 1];
    self.currentImageView.image  = [images objectAtIndex:0];
    self.nextImageView.image     = [images objectAtIndex:1];
}

#pragma mark - start 实现UIScrollViewDelegate协议
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (self.previousImageView.image == nil || self.nextImageView.image == nil) {
        UIImage *previousImage = [self.images objectAtIndex:(i == 0 ? self.images.count - 1 : i - 1)];
        self.previousImageView.image = previousImage;
        UIImage *nextImage     = [self.images objectAtIndex:(i == self.images.count - 1 ? 0 : i + 1)];
        self.nextImageView.image     = nextImage;
    }
    
    if (contentOffsetX == 0) {
        self.currentImageView.image  = self.previousImageView.image;
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
        self.previousImageView.image = nil;
        
        if (i == 0) i = (int)self.images.count - 1;
        else i--;
    }
    
    if (contentOffsetX == scrollView.bounds.size.width * 2) {
        self.currentImageView.image  = self.nextImageView.image;
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width, 0)];
        self.nextImageView.image     = nil;
        
        if (i == self.images.count - 1) i = 0;
        else i++;
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.isDragging = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleImageViewDidScrollingAnimation:atIndex:)]) {
        [self.delegate cycleImageViewDidScrollingAnimation:self atIndex:i];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cycleImageViewDidScrollingAnimation:atIndex:)]) {
        [self.delegate cycleImageViewDidScrollingAnimation:self atIndex:i];
    }
}
#pragma mark end 实现UIScrollViewDelegate协议

#pragma mark - start AutoLayout(添加约束)
/**
 *  添加顶部约束(公式：attr * multiplier + constant)
 *  @parameter : item       需要添加约束的视图
 *  @parameter : toView     关系对象
 *  @parameter : attr       关系对象的属性
 */
- (void)addTopConstraintWithItem:(id)item
                          toView:(id)toView
                       attribute:(NSLayoutAttribute)attr
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:0];
    [[item superview] addConstraint:layout];
}

- (void)addLeftConstraintWithItem:(id)item
                           toView:(id)toView
                        attribute:(NSLayoutAttribute)attr
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:0];
    [[item superview] addConstraint:layout];
}

- (void)addRightConstraintWithItem:(id)item
                            toView:(id)toView
                         attribute:(NSLayoutAttribute)attr
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:0];
    [[item superview] addConstraint:layout];
}

- (void)addBottomConstraintWithItem:(id)item
                             toView:(id)toView
                          attribute:(NSLayoutAttribute)attr
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:attr
                                                             multiplier:1.0
                                                               constant:0];
    [[item superview] addConstraint:layout];
}

- (void)addWidthConstraintWithItem:(id)item
                            toView:(id)toView
                         addToView:(UIView *)addToView
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeWidth
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:NSLayoutAttributeWidth
                                                             multiplier:1.0
                                                               constant:0];
    [addToView addConstraint:layout];
}

- (void)addHeightConstraintWithItem:(id)item
                             toView:(id)toView
                          addToView:(UIView *)addToView
{
    NSLayoutConstraint *layout = [NSLayoutConstraint constraintWithItem:item
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:toView
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:1.0
                                                               constant:0];
    [addToView addConstraint:layout];
}
#pragma mark end AutoLayout(添加约束)

@end
