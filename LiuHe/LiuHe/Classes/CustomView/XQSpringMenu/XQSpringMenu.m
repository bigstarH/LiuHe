//
//  XQSpringMenu.m
//  Example
//
//  Created by NB-022 on 16/4/29.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import "XQSpringMenu.h"

#define XQWindow [UIApplication sharedApplication].keyWindow
#define ITEM_SPACE_VERTICAL 16
#define ITEM_SPACE_HORIZONTAL (SCREEN_WIDTH - self.menuItemSize.width * self.column) / (self.column + 1)
#define UNSIGNED_NUMBER(number) (number > 0 ? number - 1 : 0)

@interface XQSpringMenu () <CAAnimationDelegate>

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) void (^selectBlock)(XQSpringMenu *menu, NSInteger index, NSString *menuTitle);

@property (nonatomic, copy) void (^didCloseBlock)(XQSpringMenu *menu);

@end

@implementation XQSpringMenu
{
    NSInteger _count;
}

+ (instancetype)springMenu
{
    return [self springMenuWithItems:nil];
}

+ (instancetype)springMenuWithItems:(NSArray *)items
{
    return [[self alloc] initWithItems:items];
}

- (instancetype)initWithItems:(NSArray *)items
{
    if (self = [super init]) {
        [self initDefaultValue];
        self.items = items;
        [self creatView];
    }
    return self;
}

- (void)dealloc
{
    self.items         = nil;
    self.delegate      = nil;
    self.selectBlock   = nil;
    self.didCloseBlock = nil;
}

#pragma mark - start 初始化UI和数据
- (void)creatView
{
    self.frame = [UIScreen mainScreen].bounds;
    [self setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.92]];
    [XQWindow addSubview:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgImageDidClick)];
    [self addGestureRecognizer:tap];
}

- (void)initDefaultValue
{
    _row                   = 0;
    _column                = 3;
    _menuItemSize          = CGSizeMake(WIDTH(56), HEIGHT(86)); //CGSizeMake(WIDTH(71), HEIGHT(100));
    _bottomInsets          = HEIGHT(50);
    _animationDelay        = 0.036;
    _fontSize              = fontSize(13);
    _count                 = 0;
    _animationTime         = 0.2;
    _dismissAnimationTime  = 0.2;
    _fadeAnimation         = YES;
    _dismissAnimationDelay = 0.036;
}
#pragma mark end 初始化UI和数据

#pragma mark - start 手势触摸事件
// 背景图点击，退出菜单
- (void)bgImageDidClick
{
    if (_count > 0) {
        [self dismissSpringMenuWithAnimate:YES];
    }
}

// 菜单项点击事件
- (void)springMenuItemDidClick:(UITapGestureRecognizer *)tap
{
    XQSpringMenuItem *selectItem = (XQSpringMenuItem *)tap.view;
    
    for (XQSpringMenuItem *item in self.items) {
        
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue         = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue           = [NSNumber numberWithFloat:item == selectItem ? 1.5 : 0.8];
        scaleAnimation.duration          = 0.3;
        
        CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alphaAnimation .fromValue        = [NSNumber numberWithFloat:1.0];
        alphaAnimation .toValue          = [NSNumber numberWithFloat:0.0];
        alphaAnimation.duration          = 0.3;
        
        CAAnimationGroup *group          = [CAAnimationGroup animation];
        group.animations                 = @[scaleAnimation, alphaAnimation];
        group.duration                   = 0.3;
        group.delegate                   = self;
        
        if (item.tag == self.items.count - 1) {
            [group setValue:@"didClickMenuItem" forKey:@"id"];
            [group setValue:selectItem forKey:@"selectIndex"];
        }
        
        [item.layer addAnimation:group forKey:@"clickAnimation"];
        [item.layer setOpacity:0.0];
    }
}
#pragma mark end 手势触摸事件

#pragma mark - start 私有方法
- (void)openMenu
{
    if (_count > self.items.count - 1) {
        [self.timer invalidate];
        self.timer = nil;
        _count--;
        return;
    }
    
    XQSpringMenuItem *item        = [self.items objectAtIndex:_count++];
    NSMutableArray *animations    = [NSMutableArray array];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath      = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,    NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(thePath, NULL, item.farPoint.x,   item.farPoint.y);
    CGPathAddLineToPoint(thePath, NULL, item.nearPoint.x,  item.nearPoint.y);
    CGPathAddLineToPoint(thePath, NULL, item.endPoint.x,   item.endPoint.y);
    position.path           = thePath;
    position.duration       = self.animationTime;
    position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CGPathRelease(thePath);
    [animations addObject:position];
    
    if (self.isFadeAnimation) {
        CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alpha.duration      = self.animationTime / 3;
        alpha.fromValue     = [NSNumber numberWithFloat:0.0];
        alpha.toValue       = [NSNumber numberWithFloat:1.0];
        [animations addObject:alpha];
    }
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration          = self.animationTime;
    group.delegate          = self;
    group.animations        = animations;
    
    if (_count >= self.items.count - 1) {
        [group setValue:@"openFinish" forKey:@"id"];
    }
    [item.layer addAnimation:group forKey:@"openMenu"];
    [item.layer setPosition:item.endPoint];
}

