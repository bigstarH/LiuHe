//
//  WebViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, WebVCType) {
    WebVCTypeTrendAnalyze = 0, /**< 走势分析 */
    WebVCTypeDateLottery  = 1  /**< 开奖日期 */
};

/** 网页视图控制器 */
@interface WebViewController : BaseViewController

@property (nonatomic) WebVCType type;

@end
