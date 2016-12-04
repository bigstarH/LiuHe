//
//  ForumCell.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/4.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "ForumCell.h"

@interface ForumCell ()

@property (nonatomic, weak) UIImageView *headImage;

@property (nonatomic, weak) UILabel *nameLab;

@property (nonatomic, weak) UILabel *groupLab;

@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, weak) UILabel *timeLab;

@property (nonatomic, weak) UILabel *readLab;

@property (nonatomic, weak) UIImageView *replyImage;

@property (nonatomic, weak) UILabel *replyLab;

@end

@implementation ForumCell

+ (instancetype)forumCell:(UITableView *)tableView
{
    ForumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.headImage         = imageView;
    imageView.contentMode  = UIViewContentModeScaleToFill;
    [imageView.layer setMasksToBounds:YES];
    [self.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font     = [UIFont systemFontOfSize:fontSize(13)];
    self.nameLab   = label;
    [self.contentView addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.font    = [UIFont systemFontOfSize:fontSize(13)];
    self.groupLab = label;
    [label setTextAlignment:NSTextAlignmentCenter];
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.layer.borderWidth = 1.0;
    [self.contentView addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.font    = [UIFont systemFontOfSize:fontSize(16)];
    self.titleLab = label;
    label.numberOfLines   = 0;
    [self.contentView addSubview:label];
    
    label        = [[UILabel alloc] init];
    label.font   = [UIFont systemFontOfSize:fontSize(12)];
    self.timeLab = label;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    
    label        = [[UILabel alloc] init];
    label.font   = [UIFont systemFontOfSize:fontSize(12)];
    self.readLab = label;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    
    label         = [[UILabel alloc] init];
    label.font    = [UIFont systemFontOfSize:fontSize(12)];
    self.replyLab = label;
    label.textColor = [UIColor lightGrayColor];
    [label setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:label];
    
    imageView       = [[UIImageView alloc] init];
    self.replyImage = imageView;
    imageView.image = [UIImage imageNamed:@"forum_reply"];
    [self.contentView addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat imageX = WIDTH(12);
    CGFloat imageY = HEIGHT(10);
    CGFloat imageW = WIDTH(30);
    self.headImage.frame = CGRectMake(imageX, imageY, imageW, imageW);
    [self.headImage.layer setCornerRadius:imageW * 0.5];
    
    CGFloat labelX = CGRectGetMaxX(self.headImage.frame) + WIDTH(10);
    CGFloat labelY = imageY;
    self.nameLab.frame = CGRectMake(labelX, labelY, self.model.userNameWidth, HEIGHT(18));
    
    labelX = CGRectGetMaxX(self.nameLab.frame);
    self.groupLab.frame = CGRectMake(labelX, labelY, self.model.groupNameWidth, HEIGHT(18));

    labelX         = CGRectGetMinX(self.nameLab.frame);
    CGFloat labelH = HEIGHT(20);
    labelY         = self.bounds.size.height - labelH - HEIGHT(3);
    self.timeLab.frame  = CGRectMake(labelX, labelY, WIDTH(75), labelH);
    
    labelX         = CGRectGetMaxX(self.timeLab.frame);
    self.readLab.frame  = CGRectMake(labelX, labelY, WIDTH(110), labelH);
    
    labelX         = self.bounds.size.width - self.model.replyWith - WIDTH(10);
    self.replyLab.frame = CGRectMake(labelX, labelY, self.model.replyWith, labelH);
    
    imageW = WIDTH(16);
    imageX = CGRectGetMinX(self.replyLab.frame) - imageW;
    self.replyImage.frame = CGRectMake(imageX, labelY + WIDTH(2), imageW, imageW);
    
    labelX         = CGRectGetMinX(self.nameLab.frame);
    labelY         = CGRectGetMaxY(self.nameLab.frame);
    labelH         = CGRectGetMinY(self.timeLab.frame) - labelY;
    CGFloat labelW = self.bounds.size.width - labelX - WIDTH(10);
    self.titleLab.frame = CGRectMake(labelX, labelY, labelW, labelH);
}

- (void)setModel:(ForumModel *)model
{
    _model = model;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.userpic] placeholderImage:nil];
    self.nameLab.text  = model.username;
    self.groupLab.text = model.groupname;
    self.titleLab.text = model.title;
    self.timeLab.text  = model.dateString;
    self.readLab.text  = [NSString stringWithFormat:@"已有%@人阅读", model.onclick];
    self.replyLab.text = [NSString stringWithFormat:@"%@", model.rnum];
}

@end
