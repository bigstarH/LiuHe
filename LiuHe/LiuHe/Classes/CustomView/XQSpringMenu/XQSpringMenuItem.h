//
//  XQSpringMenuItme.h
//  胡兴钦
//
//  Created by NB-022 on 16/4/29.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQSpringMenuItem : UIView

/** 菜单图片 */
@property (nonatomic, strong, readonly) UIImage *menuImage;
/** 菜单标题 */
@property (nonatomic, copy, readonly) NSString *menuTitle;
/** 开始的坐标 */
@property (nonatomic, assign) CGPoint startPoint;
/** 动画结束时，最终的坐标 */
@property (nonatomic, assign) CGPoint endPoint;
/** 动画浮动的坐标 */
@property (nonatomic, assign) CGPoint nearPoint;
/** 动画最远的坐标 */
@property (nonatomic, assign) CGPoint farPoint;

- (void)addConstraints;

/**
 *  创建一个MenuItem
 *  @parameter : menuImage   菜单图片
 *  @parameter : menuTitle   菜单标题
 */
- (instancetype)initWithImage:(UIImage *)menuImage
                        title:(NSString *)menuTitle;

/** 
 *  设置字体大小
 *  @parameter : fontSize  字体大小
 */
- (void)setFontSzie:(CGFloat)fontSize;
@end
