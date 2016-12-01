//
//  NetworkManager.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NetworkManager.h"
#import "UserModel.h"

static id networkInstance;

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation NetworkManager

+ (instancetype)shareManager
{
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t networkToken;
    dispatch_once(&networkToken, ^{
        networkInstance = [super allocWithZone:zone];
    });
    return networkInstance;
}

- (AFHTTPSessionManager *)manager
{
    if (_manager == nil) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:BASE_URL]
                                              sessionConfiguration:configuration];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manager;
}

- (void)getADWithURL:(NSString *)urlStr success:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [self.manager GET:urlStr parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSArray *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                  successBlock ? successBlock(responseArr) : nil;
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failureBlock ? failureBlock(@"網絡錯誤") : nil;
              }];
}

- (void)userLoginWithUsername:(NSString *)userName password:(NSString *)password success:(void (^)())successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"login", @"username" : userName, @"password" : password};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   if (code == 1) {
                       [UserDefaults setBool:YES forKey:USER_DIDLOGIN];
                       UserModel *model = [UserModel userModelWithDict:responseDict];
                       model.password   = password;
                       [model saveUserInfoWhenLogin];
                       successBlock ? successBlock() : nil;
                       [NotificationCenter postNotificationName:USER_LOGIN_SUCCESS object:nil userInfo:@{@"userInfo" : model}];
                   }else {
                       NSString *error  = [responseDict objectForKey:@"ts"];
                       failureBlock ? failureBlock(error) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userLogoutWithSuccess:(void (^)())successBlock failure:(void (^)(NSString *))failureBlock
{
    UserModel *model    = [UserModel getCurrentUser];
    NSDictionary *param = @{@"enews"    : @"exit",
                            @"userid"   : model.uid ? model.uid : @"",
                            @"username" : model.userName ? model.userName : @"",
                            @"rnd"      : model.rnd ? model.rnd : @""};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   successBlock ? successBlock() : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userRegisterWithUserName:(NSString *)userName password:(NSString *)password repassword:(NSString *)repassword phone:(NSString *)phone email:(NSString *)email success:(void (^)())successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"register", @"username" : userName, @"password" : password,
                            @"repassword" : repassword, @"phone" : phone};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   if (code == 1) {
                       successBlock ? successBlock() : nil;
                   }else {
                       NSString *error = [responseDict objectForKey:@"ts"];
                       failureBlock ? failureBlock(error) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userInfoWithSuccess:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UserModel *model    = [UserModel getCurrentUser];
    NSDictionary *param = @{@"enews"    : @"Info",
                            @"userid"   : model.uid ? model.uid : @"",
                            @"username" : model.userName ? model.userName : @"",
                            @"rnd"      : model.rnd ? model.rnd : @""};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   if (code == 1){
                       successBlock ? successBlock(responseDict) : nil;
                   }else {
                       NSString *error  = [responseDict objectForKey:@"ts"];
                       failureBlock ? failureBlock(error) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)modifyPswWithOldPsw:(NSString *)oldPsw psw:(NSString *)psw confirmPsw:(NSString *)confirmPsw success:(void (^)(NSString *, NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UserModel *model    = [UserModel getCurrentUser];
    NSDictionary *param = @{@"enews"    : @"EditSafeInfo",
                            @"userid"   : model.uid,
                            @"username" : model.userName,
                            @"rnd"      : model.rnd,
                            @"oldpassword" : oldPsw,
                            @"password"    : psw,
                            @"repassword"  : confirmPsw};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   NSString *str  = [responseDict objectForKey:@"ts"];
                   if (code == 1) {
                       successBlock ? successBlock(model.userName, str) : nil;
                   }else {
                       failureBlock ? failureBlock(str) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)modifyUserInfoWithTrueName:(NSString *)trueName phone:(NSString *)phone QQNumber:(NSString *)QQ weChatNumber:(NSString *)weChat headImage:(UIImage *)image success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UserModel *model    = [UserModel getCurrentUser];
    NSDictionary *param = @{@"enews"    : @"EditInfo",
                            @"userid"   : model.uid,
                            @"username" : model.userName,
                            @"rnd"      : model.rnd,
                            @"truename" : trueName,
                            @"phone"    : phone,
                            @"oicq"     : QQ,
                            @"weixin" : weChat};
    
    [self.manager POST:USER_RELATION_URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         if (image) {
             NSData *data = UIImageJPEGRepresentation(image, 0.5);
             [formData appendPartWithFileData:data name:@"userpicfile" fileName:@"userpicfile.jpg" mimeType:@"image/jpg"];
         }
     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
         NSString *ts   = [responseDict objectForKey:@"ts"];
         if (code == 1) {
             successBlock ? successBlock(ts) : nil;
         }else {
             failureBlock ? failureBlock(ts) : nil;
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failureBlock ? failureBlock(@"網絡錯誤") : nil;
     }];
}

- (void)userFeedBackWithName:(NSString *)name phone:(NSString *)phone content:(NSString *)content success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews"   : @"ToFeedback",
                            @"bid"     : @"7",
                            @"name"    : name,
                            @"phone"   : phone,
                            @"saytext" : content};
    [self.manager POST:USER_SETTING_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   NSString *ts   = [responseDict objectForKey:@"ts"];
                   if (code == 1) {
                       successBlock ? successBlock(ts) : nil;
                   }else {
                       failureBlock ? failureBlock(ts) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)postReleaseWithEnews:(NSString *)enews sid:(NSString *)sid title:(NSString *)title content:(NSString *)content success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:enews forKey:@"enews"];
    [param setObject:@"1" forKey:@"classid"];
    [param setObject:title forKey:@"title"];
    [param setObject:content forKey:@"newstext"];
    [param setObject:[UserModel getCurrentUser].uid forKey:@"userid"];
    [param setObject:[UserModel getCurrentUser].userName forKey:@"username"];
    [param setObject:[UserModel getCurrentUser].rnd forKey:@"rnd"];
    if (sid) [param setObject:sid forKey:@"id"];
    [self.manager POST:POST_RELEASE_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   NSString *ts   = [responseDict objectForKey:@"ts"];
                   if (code == 1) {
                       successBlock ? successBlock(ts) : nil;
                   }else {
                       failureBlock ? failureBlock(ts) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userSignInWithSuccess:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews"    : @"signfen",
                            @"userid"   : [UserModel getCurrentUser].uid,
                            @"username" : [UserModel getCurrentUser].userName,
                            @"rnd"      : [UserModel getCurrentUser].rnd};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   NSString *ts   = [responseDict objectForKey:@"ts"];
                   if (code == 1) {
                       successBlock ? successBlock(responseDict) : nil;
                   }else {
                       failureBlock ? failureBlock(ts) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userPostWithEnews:(NSString *)enews success:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : enews,
                            @"uid"   : [UserModel getCurrentUser].uid};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(array) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userPostDetailWithEnews:(NSString *)enews sid:(NSString *)sid success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : enews,
                            @"uid"   : [UserModel getCurrentUser].uid,
                            @"sid"   : sid};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(responseDict) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userCollectionWithSuccess:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"Myfava",
                            @"uid"   : [UserModel getCurrentUser].uid};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(array) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)cancelCollectingWithSid:(NSString *)sid success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews"    : @"DelFava",
                            @"favaid"   : sid,
                            @"userid"   : [UserModel getCurrentUser].uid,
                            @"rnd"      : [UserModel getCurrentUser].rnd,
                            @"username" : [UserModel getCurrentUser].userName};
    [self.manager POST:USER_RELATION_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   NSString *ts   = [responseDict objectForKey:@"ts"];
                   if (code == 1) {
                       successBlock ? successBlock(ts) : nil;
                   }else {
                       failureBlock ? failureBlock(ts) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)userReplyWithEnews:(NSString *)enews success:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : enews,
                            @"uid"   : [UserModel getCurrentUser].uid};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(array) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)lotteryStartWithSuccess:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [self.manager POST:USER_POST_URL parameters:@{@"enews" : @"IosKj"} progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   if (code == 1) {
                       successBlock ? successBlock(responseDict) : nil;
                   }else {
                       failureBlock ? failureBlock(@"") : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)lotteryNextTimeWithSuccess:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [self.manager POST:USER_POST_URL parameters:@{@"enews" : @"Kjtime"} progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSString *time = responseDict[@"time"];
                   successBlock ? successBlock(time) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)lotteryHistoryWithSuccess:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [self.manager GET:LOTTERY_HISTORY_URL parameters:nil progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(array) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)dataWithClassID:(NSString *)classID star:(NSString *)star success:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews"   : @"zhiliaolist",
                            @"classid" : classID,
                            @"star"    : star};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(array) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)dataDetailWithSid:(NSString *)sid success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"zhiliaoShow",
                            @"sid"   : sid};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[dict objectForKey:@"zt"] integerValue];
                   if (code == 1) {
                       successBlock ? successBlock(dict) : nil;
                   }else {
                       failureBlock ? failureBlock(@"") : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}

- (void)forumPostWithStar:(NSString *)star success:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"bbslist",
                            @"star"  : star};
    [self.manager POST:USER_POST_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSArray *array = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   successBlock ? successBlock(array) : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(@"網絡錯誤") : nil;
               }];
}
@end
