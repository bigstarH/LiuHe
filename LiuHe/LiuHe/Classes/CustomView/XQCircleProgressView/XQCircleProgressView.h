//
//  XQCircleProgressView.h
//  Example
//
//  Created by NB-022 on 16/5/13.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, XQProgressViewStyle) {
    XQProgressViewStyleDefault         = 0,  /**< 默认样式(圆形空心) */
    XQProgressViewStyleBackgroudCircle = 1,  /**< 和默认相比，多了进度条背景圆(圆形空心) */
    XQProgressViewStyleSolid           = 2,  /**< 圆形实心样式 */
    XQProgressViewStyleMix             = 3,  /**< 圆环样式(内圆实心)*/
};

@interface XQCircleProgressView : UIView

/** 当前进度 */
@property (nonatomic, assign) float progress;

/** 进度条样式，默认为：XQProgressViewStyleDefault */
@property (nonatomic, assign) XQProgressViewStyle progressStyle;

/** 宽度(当为样式为实心时，可无视) */
@property (nonatomic, assign) float circleWidth;

/** 当前进度的颜色 */
@property (nonatomic, strong) UIColor *progressTintColor;

/** 进度条背景颜色 */
@property (nonatomic, strong) UIColor *trackTintColor;

@property (nonatomic, weak, readonly) CAShapeLayer *shapeLayer;

+ (instancetype)progressView;

+ (instancetype)progressViewWithStyle:(XQProgressViewStyle)style;

- (instancetype)initWithSyle:(XQProgressViewStyle)style;

@end
