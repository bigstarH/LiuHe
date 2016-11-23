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

- (void)getHomeADWithSuccess:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [self.manager GET:GET_INDEXAD_URL parameters:nil progress:nil
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              }];
}

//- (void)loginWithAccount:(NSString *)account password:(NSString *)password success:(void (^)(NSDictionary *))successBlock failure:(void (^)(NSString *))failureBlock
//{
//    NSDictionary *param = @{@"account" : account, @"password" : password};
//    [self.manager GET:Login_URL parameters:param progress:nil
//              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                  NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//                  NSInteger code       = [[responseDict objectForKey:@"code"] integerValue];
//                  NSDictionary *result = [responseDict objectForKey:@"data"];
//                  if (code == 0) {
//                      successBlock ? successBlock(result) : nil;
//                  }else {
//                      failureBlock ? failureBlock([responseDict objectForKey:@"Detail"]) : nil;
//                  }
//                  
//              } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                  failureBlock ? failureBlock(error.domain) : nil;
//              }];
//}
//
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
