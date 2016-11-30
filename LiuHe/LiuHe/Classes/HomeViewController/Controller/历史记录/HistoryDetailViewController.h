//
//  HistoryDetailViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/30.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

@class LotteryNumberModel;
/** 每期详情 */
@interface HistoryDetailViewController : BaseViewController

@property (nonatomic, strong) LotteryNumberModel *model;

@end
