//
//  XQCircleProgressView.m
//  Example
//
//  Created by NB-022 on 16/5/13.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#define ANGLE_TO_RADIAN(angle)         (angle) * M_PI / 180
#define PROGRESS_TO_RADIAN(progress)   (progress) * 2 * M_PI

#define centerX   self.bounds.size.width * 0.5
#define centerY   self.bounds.size.height * 0.5

#import "XQCircleProgressView.h"

@interface XQCircleProgressView ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, weak) CAShapeLayer *bgLayer;

@end

@implementation XQCircleProgressView

+ (instancetype)progressView
{
    return [[self alloc] initWithSyle:XQProgressViewStyleDefault];
}

+ (instancetype)progressViewWithStyle:(XQProgressViewStyle)style
{
    return [[self alloc] initWithSyle:style];
}

- (instancetype)initWithSyle:(XQProgressViewStyle)style
{
    if (self = [super init]) {
        self.progressStyle = style;
        [self initDefaultValue];
        [self createLayer];
    }
    return self;
}

- (void)dealloc
{
    self.path              = nil;
    self.trackTintColor    = nil;
    self.progressTintColor = nil;
}

- (void)layoutSubviews
{
    [_shapeLayer setFrame:self.bounds];
    if (self.progressStyle == XQProgressViewStyleDefault) [self setUpDefaultStyle];
    if (self.progressStyle == XQProgressViewStyleBackgroudCircle) [self setUpBackgroundStyle];
    if (self.progressStyle == XQProgressViewStyleSolid) [self setUpSolidStyle];
    if (self.progressStyle == XQProgressViewStyleMix) [self setUpMixStyle];
}

- (void)initDefaultValue
{
    self.circleWidth       = 3.0;
    self.progressTintColor = [UIColor blueColor];
    self.trackTintColor    = [UIColor lightGrayColor];
    self.progress          = 0.0f;
    self.backgroundColor   = [UIColor clearColor];
}

- (void)createLayer
{
    CAShapeLayer *shape    = [CAShapeLayer layer];
    shape.affineTransform  = CGAffineTransformMakeRotation(- M_PI * 0.5);
    [self.layer addSublayer:shape];
    _shapeLayer            = shape;
}

- (UIBezierPath *)path
{
    if (!_path) {
        if (_progressStyle == XQProgressViewStyleDefault || _progressStyle == XQProgressViewStyleBackgroudCircle) {
            _path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, self.circleWidth, self.circleWidth)];
        }else {
            _path = [UIBezierPath bezierPath];
        }
    }
    return _path;
}

- (void)setUpDefaultStyle
{
    self.shapeLayer.fillColor   = [UIColor clearColor].CGColor;
    self.shapeLayer.lineWidth   = self.circleWidth;
    self.shapeLayer.strokeColor = self.progressTintColor.CGColor;
    self.shapeLayer.path        = self.path.CGPath;
    self.shapeLayer.strokeStart = 0;
    self.shapeLayer.strokeEnd   = 0;
}

- (void)setUpBackgroundStyle
{
    [self setBgLayerWithStrokeColor:self.trackTintColor];
    [self setUpDefaultStyle];
}

- (void)setUpSolidStyle
{
    self.shapeLayer.fillColor   = self.progressTintColor.CGColor;
}

- (void)setUpMixStyle
{
    self.shapeLayer.fillColor   = self.progressTintColor.CGColor;
    [self setBgLayerWithStrokeColor:self.progressTintColor];
}

- (void)setBgLayerWithStrokeColor:(UIColor *)strokeColor
{
    if (!self.bgLayer) {
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, _circleWidth, _circleWidth)];
        CAShapeLayer *bgLayer   = [CAShapeLayer layer];
        bgLayer.fillColor       = [UIColor clearColor].CGColor;
        bgLayer.lineWidth       = self.circleWidth;
        bgLayer.strokeColor     = strokeColor.CGColor;
        bgLayer.strokeStart     = 0;
        bgLayer.strokeEnd       = 1;
        bgLayer.path            = path.CGPath;
        self.bgLayer            = bgLayer;
        [self.layer insertSublayer:bgLayer below:self.shapeLayer];
    }
}

- (UIBezierPath *)drawSolidStyle
{
    [self.path removeAllPoints];
    [self.path moveToPoint:CGPointMake(centerX, centerY)];
    [self.path addLineToPoint:CGPointMake(centerX * 2, centerY)];
    [self.path addArcWithCenter:CGPointMake(centerX, centerY)
                         radius:self.bounds.size.width * 0.5
                     startAngle:ANGLE_TO_RADIAN(0)
                       endAngle:PROGRESS_TO_RADIAN(self.progress)
                      clockwise:YES];
    return self.path;
}

- (UIBezierPath *)drawMixStyle
{
    CGFloat radius = centerX - self.circleWidth * 2;
    [self.path removeAllPoints];
    [self.path moveToPoint:CGPointMake(centerX, centerY)];
    [self.path addLineToPoint:CGPointMake(centerX + radius, centerY)];
    [self.path addArcWithCenter:CGPointMake(centerX, centerY)
                         radius:radius - self.circleWidth * 0.2
                     startAngle:ANGLE_TO_RADIAN(0)
                       endAngle:PROGRESS_TO_RADIAN(self.progress)
                      clockwise:YES];
    return self.path;
}

- (void)setProgress:(float)progress
{
    _progress = progress;
    switch (self.progressStyle) {
        case XQProgressViewStyleDefault:
            self.shapeLayer.strokeEnd = progress;
            break;
        case XQProgressViewStyleBackgroudCircle:
            self.shapeLayer.strokeEnd = progress;
            break;
        case XQProgressViewStyleSolid:
            self.shapeLayer.path = [self drawSolidStyle].CGPath;
            break;
        case XQProgressViewStyleMix:
            self.shapeLayer.path = [self drawMixStyle].CGPath;
            break;
        default:
            break;
    }
}

@end
