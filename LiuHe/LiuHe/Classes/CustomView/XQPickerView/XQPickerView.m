//
//  XQPickerView.m
//  LiuHe
//
//  Created by huxingqin on 2017/1/4.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import "XQPickerView.h"

@interface XQPickerView ()

@property (weak, nonatomic) UIView *backgroundView;

@property (weak, nonatomic) UIView *contentView;

@end

@implementation XQPickerView

+ (instancetype)pickerView
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    self.backgroundView    = backgroundView;
    [backgroundView setBackgroundColor:RGBCOLOR(0, 0, 0)];
    [backgroundView setAlpha:0];
    [backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)]];
    [self addSubview:backgroundView];
    
    CGFloat viewY = self.bounds.size.height;
    CGFloat viewH = 256;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, SCREEN_WIDTH, viewH)];
    self.contentView = view;
    [self addSubview:view];
    
    CGFloat viewh = 40;
    view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, viewh)];
    [view setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.contentView addSubview:view];
    
    CGFloat btnW     = 60;
    UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, viewh)];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [cancel.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancel addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
    
    CGFloat btnX     = SCREEN_WIDTH - btnW;
    UIButton *sure   = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnW, viewh)];
    [sure setTitle:@"确定" forState:UIControlStateNormal];
    [sure setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    [sure setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [sure.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [sure addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sure];
    
    CGFloat pickerW      = SCREEN_WIDTH;
    CGFloat pickerH      = viewH - viewh;
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, viewh, pickerW, pickerH)];
    _picker              = picker;
    [picker setBackgroundColor:RGBCOLOR(235, 235, 235)];
    [self.contentView addSubview:picker];
}

#pragma mark - start 按钮点击事件
/** 确定 */
- (void)sureEvent
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureButtonDidClickWithPicker:)]) {
        [self.delegate sureButtonDidClickWithPicker:self.picker];
    }
    [self removeSelf];
}

/** 移除PickerView */
- (void)removeSelf
{
    CGRect frame   = self.contentView.frame;
    frame.origin.y = self.bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha = 0;
        self.contentView.frame    = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark end 按钮点击事件

#pragma mark - start 重写setter
- (void)setDataSource:(id<XQPickerViewDataSource>)dataSource
{
    _dataSource = dataSource;
    self.picker.dataSource = dataSource;
}

- (void)setDelegate:(id<XQPickerViewDelegate>)delegate
{
    _delegate = delegate;
    self.picker.delegate = delegate;
}
#pragma mark end 重写setter

#pragma mark - start 对外方法
- (void)showWithAnimated:(BOOL)animated
{
    [KeyWindow addSubview:self];
    
    CGRect frame   = self.contentView.frame;
    frame.origin.y = self.bounds.size.height - frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0.4;
            self.contentView.frame    = frame;
        }];
    }else {
        self.backgroundView.alpha = 0.4;
        self.contentView.frame    = frame;
    }
}

- (void)dismissWithAnimated:(BOOL)animated
{
    if (animated) {
        [self removeSelf];
    }else {
        self.backgroundView.alpha = 0;
        CGRect frame   = self.contentView.frame;
        frame.origin.y = self.bounds.size.height;
        self.contentView.frame = frame;
    }
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.picker selectRow:row inComponent:component animated:animated];
}
#pragma mark end 对外方法
@end
