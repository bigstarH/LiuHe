//
//  XQSegmentedControl.h
//  Example
//
//  Created by NB-022 on 16/5/19.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQSegmentedControl : UIControl

/** 拖动，慢速移动手势是否有效 */
@property (nonatomic) BOOL panEnabled;

/** 字体 */
@property (nonatomic, strong) UIFont *font;

/** Segment的个数 */
@property (nonatomic, readonly) NSInteger numberOfSegments;

/** 当前选中的下标 */
@property (nonatomic, readonly) NSInteger selectedSegmentIndex;

/** 主题颜色 */
@property (nonatomic, strong) IBInspectable UIColor *tintColor;

/** 选中时的字体颜色 */
@property (nonatomic, strong) IBInspectable UIColor *selectedTextColor;

/** 未选中时的字体颜色 */
@property (nonatomic, strong) IBInspectable UIColor *textColor;

/** 选中时的背景颜色 */
@property (nonatomic, strong) IBInspectable UIColor *selectedBackgroundColor;

/** 圆角 */
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

+ (instancetype)segmentedControlWithItems:(NSArray *)items;

- (instancetype)initWithItems:(NSArray *)items;

- (void)setItems:(NSArray *)items;
@end
