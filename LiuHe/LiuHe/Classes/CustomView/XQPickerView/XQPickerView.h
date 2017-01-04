//
//  XQPickerView.h
//  LiuHe
//
//  Created by huxingqin on 2017/1/4.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XQPickerViewDelegate <UIPickerViewDelegate>

@optional
- (void)sureButtonDidClickWithPicker:(UIPickerView *)picker;

@end

@protocol XQPickerViewDataSource <UIPickerViewDataSource>

@end

@interface XQPickerView : UIView


@property (weak, nonatomic, readonly) UIPickerView *picker;
/** 代理 */
@property (weak, nonatomic) id <XQPickerViewDelegate>delegate;
/** 数据源 */
@property (weak, nonatomic) id <XQPickerViewDataSource>dataSource;
/**
 *  创建一个XQPickerView对象
 */
+ (instancetype)pickerView;
/**
 *  显示PickerView
 *  @parameter : animated  是否动画
 */
- (void)showWithAnimated:(BOOL)animated;
/**
 *  移除PickerView
 *  @parameter : animated  是否动画
 */
- (void)dismissWithAnimated:(BOOL)animated;
/**
 *  选中指定的目标
 *  @parameter : row        行号
 *  @parameter : component  列号
 *  @parameter : animated   是否动画
 */
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end
