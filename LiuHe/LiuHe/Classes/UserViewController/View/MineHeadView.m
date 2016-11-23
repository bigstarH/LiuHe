//
//  MineHeadView.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MineHeadView.h"

@interface MineHeadView ()

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UILabel *totalLab;

@property (nonatomic, weak) UILabel *rankLab;

@property (nonatomic, weak) UIButton *modifyBtn;

@end

@implementation MineHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = MAIN_COLORL;
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headView         = headView;
    headView.backgroundColor = [UIColor whiteColor];
    [headView.layer setMasksToBounds:YES];
    [headView setUserInteractionEnabled:YES];
    [headView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerDidClick:)]];
    [self addSubview:headView];
    
    UILabel *label = [[UILabel alloc] init];
    self.userLab   = label;
    label.text     = @"用户名";
    label.font     = [UIFont systemFontOfSize:fontSize(16)];
    [label setTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView    = bottomView;
    [bottomView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.3)];
    [self addSubview:bottomView];
    
    label         = [[UILabel alloc] init];
    label.text    = @"積分";
    label.font    = [UIFont systemFontOfSize:fontSize(13)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    self.totalLab = label;
    [bottomView addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.text    = @"0";
    label.font    = [UIFont systemFontOfSize:fontSize(13)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    self.integralLab = label;
    [bottomView addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.text    = @"等級";
    label.font    = [UIFont systemFontOfSize:fontSize(13)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    self.rankLab  = label;
    [bottomView addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.text    = @"0";
    label.font    = [UIFont systemFontOfSize:fontSize(13)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    self.gradeLab = label;
    [bottomView addSubview:label];
    
    UIButton *btn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.modifyBtn = btn;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(modifyUserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

- (void)layoutSubviews
{
    if (!CGRectEqualToRect(self.headView.frame, CGRectZero)) return;
    
    CGFloat width   = self.bounds.size.width;
    CGFloat height  = self.bounds.size.height;
    
    CGFloat headerW = WIDTH(60);
    CGFloat headerY = 64 + HEIGHT(10);
    CGFloat headerX = (width - headerW) * 0.5;
    self.headView.frame = CGRectMake(headerX, headerY, headerW, headerW);
    [self.headView.layer setCornerRadius:headerW * 0.5];
    
    CGFloat labelH  = HEIGHT(30);
    CGFloat labelY  = CGRectGetMaxY(self.headView.frame) + HEIGHT(5);
    self.userLab.frame = CGRectMake(0, labelY, width, labelH);
    
    CGFloat btnH    = WIDTH(25);
    CGFloat btnX    = width - btnH - WIDTH(20);
    CGFloat btnY    = headerY - HEIGHT(3);
    self.modifyBtn.frame = CGRectMake(btnX, btnY, btnH, btnH);
    
    CGFloat bottomH = HEIGHT(50);
    CGFloat bottomY = height - bottomH;
    self.bottomView.frame = CGRectMake(0, bottomY, width, bottomH);
    
    CGFloat totalH  = bottomH * 0.5;
    CGFloat totalY  = bottomH - totalH - HEIGHT(3);
    self.totalLab.frame    = CGRectMake(0, totalY, width * 0.5, totalH);
    self.integralLab.frame = CGRectMake(0, HEIGHT(3), width * 0.5, totalH);
    self.rankLab.frame     = CGRectMake(width * 0.5, totalY, width * 0.5, totalH);
    self.gradeLab.frame    = CGRectMake(width * 0.5, HEIGHT(3), width * 0.5, totalH);
}

- (void)headerDidClick:(UITapGestureRecognizer *)tap
{
    BOOL didLogin = [UserDefaults boolForKey:USER_DIDLOGIN];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mineHeadView:didLogin:)]) {
        [self.delegate mineHeadView:self didLogin:didLogin];
    }
}

- (void)modifyUserInfo:(UIButton *)sender
{
    NSLog(@"modifyUserInfo");
}
@end
