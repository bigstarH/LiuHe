//
//  SystemManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemManager : NSObject

/** 
 *  获取缓存大小
 */
+ (NSString *)getCacheSize;
/**
 *  清除缓存
 */
+ (void)clearCache;
/**
 *  将NSTimeInterval转成NSDate字符串
 */
+ (NSString *)dateStringWithTime:(NSTimeInterval)time formatter:(NSString *)formatter;

@end
