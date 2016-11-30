//
//  LotteryNumberModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/30.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LotteryNumberModel : NSObject
/** 期数 */
@property (nonatomic, copy) NSString *bq;
/** 开奖时间 */
@property (nonatomic, copy) NSString *newstime;
/** 刷新时间 */
@property (nonatomic, copy) NSString *sxsj;
/** 特别码 */
@property (nonatomic, copy) NSString *tm;
/** 特别码生肖 */
@property (nonatomic, copy) NSString *tmsx;
/** 星期 */
@property (nonatomic, copy) NSString *xq;
/** 下一期数 */
@property (nonatomic, copy) NSString *xyq;
/** 下一期开奖时间 */
@property (nonatomic, copy) NSString *xyqsj;
/** 号码1 */
@property (nonatomic, copy) NSString *z1m;
/** 号码1生肖 */
@property (nonatomic, copy) NSString *z1sx;
/** 号码2 */
@property (nonatomic, copy) NSString *z2m;
/** 号码2生肖 */
@property (nonatomic, copy) NSString *z2sx;
/** 号码3 */
@property (nonatomic, copy) NSString *z3m;
/** 号码3生肖 */
@property (nonatomic, copy) NSString *z3sx;
/** 号码4 */
@property (nonatomic, copy) NSString *z4m;
/** 号码4生肖 */
@property (nonatomic, copy) NSString *z4sx;
/** 号码5 */
@property (nonatomic, copy) NSString *z5m;
/** 号码5生肖 */
@property (nonatomic, copy) NSString *z5sx;
/** 号码6 */
@property (nonatomic, copy) NSString *z6m;
/** 号码6生肖 */
@property (nonatomic, copy) NSString *z6sx;
/** 状态 */
@property (nonatomic, copy) NSString *zt;

+ (instancetype)lotteryNumberWithDict:(NSDictionary *)dict;

@end
