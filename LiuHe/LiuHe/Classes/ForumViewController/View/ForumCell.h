//
//  ForumCell.h
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/4.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumModel.h"

@interface ForumCell : UITableViewCell

@property (nonatomic, strong) ForumModel *model;

+ (instancetype)forumCell:(UITableView *)tableView;

@end
