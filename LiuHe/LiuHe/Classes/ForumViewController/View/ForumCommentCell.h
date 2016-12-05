//
//  ForumCommentCell.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ForumReplyModel;
/** 评论Cell */
@interface ForumCommentCell : UITableViewCell

@property (nonatomic, strong) ForumReplyModel *model;

+ (instancetype)forumCommentCell:(UITableView *)tableView;

@end
