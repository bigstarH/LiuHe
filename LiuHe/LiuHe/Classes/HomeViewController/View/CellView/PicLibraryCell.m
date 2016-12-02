//
//  PicLibraryCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "PicLibraryCell.h"

@interface PicLibraryCell ()
/** 缩略图 */
@property (nonatomic, weak) UIImageView *thumbView;
/** 标题 */
@property (nonatomic, weak) UILabel *titleLab;
/** 时间图标 */
@property (nonatomic, weak) UIImageView *timeView;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLab;

@end

@implementation PicLibraryCell

+ (instancetype)picLibraryCell:(UITableView *)tableView
{
    PicLibraryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
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
    self.thumbView         = imageView;
    [imageView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    self.titleLab  = label;
    label.font     = [UIFont systemFontOfSize:fontSize(16)];
    [self.contentView addSubview:label];
    
    label           = [[UILabel alloc] init];
    self.timeLab    = label;
    label.font      = [UIFont systemFontOfSize:fontSize(13)];
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    
    imageView     = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"news_item_date"]];
    self.timeView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.thumbView.frame, CGRectZero)) return;
    
    CGFloat thumbW = WIDTH(40);
    CGFloat thumbX = WIDTH(15);
    CGFloat thumbY = (self.bounds.size.height - thumbW) * 0.5;
    self.thumbView.frame = CGRectMake(thumbX, thumbY, thumbW, thumbW);
    
    CGFloat titleX = CGRectGetMaxX(self.thumbView.frame) + WIDTH(15);
    CGFloat titleW = self.bounds.size.width - titleX - thumbX;
    CGFloat titleH = HEIGHT(35);
    self.titleLab.frame  = CGRectMake(titleX, 0, titleW, titleH);
    
    CGFloat timeLH = HEIGHT(25);
    CGFloat timeLY = self.bounds.size.height - timeLH;
    CGFloat timeVW = WIDTH(15);
    CGFloat timeVY = timeLY + (timeLH - timeVW) * 0.5;
    self.timeView.frame  = CGRectMake(titleX, timeVY, timeVW, timeVW);
    
    CGFloat timeLX = CGRectGetMaxX(self.timeView.frame) + WIDTH(5);
    CGFloat timeLW = WIDTH(150);
    self.timeLab.frame   = CGRectMake(timeLX, timeLY, timeLW, timeLH);
}

- (void)setCellData:(PicLibraryModel *)model
{
    NSLog(@"%@", model.urlString);
    [self.thumbView sd_setImageWithURL:[NSURL URLWithString:model.urlString] placeholderImage:nil];
    self.titleLab.text = model.text;
    self.timeLab.text  = model.dateString;
}

@end