- (void)closeMenu
{
    if (_count < 0) {
        [self.timer invalidate];
        self.timer = nil;
        _count++;
        return;
    }
    XQSpringMenuItem *item        = [self.items objectAtIndex:_count--];
    NSMutableArray *animations    = [NSMutableArray array];
    
    CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath      = CGPathCreateMutable();
    CGPathMoveToPoint(thePath,    NULL, item.endPoint.x,   item.endPoint.y);
    CGPathAddLineToPoint(thePath, NULL, item.farPoint.x,   item.farPoint.y);
    CGPathAddLineToPoint(thePath, NULL, item.startPoint.x, item.startPoint.y);
    position.path           = thePath;
    position.duration       = self.dismissAnimationTime;
    position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    CGPathRelease(thePath);
    [animations addObject:position];
    
    if (self.isFadeAnimation) {
        CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alpha.duration      = self.dismissAnimationTime;
        alpha.fromValue     = [NSNumber numberWithFloat:1.0];
        alpha.toValue       = [NSNumber numberWithFloat:0.0];
        [animations addObject:alpha];
    }
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration          = self.dismissAnimationTime;
    group.delegate          = self;
    group.animations        = animations;
    
    if (_count <= 0) {
        [group setValue:@"closeFinish" forKey:@"id"];
    }
    [item.layer addAnimation:group forKey:@"closeMenu"];
    [item.layer setPosition:item.startPoint];
    [item.layer setOpacity:0.0];
}
#pragma mark end 私有方法

#pragma mark - start 动画结束之后调用(NSObject协议)
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"id"] isEqual:@"closeFinish"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(springMenuDidClose:)]) {
            [self.delegate springMenuDidClose:self];
        }else if (self.didCloseBlock) {
            self.didCloseBlock(self);
        }
        [self removeFromSuperview];
    }else if ([[anim valueForKey:@"id"] isEqual:@"didClickMenuItem"]) {
        XQSpringMenuItem *item = [anim valueForKey:@"selectIndex"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(springMenu:didClickItemAtIdx:menuTitle:)]) {
            [self.delegate springMenu:self didClickItemAtIdx:item.tag menuTitle:item.menuTitle];
        }else if (self.selectBlock) {
            self.selectBlock(self, item.tag, item.menuTitle);
        }
        [self removeFromSuperview];
    }
}
#pragma mark end 动画结束之后调用(NSObject协议)

#pragma mark - start 对外提供的API接口
// 设置字体大小
- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    for (XQSpringMenuItem *item in self.items) {
        [item setFontSzie:fontSize];
    }
}

// 设置菜单项被点击时的block回调
- (void)setSpringMenuItemDidSelectBlock:(void (^)(XQSpringMenu *, NSInteger, NSString *))selectBlock
{
    self.selectBlock = selectBlock;
}

- (void)setSpringMenuDidCloseBlock:(void (^)(XQSpringMenu *))didCloseBlock
{
    self.didCloseBlock = didCloseBlock;
}

// 显示菜单
- (void)showWithAnimate:(BOOL)animate
{
    if (self.items && self.items.count > 0) {
        
        _row           = UNSIGNED_NUMBER(self.items.count) / self.column + 1;
        CGFloat spaceH = ITEM_SPACE_HORIZONTAL;
        CGFloat spaceV = HEIGHT(ITEM_SPACE_VERTICAL);
        CGFloat itemW  = self.menuItemSize.width;
        CGFloat itemH  = self.menuItemSize.height;
        
        for (int i = 0; i < self.items.count; i++) {
            
            XQSpringMenuItem *item = [self.items objectAtIndex:i];
            // 初始化item的位置
            item.tag        = i;
            CGFloat itemX   = spaceH + (itemW + spaceH) * (i % self.column) + itemW * 0.5;
            CGFloat itemY   = SCREEN_HEIGHT + itemH * 0.5;
            item.frame      = CGRectMake(itemX - itemW * 0.5, itemY - itemH * 0.5, itemW, itemH);
            
            item.startPoint = CGPointMake(itemX, itemY);
            NSInteger y     = self.row - (item.tag / self.column);
            itemY           = SCREEN_HEIGHT - self.bottomInsets - (itemH + spaceV) * y;
            item.endPoint   = CGPointMake(itemX, itemY);
            item.farPoint   = CGPointMake(itemX, itemY + HEIGHT(30));
            item.nearPoint  = CGPointMake(itemX, itemY - HEIGHT(10));
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(springMenuItemDidClick:)];
            [item addGestureRecognizer:tap];
            [self addSubview:item];
        }
        
        if (!animate) {
            for (int i = 0; i < self.items.count; i++) {
                XQSpringMenuItem *item = [self.items objectAtIndex:i];
                item.frame = CGRectMake(item.endPoint.x, item.endPoint.y, item.bounds.size.width, item.bounds.size.height);
            }
        }else {
            if (!self.timer) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDelay
                                                              target:self
                                                            selector:@selector(openMenu)
                                                            userInfo:nil
                                                             repeats:YES];
                [self.timer fire];
            }
        }
    }
}

// 退出菜单
- (void)dismissSpringMenuWithAnimate:(BOOL)animate
{
    if (!animate) {
        for (NSInteger i = self.items.count - 1; i >= 0; i--) {
            XQSpringMenuItem *item = [self.items objectAtIndex:i];
            item.frame = CGRectMake(item.startPoint.x, item.startPoint.y, item.bounds.size.width, item.bounds.size.height);
        }
    }else {
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:self.dismissAnimationDelay
                                                          target:self
                                                        selector:@selector(closeMenu)
                                                        userInfo:nil
                                                         repeats:YES];
            [self.timer fire];
        }
    }
}
#pragma mark end 对外提供的API接口

@end
