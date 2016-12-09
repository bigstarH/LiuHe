//
//  HistoryCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/30.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "HistoryCell.h"
#import "LotteryView.h"

@interface HistoryCell ()
/** 期数Label */
//@property (nonatomic, weak) UILabel *noLabel;
/** 开奖时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 号码视图 */
@property (nonatomic, weak) LotteryView *lotView;
@end

@implementation HistoryCell

+ (instancetype)historyCell:(UITableView *)tableView
{
    static NSString *hisCellID = @"HistoryCell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:hisCellID];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hisCellID];
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel = label;
    label.font     = [UIFont boldSystemFontOfSize:fontSize(16)];
    [self.contentView addSubview:label];
    
//    label          = [[UILabel alloc] init];
//    self.noLabel   = label;
//    label.font     = [UIFont systemFontOfSize:fontSize(14)];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [self.contentView addSubview:label];
    
    LotteryView *lotView = [[LotteryView alloc] init];
    self.lotView         = lotView;
    [self.contentView addSubview:lotView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.timeLabel.frame, CGRectZero)) return;
    
    CGFloat width      = self.bounds.size.width;
    CGFloat height     = self.bounds.size.height;
    
    CGFloat labelW     = WIDTH(54);
    
    CGFloat lotViewW   = width - labelW;
    self.lotView.frame = CGRectMake(0, 0, lotViewW, height);
    
    self.timeLabel.frame = CGRectMake(lotViewW, 0, labelW, height);
}

- (void)setCellData:(LotteryNumberModel *)model
{
    self.timeLabel.text = [NSString stringWithFormat:@"%@期", model.bq];
    self.lotView.model  = model;
}

@end
