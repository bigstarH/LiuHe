//
//  BaseViewController.h
//  Text
//
//  Created by huxingqin on 2016/11/21.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQNavigationBar.h"

@interface BaseViewController : UIViewController
/** 自定义navigationBar */
@property (nonatomic, weak, readonly) XQNavigationBar *navigationBar;
/** 是否需要自定义navigationBar */
@property (nonatomic) BOOL needsCustomNavigationBar;

/**
 *  设置导航栏
 */
- (void)setNavigationBarStyle;
/**
 *  设置状态栏样式
 */
- (UIBarStyle)setStatuBar;
/**
 *  设置导航栏颜色
 */
- (UIColor *)setBarTintColor;
/**
 *  导航栏标题颜色和按钮颜色
 */
- (UIColor *)setTintColor;

- (UILabel *)setTitleView;
/**
 *  自定义navigationBar返回事件
 */
- (void)goBackWithNavigationBar:(XQNavigationBar *)navigationBar;

@end
