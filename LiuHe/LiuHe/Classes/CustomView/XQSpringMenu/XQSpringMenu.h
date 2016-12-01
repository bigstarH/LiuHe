//
//  XQSpringMenu.h
//  Example
//
//  Created by NB-022 on 16/4/29.
//  Copyright © 2016年 ufuns. All rights reserved.
//  仿新浪微博底部按钮菜单

#import <UIKit/UIKit.h>
#import "XQSpringMenuItem.h"

@class XQSpringMenu;

@protocol XQSpringMenuDelegate <NSObject>
/**
 *  菜单点击事件
 *  @parameter : menu       菜单
 *  @parameter : index      菜单标记
 *  @parameter : menuTitle  菜单标题
 **/
- (void)springMenu:(XQSpringMenu *)menu didClickItemAtIdx:(NSInteger)index menuTitle:(NSString *)menuTitle;

@optional
/**
 *  菜单已经关闭
 *  @parameter : menu  菜单
 **/
- (void)springMenuDidClose:(XQSpringMenu *)menu;

@end

@interface XQSpringMenu : UIView

/** 菜单按钮的尺寸, 默认为(宽：71，高：100) */
@property (nonatomic, assign) CGSize menuItemSize;

/** 代理 */
@property (nonatomic, weak) id<XQSpringMenuDelegate>delegate;

/** 菜单数组 */
@property (nonatomic, strong) NSArray<XQSpringMenuItem *>*items;

/** 最后一行按钮与底部的距离, 默认为50 */
@property (nonatomic, assign) CGFloat bottomInsets;

/** 每个菜单动画的间隔, 默认为0.036s */
@property (nonatomic, assign) NSTimeInterval animationDelay;

/** 每个菜单项的动画时间, 默认为0.2s */
@property (nonatomic, assign) NSTimeInterval animationTime;

/** 每个菜单项的消失动画时间, 默认为0.2s */
@property (nonatomic, assign) NSTimeInterval dismissAnimationTime;

/** 每个菜单项的消失动画间隔, 默认为0.2s */
@property (nonatomic, assign) NSTimeInterval dismissAnimationDelay;

/** 是否要淡入淡出动画 */
@property (nonatomic, assign, getter=isFadeAnimation) BOOL fadeAnimation;

/** 行数 */
@property (nonatomic, assign, readonly) NSInteger row;

/** 列数 */
@property (nonatomic, assign) NSInteger column;

/** 标题的字体大小 */
@property (nonatomic, assign) CGFloat fontSize;

/**
 *  创建一个StringMenu实例 
 */
+ (instancetype)springMenu;

/**
 *  创建一个StringMenu实例
 *  @parameter : items 菜单数组
 */
+ (instancetype)springMenuWithItems:(NSArray *)items;

/**
 *  创建一个StringMenu实例
 *  @parameter : items 菜单数组
 */
- (instancetype)initWithItems:(NSArray *)items;

/**
 *  菜单点击回调block
 *  @parameter : block  用于回调的block
 */
- (void)setSpringMenuItemDidSelectBlock:(void (^)(XQSpringMenu *menu, NSInteger index, NSString *menuTitle))selectBlock;

/**
 *  菜单已经关闭
 *  @parameter : block  用于回调的block
 */
- (void)setSpringMenuDidCloseBlock:(void (^)(XQSpringMenu *menu))didCloseBlock;

/**
 *  显示菜单
 *  @parameter : animate 是否动画显示
 */
- (void)showWithAnimate:(BOOL)animate;

/**
 *  退出菜单
 *  @parameter : animate 是否动画显示
 */
- (void)dismissSpringMenuWithAnimate:(BOOL)animate;

@end
