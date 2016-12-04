//
//  NetworkManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkUrl.h"

@interface NetworkManager : NSObject

+ (instancetype)shareManager;

#pragma mark - start 网络请求
/** 1  获取广告图 */
- (void)getADWithURL:(NSString *)urlStr
             success:(void (^)(NSArray *imagesArray))successBlock
             failure:(void (^)(NSString *error))failureBlock;
/** 2  用户登录 */
- (void)userLoginWithUsername:(NSString *)userName
                     password:(NSString *)password
                      success:(void (^)())successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 3  用户注销 */
- (void)userLogoutWithSuccess:(void (^)())successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 4  用户注册 */
- (void)userRegisterWithUserName:(NSString *)userName
                        password:(NSString *)password
                      repassword:(NSString *)repassword
                           phone:(NSString *)phone
                           email:(NSString *)email
                         success:(void (^)())successBlock
                         failure:(void (^)(NSString *error))failureBlock;
/** 5  我的资料 */
- (void)userInfoWithSuccess:(void (^)(NSDictionary *dict))successBlock
                    failure:(void (^)(NSString *error))failureBlock;
/** 6  修改密码 */
- (void)modifyPswWithOldPsw:(NSString *)oldPsw
                        psw:(NSString *)psw
                 confirmPsw:(NSString *)confirmPsw
                    success:(void (^)(NSString *userName, NSString *ts))successBlock
                    failure:(void (^)(NSString *error))failureBlock;
/** 7  修改资料 */
- (void)modifyUserInfoWithTrueName:(NSString *)trueName
                             phone:(NSString *)phone
                          QQNumber:(NSString *)QQ
                      weChatNumber:(NSString *)weChat
                         headImage:(UIImage *)image
                           success:(void (^)(NSString *str))successBlock
                           failure:(void (^)(NSString *error))failureBlock;
/** 8  用户反馈 */
- (void)userFeedBackWithName:(NSString *)name
                       phone:(NSString *)phone
                     content:(NSString *)content
                     success:(void (^)(NSString *str))successBlock
                     failure:(void (^)(NSString *error))failureBlock;
/** 9  发布帖子 */
- (void)postReleaseWithEnews:(NSString *)enews
                         sid:(NSString *)sid
                       title:(NSString *)title
                     content:(NSString *)content
                     success:(void (^)(NSString *str))successBlock
                     failure:(void (^)(NSString *error))failureBlock;
/** 10 用户签到 */
- (void)userSignInWithSuccess:(void (^)(NSDictionary *dict))successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 11 我的帖子 */
- (void)userPostWithEnews:(NSString *)enews
                  success:(void (^)(NSArray *array))successBlock
                  failure:(void (^)(NSString *error))failureBlock;
/** 12 我的帖子——详情内容 */
- (void)userPostDetailWithEnews:(NSString *)enews
                            sid:(NSString *)sid
                        success:(void (^)(NSDictionary *dict))successBlock
                        failure:(void (^)(NSString *error))failureBlock;
/** 13 我的收藏 */
- (void)userCollectionWithSuccess:(void (^)(NSArray *array))successBlock
                          failure:(void (^)(NSString *error))failureBlock;
/** 14 取消收藏 */
- (void)cancelCollectingWithSid:(NSString *)sid
                          success:(void (^)(NSString *str))successBlock
                          failure:(void (^)(NSString *error))failureBlock;
/** 15 我的回复 */
- (void)userReplyWithEnews:(NSString *)enews
                   success:(void (^)(NSArray *array))successBlock
                   failure:(void (^)(NSString *error))failureBlock;
/** 16 六合开奖号码 */
- (void)lotteryStartWithSuccess:(void (^)(NSDictionary *dict))successBlock
                        failure:(void (^)(NSString *error))failureBlock;
/** 17 下期开奖事件 */
- (void)lotteryNextTimeWithSuccess:(void (^)(NSString *time))successBlock
                           failure:(void (^)(NSString *error))failureBlock;
/** 18 历史记录列表 */
- (void)lotteryHistoryWithSuccess:(void (^)(NSArray *array))successBlock
                          failure:(void (^)(NSString *error))failureBlock;
/** 19 六合资料 */
- (void)dataWithClassID:(NSString *)classID
                   star:(NSString *)star
                success:(void (^)(NSArray *array))successBlock
                failure:(void (^)(NSString *error))failureBlock;
/** 20 六合资料——详情内容 */
- (void)dataDetailWithSid:(NSString *)sid
                  success:(void (^)(NSDictionary *dict))successBlock
                  failure:(void (^)(NSString *error))failureBlock;

/** 21 六合图库列表 */
- (void)picLibraryWithClassID:(NSString *)classID
                         star:(NSString *)star
                      success:(void (^)(NSArray *array))successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 22 收藏 */
- (void)collectingWithClassID:(NSString *)classID
                           ID:(NSString *)ID
                      success:(void (^)(NSString *string))successBlock
                      failure:(void (^)(NSString *error))failureBlock;
/** 23 六合寻宝 */
- (void)treasureWithSuccess:(void (^)(NSArray *array))successBlock
                    failure:(void (^)(NSString *error))failureBlock;
/** 24 论坛帖子 */
- (void)forumPostWithStar:(NSString *)star
                  success:(void (^)(NSArray *array))successBlock
                  failure:(void (^)(NSString *error))failureBlock;
/** 25 论坛帖子详情内容 */
- (void)forumPostDetailWithSid:(NSString *)sid
                       success:(void (^)(NSDictionary *dict))successBlock
                       failure:(void (^)(NSString *error))failureBlock;
#pragma mark end 网络请求

@end
