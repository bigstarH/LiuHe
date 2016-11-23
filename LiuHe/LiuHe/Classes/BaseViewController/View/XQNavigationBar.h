//
//  XQNavigationBar.h
//
//  Created by 胡兴钦 on 16/2/17.
//  Copyright © 2016年 ufuns. All rights reserved.
//
//  自定义导航栏

#define barButtonItemsDistance 8

#import <UIKit/UIKit.h>
#import "XQBarButtonItem.h"

@class XQNavigationBar;

@protocol XQNavigationBarDelegate <NSObject>
@optional
/**
 *  返回按钮点击事件
 */
- (void)goBackWithNavigationBar:(XQNavigationBar *)navigationBar;
@end

@interface XQNavigationBar : UIView
/**
 *  代理
 */
@property (nonatomic, assign) id<XQNavigationBarDelegate> delegate;
/**
 *  背景图片ImageView
 */
@property (nonatomic, weak, readonly) UIImageView *imageView;
/**
 *  标题View
 */
@property (nonatomic, weak) UIView *titleView;
/**
 *  1像素的阴影
 */
@property (nonatomic, weak, readonly) UIView *shadowView;
/**
 *  返回按钮
 */
@property (nonatomic, weak) XQBarButtonItem *backBarButtonItem;
/**
 *  左边按钮
 */
@property (nonatomic, weak) XQBarButtonItem *leftBarButtonItem;
/**
 *  左边按钮数组
 */
@property (nonatomic, strong) NSArray<XQBarButtonItem *> *leftBarButtonItems;
/**
 *  右边按钮
 */
@property (nonatomic, weak) XQBarButtonItem *rightBarButtonItem;
/**
 *  右边按钮数组
 */
@property (nonatomic, strong) NSArray<XQBarButtonItem *> *rightBarButtonItems;
/**
 *  是否隐藏返回按钮
 */
@property (nonatomic, assign, getter=isBackButtonHidden) BOOL backButtonHidden;
/**
 *  是否隐藏1像素阴影
 */
@property (nonatomic, assign, getter=isShadowHidden) BOOL shadowHidden;
/**
 *  导航栏背景不透明时的距离大小(根据scrollView滑动的距离来设置导航栏背景透明度)
 */
@property (nonatomic, assign) CGFloat mOpaque;
/**
 *  状态栏颜色改变的距离值
 */
@property (nonatomic, assign) CGFloat statuBarColorChangedValue;
/**
 *  设置背景图片
 */
- (void)setBackgroundImage:(UIImage *)image;
/**
 *  设置导航栏背景颜色
 */
- (void)setBarTintColor:(UIColor *)color;
/**
 *  设置"返回按钮"字体颜色
 */
- (void)setBackButtonTitleColor:(UIColor *)color;
@end
