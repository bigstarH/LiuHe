//
//  ForumDetailHeader.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "ForumDetailHeader.h"
#import "ForumModel.h"

@interface ForumDetailHeader ()

@property (nonatomic, weak) UIImageView *headImage;

@property (nonatomic, weak) UILabel *nameLab;

@property (nonatomic, weak) UILabel *groupLab;

@property (nonatomic, weak) UILabel *integralLab;

@property (nonatomic, weak) UILabel *contentLab;

@property (nonatomic, weak) UILabel *timeLab;

@property (nonatomic, weak) UILabel *readLab;

@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, weak) UIView *bottomView;

@property (nonatomic, weak) UILabel *commentLab;

@end

@implementation ForumDetailHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    self.headImage         = imageView;
    imageView.contentMode  = UIViewContentModeScaleToFill;
    [imageView.layer setMasksToBounds:YES];
    [imageView.layer setCornerRadius:WIDTH(18)];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font     = [UIFont systemFontOfSize:fontSize(13)];
    self.nameLab   = label;
    [self addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.font    = [UIFont systemFontOfSize:fontSize(13)];
    self.groupLab = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 1.0;
    [self addSubview:label];
    
    label            = [[UILabel alloc] init];
    label.font       = [UIFont systemFontOfSize:fontSize(13)];
    self.integralLab = label;
    [self addSubview:label];
    
    label           = [[UILabel alloc] init];
    label.font      = [UIFont systemFontOfSize:fontSize(13)];
    self.timeLab    = label;
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    label           = [[UILabel alloc] init];
    label.font      = [UIFont systemFontOfSize:fontSize(13)];
    self.readLab    = label;
    label.textColor = [UIColor lightGrayColor];
    [self addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.font    = [UIFont boldSystemFontOfSize:fontSize(16)];
    self.titleLab = label;
    [label setNumberOfLines:0];
    [self addSubview:label];
    
    label           = [[UILabel alloc] init];
    label.font      = [UIFont systemFontOfSize:fontSize(16)];
    self.contentLab = label;
    [label setNumberOfLines:0];
    [self addSubview:label];
    
    UIView *bottomView = [[UIView alloc] init];
    self.bottomView    = bottomView;
    [bottomView setBackgroundColor:MAIN_COLOR];
    [self addSubview:bottomView];
    
    UILabel *commentLab = [[UILabel alloc] init];
    self.commentLab     = commentLab;
    commentLab.font     = [UIFont systemFontOfSize:fontSize(15)];
    [commentLab setTextColor:[UIColor whiteColor]];
    [bottomView addSubview:commentLab];
}

- (void)setUIFrame
{
    self.headImage.frame = CGRectMake(WIDTH(12), HEIGHT(10), WIDTH(36), WIDTH(36));
    
    CGFloat labelX = CGRectGetMaxX(self.headImage.frame) + WIDTH(10);
    CGFloat labelY = CGRectGetMinY(self.headImage.frame);
    CGFloat labelH = HEIGHT(19);
    self.nameLab.frame  = CGRectMake(labelX, labelY, self.model.userNameWidth, labelH);
    
    labelX = CGRectGetMaxX(self.nameLab.frame);
    self.groupLab.frame = CGRectMake(labelX, labelY, self.model.groupNameWidth, labelH);
    
    labelX         = CGRectGetMaxX(self.groupLab.frame) + WIDTH(5);
    CGFloat labelW = self.bounds.size.width - labelX - WIDTH(10);
    self.integralLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
    
    labelX = CGRectGetMinX(self.nameLab.frame);
    labelY = CGRectGetMaxY(self.nameLab.frame) + HEIGHT(6);
    labelH = HEIGHT(20);
    self.timeLab.frame  = CGRectMake(labelX, labelY, WIDTH(75), labelH);
    
    labelX = CGRectGetMaxX(self.timeLab.frame);
    self.readLab.frame  = CGRectMake(labelX, labelY, WIDTH(110), labelH);
    
    labelX = WIDTH(12);
    labelW = self.bounds.size.width - labelX * 2;
    labelY = CGRectGetMaxY(self.timeLab.frame);
    self.titleLab.frame = CGRectMake(labelX, labelY, labelW, self.model.titleHeight);
    
    labelY = CGRectGetMaxY(self.titleLab.frame) - HEIGHT(5);
    self.contentLab.frame = CGRectMake(labelX, labelY, labelW, self.model.contentHeight);
    
    CGFloat viewY = CGRectGetMaxY(self.contentLab.frame);
    CGFloat viewH = HEIGHT(45);
    self.bottomView.frame = CGRectMake(0, viewY, self.bounds.size.width, viewH);
    
    labelX = WIDTH(5);
    labelW = self.bounds.size.width - labelX * 2;
    self.commentLab.frame = CGRectMake(labelX, 0, labelW, viewH);
    
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(self.bottomView.frame);
    self.frame   = frame;
}

- (void)setModel:(ForumModel *)model
{
    _model = model;
    
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:nil];
    self.nameLab.text     = model.username;
    self.groupLab.text    = model.groupname;
    self.integralLab.text = [NSString stringWithFormat:@"%@分", model.userfen];
    self.titleLab.text    = model.title;
    self.timeLab.text     = model.dateString;
    self.readLab.text     = [NSString stringWithFormat:@"已有%@人阅读", model.onclick];
    self.contentLab.text  = model.newstext;
    self.commentLab.text  = [NSString stringWithFormat:@"回復列表(%d) ",model.rnum.intValue];
    [self setUIFrame];
}
@end
