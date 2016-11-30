//
//  SystemManager.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "SystemManager.h"
#import <SDWebImage/SDImageCache.h>


@implementation SystemManager

+ (NSString *)getCacheSize
{
    NSUInteger cacheSize = [[SDImageCache sharedImageCache] getSize];
    CGFloat tempSize     = cacheSize * 1.0 / 1024 / 1024;
    NSString *cacheStr   = tempSize >= 1.0 ? [NSString stringWithFormat:@"%.2f MB", tempSize] : [NSString stringWithFormat:@"%.2f KB", tempSize * 1024];
    return cacheStr;
}

+ (void)clearCache
{
    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
}

+ (NSString *)dateStringWithTime:(NSTimeInterval)time formatter:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

@end
