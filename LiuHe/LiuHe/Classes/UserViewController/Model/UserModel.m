//
//  UserModel.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "UserModel.h"

#define FILE_NAME  @"usr.plist"

static UserModel *userInfo = nil;

@implementation UserModel

+ (instancetype)userModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setAttributeWithDict:dict];
    }
    return self;
}

+ (instancetype)getCurrentUser
{
    if (userInfo == nil) {
        NSString *rootPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:FILE_NAME];
        NSDictionary *dict  = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
        if (dict) {
            UserModel *ret  = [self userModelWithDict:dict];
            userInfo        = ret;
        }
    }
    return userInfo;
}

- (void)saveUserInfoWhenLogin
{
    NSString *rootPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:FILE_NAME];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (data == nil) {
        data = [NSMutableDictionary dictionary];
    }
    data[@"hym"] = self.userName ? self.userName : @"";
    data[@"dj"]  = self.rank ? self.rank : @"";
    data[@"jf"]  = self.integral ? self.integral : @"";
    data[@"rnd"] = self.rnd ? self.rnd : @"";
    data[@"tx"]  = self.headUrlStr ? self.headUrlStr : @"";
    data[@"uid"] = self.uid ? self.uid : @"";
    data[@"psw"] = self.password ? self.password : @"";
    [data writeToFile:plistPath atomically:YES];
}

- (void)saveUserInfoWithMyData
{
    NSString *rootPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:FILE_NAME];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (dict == nil) {
        dict = [NSMutableDictionary dictionary];
    }
    dict[@"email"]    = self.email ? self.email : @"";
    dict[@"oicq"]     = self.QQ ? self.QQ : @"";
    dict[@"phone"]    = self.phone ? self.phone : @"";
    dict[@"truename"] = self.trueName ? self.trueName : @"";
    dict[@"weixin"]   = self.weChat ? self.weChat : @"";
    dict[@"tx"]       = self.headUrlStr ? self.headUrlStr : @"";
    [dict writeToFile:plistPath atomically:YES];
    userInfo = [UserModel userModelWithDict:dict];
}

- (void)setAttributeWithDict:(NSDictionary *)dict
{
    self.userName   = [dict objectForKey:@"hym"];
    self.rank       = [dict objectForKey:@"dj"];
    self.integral   = [dict objectForKey:@"jf"];
    self.rnd        = [dict objectForKey:@"rnd"];
    self.headUrlStr = [dict objectForKey:@"tx"];
    self.uid        = [dict objectForKey:@"uid"];
    self.password   = [dict objectForKey:@"psw"];
    self.email      = [dict objectForKey:@"email"];
    self.QQ         = [dict objectForKey:@"oicq"];
    self.phone      = [dict objectForKey:@"phone"];
    self.trueName   = [dict objectForKey:@"truename"];
    self.weChat     = [dict objectForKey:@"weixin"];
}

+ (void)removeCurrentUser
{
    userInfo = nil;
    NSFileManager *fileMger = [NSFileManager defaultManager];
    NSString *rootPath  = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:FILE_NAME];
    NSError *err;
    [fileMger removeItemAtPath:plistPath error:&err];
}

@end
