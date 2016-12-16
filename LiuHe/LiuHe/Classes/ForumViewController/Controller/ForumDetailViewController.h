//
//  ForumDetailViewController.h
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

@class ForumModel;
@interface ForumDetailViewController : BaseViewController

@property (nonatomic, strong) ForumModel *model;

@property (nonatomic) BOOL needReplyBtn;

@end
