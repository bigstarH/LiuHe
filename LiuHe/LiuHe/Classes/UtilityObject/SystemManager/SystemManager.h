//
//  SystemManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemManager : NSObject

/** 保存app信息 */
+ (void)setAppInfoWithDict:(NSDictionary *)dict;

/** 获取更新内容 */
+ (NSString *)updateContent;

/** 是否有更多应用 */
+ (BOOL)moreApplication;

/** 最新版本 */
+ (NSString *)newVersion;

/** 下载地址 */
+ (NSString *)downloadURL;

/** 二维码图片地址 */
+ (NSString *)qrcodeURL;

/** 分享文本 */
+ (NSString *)shareText;

/** 分享链接 */
+ (NSString *)shareLink;

/** 获取缓存大小 */
+ (NSString *)getCacheSize;

/** 清除缓存 */
+ (void)clearCache;

/** 将NSTimeInterval转成NSDate字符串 */
+ (NSString *)dateStringWithTime:(NSTimeInterval)time formatter:(NSString *)formatter;

@end
