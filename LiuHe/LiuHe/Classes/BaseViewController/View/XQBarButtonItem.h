//
//  XQBarButtonItem.h
//
//  Created 胡兴钦 on 16/2/18.
//  Copyright © 2016年 ufuns. All rights reserved.
//
//  仿导航栏上的UIBarButtonItem

#define XQScreenWidth [UIScreen mainScreen].bounds.size.width
#define XQEdgeInsertW 3.0

#import <UIKit/UIKit.h>

@interface XQBarButtonItem : UIButton

/**
 *  创建普通带文字的BarButtonItem
 *  @parameter :  title  文字
 */
- (instancetype)initWithTitle:(NSString *)title;

/**
 *  创建普通带图片的BarButtonItem
 *  @parameter : image 普通状态下的图片
 */
- (instancetype)initWithImage:(UIImage *)image;

/**
 *  创建普通带图片的BarButtonItem
 *  @parameter : image 普通状态下的图片
 *  @parameter : highlightedImage 高亮状态下的图片
 */
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage;

/**
 *  创建普通带文字和图片的BarButtonItem
 *  @parameter : image 普通状态下的图片
 *  @parameter : title 文字
 */
- (instancetype)initWithImage:(UIImage *)image
                        title:(NSString *)title;

/**
 *  创建普通带文字和图片的BarButtonItem
 *  @parameter : image            普通状态下的图片
 *  @parameter : highlightedImage 高亮状态下的图片
 *  @parameter : title            文字
 */
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                        title:(NSString *)title;

/**
 *  创建普通带文字和图片的BarButtonItem
 *  @parameter : image            普通状态下的图片
 *  @parameter : highlightedImage 高亮状态下的图片
 *  @parameter : title            文字
 *  @parameter : titleNormalColor 文字普通状态下的颜色
 */
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                        title:(NSString *)title
             titleNormalColor:(UIColor *)titleNormalColor;

/**
 *  创建普通带文字和图片的BarButtonItem
 *  @parameter : image                 普通状态下的图片
 *  @parameter : highlightedImage      高亮状态下的图片
 *  @parameter : title                 文字
 *  @parameter : titleNormalColor      文字普通状态下的颜色
 *  @parameter : titleHighlightedColor 高亮状态下文字的颜色
 */
- (instancetype)initWithImage:(UIImage *)image
             highlightedImage:(UIImage *)highlightedImage
                        title:(NSString *)title
             titleNormalColor:(UIColor *)titleNormalColor
        titleHighlightedColor:(UIColor *)titleHighlightedColor;

/**
 *  BarButtonItem的尺寸
 */
- (CGSize)barButtonItemSize;
/**
 *  文字的宽度
 */
- (CGFloat)titleLabelWidth;
/**
 *  UIImageView的宽度
 */
- (CGFloat)ImageViewWidth;
@end
