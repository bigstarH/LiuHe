//
//  PicDetailViewController.h
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/3.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

@class PicLibraryModel;

/** 图库详情 */
@interface PicDetailViewController : BaseViewController

@property (nonatomic, strong) PicLibraryModel *model;

@property (nonatomic, copy) NSString *classID;

@end
