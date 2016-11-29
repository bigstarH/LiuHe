//
//  TrendViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

typedef NS_ENUM(NSInteger, VCType) {
    VCTypeKaiJiang = 0,  /**< 视频开奖 */
    VCTypeTrend    = 1   /**< 走势分析 */
};

#import "BaseViewController.h"

@interface TrendViewController : BaseViewController

- (instancetype)initWithType:(VCType)type;

@end
