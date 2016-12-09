//
//  CountDowner.h
//  hzy
//
//  Created by NB-022 on 16/7/26.
//  Copyright © 2016年 imixun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDowner : UIView

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, strong) UIColor *timeColor;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *timeLabBgColor;

+ (instancetype)countDownerWithTime:(NSTimeInterval)time;

- (void)setCountDownTime:(NSTimeInterval)time;

- (void)startCountDown;

- (void)stopCountDown;

- (int)getCountDown;
@end
