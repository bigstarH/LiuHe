//
//  ShareMenu.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/6.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ShareMenu.h"

@interface SMenuItem : UIView

@property (nonatomic, weak) UIImageView *menuImage;

@property (nonatomic, weak) UILabel *menuLab;

- (void)setImage:(UIImage *)image title:(NSString *)title;

@end

@interface ShareMenu ()

@property (nonatomic, weak) UIView *menu;

@end

@implementation ShareMenu

+ (instancetype)shareMenu
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);
    
    CGFloat menuW = self.bounds.size.width;
    CGFloat menuH = HEIGHT(80);
    CGFloat menuY = self.bounds.size.height;
    UIView *menu  = [[UIView alloc] initWithFrame:CGRectMake(0, menuY, menuW, menuH)];
    self.menu     = menu;
    [menu setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:menu];
 
    NSArray *images = @[@"btn_wechat", @"btn_wctimeLine", @"btn_qq", @"btn_qqzone"];
    NSArray *titles = @[@"微信", @"朋友圈", @"QQ", @"QQ空间"];
    
    CGFloat itemW = WIDTH(50);
    CGFloat space = (menuW - itemW * 4) * 0.2;
    CGFloat itemX = space;
    CGFloat itemH = HEIGHT(58);
    CGFloat itemY = (menuH - itemH) * 0.5;
    for (int i = 0; i < 4; i++) {
        SMenuItem *item = [[SMenuItem alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        item.tag        = i;
        [item setImage:[UIImage imageNamed:images[i]] title:titles[i]];
        itemX = itemX + itemW + space;
        [menu addSubview:item];
        
        [item addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidClick:)]];
    }
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)]];
}

- (void)show
{
    [KeyWindow addSubview:self];
    CGFloat height = CGRectGetHeight(self.menu.frame);
    [UIView animateWithDuration:0.2 animations:^{
        self.menu.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
}

- (void)itemDidClick:(UITapGestureRecognizer *)tap
{
    SMenuItem *item = (SMenuItem *)tap.view;
    if (self.delegate) {
        [self.delegate shareMenu:self didSelectMenuItemWithType:item.tag];
    }
    [self removeSelf];
}

- (void)removeSelf
{
    [UIView animateWithDuration:0.2 animations:^{
        self.menu.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.menu removeFromSuperview];
        [self removeFromSuperview];
    }];
}

@end

@implementation SMenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    CGFloat imageW = WIDTH(30);
    CGFloat imageX = (self.bounds.size.width - imageW) * 0.5;
    CGFloat imageY = HEIGHT(5);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageW)];
    self.menuImage         = imageView;
    [self addSubview:imageView];
    
    CGFloat labelW = self.bounds.size.width;
    CGFloat labelH = HEIGHT(18);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT(40), labelW, labelH)];
    label.font     = [UIFont systemFontOfSize:fontSize(13)];
    self.menuLab   = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}

- (void)setImage:(UIImage *)image title:(NSString *)title
{
    self.menuImage.image = image;
    self.menuLab.text    = title;
}

@end
