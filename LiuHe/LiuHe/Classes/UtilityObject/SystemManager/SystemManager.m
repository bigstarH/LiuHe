//
//  SystemManager.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "SystemManager.h"
#import <SDWebImage/SDImageCache.h>

static NSDateFormatter *dateFormatter = nil;

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

+ (NSString *)currentDateWithFormatter:(NSString *)formatter
{
    NSDate *date = [NSDate date];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString *)dateStringWithTime:(NSTimeInterval)time formatter:(NSString *)formatter
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_CN"]];
    }
    [dateFormatter setDateFormat:formatter];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (void)setAppInfoWithDict:(NSDictionary *)dict
{
    NSString *qrcode  = dict[@"qrcode"] ? dict[@"qrcode"] : @"";
    NSString *feature = dict[@"iosfeature"] ? dict[@"iosfeature"] : @""; 
    NSString *filelen = dict[@"filelen"] ? dict[@"filelen"] : @""; 
    NSString *ioson   = dict[@"ioson"] ? dict[@"ioson"] : @"0"; 
    NSString *iosvo   = dict[@"iosvo"] ? dict[@"iosvo"] : @"1";
    NSString *ipaurl  = dict[@"ipaurl"] ? dict[@"ipaurl"] : @"";  
    NSString *sharetext = dict[@"sharetext"] ? dict[@"sharetext"] : @""; 
    NSString *sharelink = dict[@"sharelink"] ? dict[@"sharelink"] : @""; 
    [UserDefaults setObject:qrcode forKey:APP_QRCODE];
    [UserDefaults setObject:feature forKey:APP_UPDATE_CONTENT];
    [UserDefaults setObject:filelen forKey:APP_FILE_SIZE];
    [UserDefaults setObject:ioson forKey:APP_MORE_APPLICATION];
    [UserDefaults setObject:iosvo forKey:APP_NEW_VERSION];
    [UserDefaults setObject:ipaurl forKey:APP_DOWNLOAD_URL];
    [UserDefaults setObject:sharetext forKey:APP_SHARE_TEXT];
    [UserDefaults setObject:sharelink forKey:APP_SHARE_LINK];
}

+ (NSString *)updateContent
{
    return [UserDefaults objectForKey:APP_UPDATE_CONTENT];
}

+ (BOOL)moreApplication
{
    return [[UserDefaults objectForKey:APP_MORE_APPLICATION] boolValue];
}

+ (NSString *)newVersion
{
    return [UserDefaults objectForKey:APP_NEW_VERSION];
}

+ (NSString *)downloadURL
{
    return [UserDefaults objectForKey:APP_DOWNLOAD_URL];
}

+ (NSString *)qrcodeURL
{
    return [UserDefaults objectForKey:APP_QRCODE];
}

+ (NSString *)shareText
{
    return [UserDefaults objectForKey:APP_SHARE_TEXT];
}

+ (NSString *)shareLink
{
    return [UserDefaults objectForKey:APP_SHARE_LINK];
}

+ (void)setUserLogin:(BOOL)isLogin
{
    [UserDefaults setBool:isLogin forKey:USER_DIDLOGIN];
}

+ (BOOL)userLogin
{
    return [UserDefaults boolForKey:USER_DIDLOGIN];
}
@end
