//
//  NetworkManager.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "NetworkManager.h"
#import "NetworkUrl.h"
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

- (void)userLoginWithUsername:(NSString *)userName password:(NSString *)password success:(void (^)())successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"login", @"username" : userName, @"password" : password};
    [self.manager POST:USER_LOGIN_LOGOUT_REGISTER_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSInteger code = [[responseDict objectForKey:@"zt"] integerValue];
                   if (code == 1) {
                       [UserDefaults setBool:YES forKey:USER_DIDLOGIN];
                       UserModel *model = [UserModel userModelWithDict:responseDict];
                       model.password   = password;
                       [model saveUserInfo];
                       successBlock ? successBlock() : nil;
                       [NotificationCenter postNotificationName:USER_LOGIN_SUCCESS object:nil userInfo:@{@"userInfo" : model}];
                   }else {
                       NSString *error  = [responseDict objectForKey:@"ts"];
                       failureBlock ? failureBlock(error) : nil;
                   }
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   failureBlock ? failureBlock(error.domain) : nil;
               }];
}

- (void)userLogoutWithUserID:(NSString *)userID userName:(NSString *)userName rnd:(NSString *)rnd success:(void (^)())successBlock failure:(void (^)(NSString *))failureBlock
{
    NSDictionary *param = @{@"enews" : @"exit", @"userid" : userID, @"username" : userName, @"rnd" : rnd};
    [self.manager POST:USER_LOGIN_LOGOUT_REGISTER_URL parameters:param progress:nil
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                   NSLog(@"注销成功  responseDict = %@", responseDict);
                   successBlock ? successBlock() : nil;
               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   NSLog(@"注销失败");
                   failureBlock ? failureBlock(error.domain) : nil;
               }];
}

- (void)getHomeADWithSuccess:(void (^)(NSArray *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [self.manager GET:GET_INDEXAD_URL parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  NSArray *responseArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                  NSMutableArray *images = [NSMutableArray array];
                  for (int i = 0; i < responseArr.count; i++) {
                      NSDictionary *dict = responseArr[i];
                      [images addObject:dict[@"titlepic"]];
                  }
                  successBlock ? successBlock(images) : nil;
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  failureBlock ? failureBlock(error.domain) : nil;
              }];
}
//- (void)logoutWithSuccess:(void (^)())successBlock failure:(void (^)(NSString *))failureBlock
//{
//    NSDictionary *param = @{ @"account" : [UserModel userInfo].account };
//    [self.manager GET:Logout_URL parameters:param progress:nil
//              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                  [[UserModel userInfo] removeUserInfomation];
//                  [UserDefaults setBool:NO forKey:didLogin];
//                  successBlock ? successBlock() : nil;
//              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                  failureBlock ? failureBlock(error.domain) : nil;
//              }];
//}

//- (void)modifyUserInfo
//{
//    NSDictionary *dict = @{@"username" : @"huxingqin"};
//    
//    [self.manager POST:ModifyUserInfo parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
//     {
//         //添加Data类型的参数
//         NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"tara"]);
//         [formData appendPartWithFileData:data name:@"headData" fileName:[NSString stringWithFormat:@"%@.png", @"01"] mimeType:@"image/png"];
//     } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//         NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//         NSLog(@"responseObject = %@\nstr = %@",responseObject, str);
//     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         
//     }];
//}

@end
