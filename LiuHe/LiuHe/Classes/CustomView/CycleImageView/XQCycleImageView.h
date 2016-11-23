//
//  XQCycleImageView.h
//  Example
//
//  Created by 胡兴钦 on 16/5/14.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XQCycleImageView;

@protocol XQCycleImageViewDelegate <NSObject>
/**
 *  circleView当前的内容被响应
 *  @parameter : circleImageView  轮播视图
 *  @parameter : index            被点击图片的下标
 */
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index;

@optional
- (void)cycleImageViewDidScrollingAnimation:(XQCycleImageView *)cycleImageView atIndex:(int)index;

@end

@interface XQCycleImageView : UIView <UIScrollViewDelegate>
/**
 *  是否自动轮播
 */
@property (nonatomic, assign) BOOL autoDragging;
/**
 *  播放的秒数，当且仅当自动轮播时有意义
 */
@property (nonatomic, assign) int repeatSecond;
/**
 *  代理，处理circleView内容点击事件
 */
@property (nonatomic, weak) id<XQCycleImageViewDelegate> delegate;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSArray *images;

@property (nonatomic) UIViewContentMode contentMode;

/**
 *  创建一个实例
 */
+ (instancetype)cycleImageView;

/**
 *  创建一个实例
 *  @parameter : images    图片数组
 *  @parameter : delegate  代理
 */
+ (instancetype)cycleImageViewWithImages:(NSArray<UIImage *> *)images
                                delegate:(id<XQCycleImageViewDelegate>)delegate;

/**
 *  创建一个实例
 *  @parameter : images    图片数组
 *  @parameter : delegate  代理
 */
- (instancetype)initWithImages:(NSArray<UIImage *> *)images
                      delegate:(id<XQCycleImageViewDelegate>)delegate;

/**
 *  开始播放ImageView
 */
- (void)startPlayImageView;

/**
 *  停止播放ImageView
 */
- (void)stopPlayImageView;
@end
