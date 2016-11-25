//
//  NetworkManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype)shareManager;

#pragma mark - start 网络请求

/** 1  用户登录 */
- (void)userLoginWithUsername:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)())successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 2  用户注销 */
- (void)userLogoutWithSuccess:(void (^)())successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 3  用户注册 */
- (void)userRegisterWithUserName:(NSString *)userName
                        password:(NSString *)password
                      repassword:(NSString *)repassword
                           phone:(NSString *)phone
                           email:(NSString *)email
                         success:(void (^)())successBlock
                         failure:(void (^)(NSString *error))failureBlock;
/** 4  我的资料 */
- (void)userInfoWithSuccess:(void (^)(NSDictionary *dict))successBlock
                    failure:(void (^)(NSString *error))failureBlock;
/** 5  修改密码 */
- (void)modifyPswWithOldPsw:(NSString *)oldPsw
                        psw:(NSString *)psw
                 confirmPsw:(NSString *)confirmPsw
                    success:(void (^)(NSString *userName, NSString *ts))successBlock
                    failure:(void (^)(NSString *error))failureBlock;
/** 6  修改资料 */
- (void)modifyUserInfoWithTrueName:(NSString *)trueName
                             phone:(NSString *)phone
                          QQNumber:(NSString *)QQ
                      weChatNumber:(NSString *)weChat
                         headImage:(UIImage *)image
                           success:(void (^)(NSString *str))successBlock
                           failure:(void (^)(NSString *error))failureBlock;

/** 7  获取首页广告图 */
- (void)getHomeADWithSuccess:(void (^)(NSArray *imagesArray))successBlock
                     failure:(void (^)(NSString *error))failureBlock;
#pragma mark end 网络请求

@end
