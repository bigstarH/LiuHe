//
//  CountDowner.m
//  hzy
//
//  Created by NB-022 on 16/7/26.
//  Copyright © 2016年 imixun. All rights reserved.
//

#import "CountDowner.h"

@interface CountDowner ()

@property (nonatomic, weak) UILabel *dayLab;

@property (nonatomic, weak) UILabel *hourLab;

@property (nonatomic, weak) UILabel *miniteLab;

@property (nonatomic, weak) UILabel *secondLab;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic) int second;

@property (nonatomic) int minite;

@property (nonatomic) int hour;

@property (nonatomic) int day;

@end

@implementation CountDowner
{
    NSTimeInterval total;
    BOOL setLayout;
}

+ (instancetype)countDownerWithTime:(NSTimeInterval)time
{
    return [[self alloc] initWithTime:time];
}

- (instancetype)initWithTime:(NSTimeInterval)time
{
    if (self  = [super init]) {
        total = time;
        [self setDefaultValue];
        [self initTime];
        [self createView];
    }
    return self;
}

- (void)setDefaultValue
{
    setLayout  = YES;
    _fontSize  = fontSize(15);
    
    _timeColor      = MAIN_COLOR;
    _textColor      = [UIColor whiteColor];
    _timeLabBgColor = [UIColor whiteColor];
}

- (void)initTime
{
    _day       = total / (3600 * 24);
    int rest   = total - (3600 * 24) * _day;
    _hour      = rest / 3600;
    rest       = rest - _hour * 3600;
    _minite    = rest / 60;
    _second    = rest - 60 * _minite;
}

- (void)createView
{
    UIFont *font   = [UIFont boldSystemFontOfSize:_fontSize + 1];
    UILabel *label = [[UILabel alloc] init];
    label.font     = font;
    self.dayLab    = label;
    label.text     = @"00";
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:WIDTH(3)];
    [self addSubview:label];
    
    label          = [[UILabel alloc] init];
    label.font     = font;
    label.text     = @"00";
    self.hourLab   = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:WIDTH(3)];
    [self addSubview:label];
    
    label          = [[UILabel alloc] init];
    label.font     = font;
    label.text     = @"00";
    self.miniteLab = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:WIDTH(3)];
    [self addSubview:label];
    
    label          = [[UILabel alloc] init];
    label.font     = font;
    label.text     = @"00";
    self.secondLab = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label.layer setMasksToBounds:YES];
    [label.layer setCornerRadius:WIDTH(3)];
    [self addSubview:label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!setLayout) return;
    
    CGFloat width   = self.bounds.size.width;
    CGFloat height  = self.bounds.size.height;
    
    CGFloat originX = WIDTH(4);
    CGFloat labelW  = WIDTH(20);
    CGFloat timeW   = (width - originX * 2 - labelW * 4) * 0.25;
    CGFloat timeY   = (height - timeW) * 0.5;
    _dayLab.frame   = CGRectMake(originX, timeY, timeW, timeW);
    [_dayLab setTextColor:_timeColor];
    [_dayLab setBackgroundColor:_timeLabBgColor];
    
    originX = originX + timeW;
    [self addLabelWithFrame:CGRectMake(originX, 0, labelW, height) text:@"天"];
    
    originX = originX + labelW;
    _hourLab.frame  = CGRectMake(originX, timeY, timeW, timeW);
    [_hourLab setTextColor:_timeColor];
    [_hourLab setBackgroundColor:_timeLabBgColor];
    
    originX = originX + timeW;
    [self addLabelWithFrame:CGRectMake(originX, 0, labelW, height) text:@"时"];
    
    originX = originX + labelW;
    _miniteLab.frame = CGRectMake(originX, timeY, timeW, timeW);
    [_miniteLab setTextColor:_timeColor];
    [_miniteLab setBackgroundColor:_timeLabBgColor];
    
    originX = originX + timeW;
    [self addLabelWithFrame:CGRectMake(originX, 0, labelW, height) text:@"分"];
    
    originX = originX + labelW;
    _secondLab.frame = CGRectMake(originX, timeY, timeW, timeW);
    [_secondLab setTextColor:_timeColor];
    [_secondLab setBackgroundColor:_timeLabBgColor];
    
    originX = originX + timeW;
    [self addLabelWithFrame:CGRectMake(originX, 0, labelW, height) text:@"秒"];
    
    setLayout = NO;
}

- (void)addLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label  = [[UILabel alloc] initWithFrame:frame];
    label.font      = [UIFont systemFontOfSize:_fontSize];;
    label.text      = text;
    label.textColor = _textColor;
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}

- (void)startCountDown
{
    [self.timer fire];
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)countDown
{
    self.second--;
    if (self.second < 0) {
        if (self.minite <= 0) {
            if (self.hour <= 0) {
                if (self.day <= 0) {
                    self.day    = 0;
                    self.hour   = 0;
                    self.minite = 0;
                    self.second = 0;
                    [self stopCountDown];
                }else {
                    self.hour   = 23;
                    self.minite = 59;
                    self.second = 59;
                    self.day--;
                }
            }else {
                self.minite = 59;
                self.second = 59;
                self.hour--;
            }
        }else {
            self.second = 59;
            self.minite--;
        }
    }
    self.dayLab.text    = [NSString stringWithFormat:@"%02d", self.day];
    self.hourLab.text   = [NSString stringWithFormat:@"%02d", self.hour];
    self.miniteLab.text = [NSString stringWithFormat:@"%02d", self.minite];
    self.secondLab.text = [NSString stringWithFormat:@"%02d", self.second];
}

- (void)stopCountDown
{
    [self.timer invalidate];
    self.timer = nil;
}

- (int)getCountDown
{
    return self.day * 24 * 3600 + self.hour * 3600 + self.minite * 60 + self.second;
}

- (void)setCountDownTime:(NSTimeInterval)time
{
    total = time;
    [self initTime];
}

@end
