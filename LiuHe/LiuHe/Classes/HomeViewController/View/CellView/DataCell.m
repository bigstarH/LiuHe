//
//  DataCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "DataCell.h"

@interface DataCell ()

@property (nonatomic, weak) UILabel *titleLab;

@property (nonatomic, weak) UIImageView *timeImageView;

@property (nonatomic, weak) UILabel *timeLab;

@end

@implementation DataCell

+ (instancetype)dataCell:(UITableView *)tableView
{
    DataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
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
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLab   = label;
    label.font      = [UIFont systemFontOfSize:fontSize(15)];
    [label setNumberOfLines:0];
    [self.contentView addSubview:label];
    
    UIImageView *timeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"news_item_date"]];
    self.timeImageView         = timeImageView;
    [self.contentView addSubview:timeImageView];
    
    label           = [[UILabel alloc] init];
    self.timeLab    = label;
    label.font      = [UIFont systemFontOfSize:fontSize(12)];
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelH      = HEIGHT(20);
    CGFloat titleX      = WIDTH(12);
    CGFloat titleW      = self.bounds.size.width - titleX * 2;
    CGFloat titleH      = self.bounds.size.height - HEIGHT(9) - labelH;
    self.titleLab.frame = CGRectMake(titleX, 0, titleW, titleH);
    
    CGRect timeImageViewF    = self.timeImageView.frame;
    timeImageViewF.origin.y  = CGRectGetMaxY(self.titleLab.frame) + (labelH - 14) * 0.5;
    timeImageViewF.origin.x  = titleX;
    self.timeImageView.frame = timeImageViewF;
    
    CGFloat createTimeX = CGRectGetMaxX(timeImageViewF) + WIDTH(5);
    CGFloat createTimeY = CGRectGetMaxY(self.titleLab.frame);
    self.timeLab.frame  = CGRectMake(createTimeX, createTimeY, WIDTH(140), labelH);
}

- (void)setCellData:(DataModel *)model
{
    self.titleLab.text = model.title;
    self.timeLab.text  = model.dateStr;
    if (model.isRead == 1) {
        [self.titleLab setTextColor:READ_COLOR];
    }else {
        [self.titleLab setTextColor:[UIColor blackColor]];
    }
}
@end
