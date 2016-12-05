//
//  ForumCommentCell.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ForumCommentCell.h"
#import "ForumReplyModel.h"
#import "SystemManager.h"

@interface ForumCommentCell ()
/** 评论用户 */
@property (nonatomic, weak) UILabel *userNameLab;
/** 回复时间 */
@property (nonatomic, weak) UILabel *timeLab;
/** 回复内容 */
@property (nonatomic, weak) UILabel *contentLab;
@end

@implementation ForumCommentCell

+ (instancetype)forumCommentCell:(UITableView *)tableView
{
    ForumCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
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
    UILabel *label   = [[UILabel alloc] init];
    label.font       = [UIFont systemFontOfSize:fontSize(15)];
    label.textColor  = [UIColor blackColor];
    self.userNameLab = label;
    [self.contentView addSubview:label];
    
    label            = [[UILabel alloc] init];
    label.font       = [UIFont systemFontOfSize:fontSize(13)];
    label.textColor  = [UIColor lightGrayColor];
    self.timeLab     = label;
    [self.contentView addSubview:label];
    
    label            = [[UILabel alloc] init];
    label.font       = [UIFont systemFontOfSize:fontSize(16)];
    self.contentLab  = label;
    [label setNumberOfLines:0];
    [self.contentView addSubview:label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat nameX = WIDTH(12);
    CGFloat nameY = HEIGHT(6);
    CGFloat nameH = HEIGHT(26);
    CGFloat nameW = self.bounds.size.width - nameX * 2;
    self.userNameLab.frame = CGRectMake(nameX, nameY, nameW, nameH);
    
    CGFloat contentY = CGRectGetMaxY(self.userNameLab.frame) + HEIGHT(3);
    self.contentLab.frame  = CGRectMake(nameX, contentY, nameW, self.model.textHeight);
    
    CGFloat timeLabY = CGRectGetMaxY(self.contentLab.frame);
    CGFloat timeLabH = self.bounds.size.height - timeLabY;
    self.timeLab.frame = CGRectMake(nameX, timeLabY, nameW, timeLabH);
}

- (void)setModel:(ForumReplyModel *)model
{
    _model = model;
    self.userNameLab.text = model.hfusername;
    self.timeLab.text     = [SystemManager dateStringWithTime:[model.hfnewstime doubleValue] formatter:@"yyyy-MM-dd"];
    self.contentLab.text  = model.hftext;
}

@end
