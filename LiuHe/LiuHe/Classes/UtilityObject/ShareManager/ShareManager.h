//
//  ShareManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

/** 二维码 —— 微信分享 */
+ (void)weChatShareWithCurrentVC:(UIViewController *)currentVC
                         success:(void (^)(NSString *result))successBlock
                         failure:(void (^)(NSString *error))failureBlock;
/** 二维码 —— 朋友圈分享 */
+ (void)weChatTimeLineShareWithCurrentVC:(UIViewController *)currentVC
                                 success:(void (^)(NSString *result))successBlock
                                 failure:(void (^)(NSString *error))failureBlock;
/** 二维码 —— QQ分享 */
+ (void)QQShareWithCurrentVC:(UIViewController *)currentVC
                     success:(void (^)(NSString *result))successBlock
                     failure:(void (^)(NSString *error))failureBlock;
/** 二维码 —— QQ空间分享 */
+ (void)QZoneWithCurrentVC:(UIViewController *)currentVC
                   success:(void (^)(NSString *result))successBlock
                   failure:(void (^)(NSString *error))failureBlock;
/** 消息信息 —— 微信分享 */
+ (void)weChatShareWithText:(NSString *)mesText
                  currentVC:(UIViewController *)currentVC
                    success:(void (^)(NSString *result))successBlock
                    failure:(void (^)(NSString *error))failureBlock;
/** 消息信息 —— 朋友圈分享 */
+ (void)weChatTimeLineShareWithText:(NSString *)mesText
                          currentVC:(UIViewController *)currentVC
                            success:(void (^)(NSString *result))successBlock
                            failure:(void (^)(NSString *error))failureBlock;
/** 消息信息 —— QQ分享 */
+ (void)QQShareWithText:(NSString *)mesText
              currentVC:(UIViewController *)currentVC
                success:(void (^)(NSString *result))successBlock
                failure:(void (^)(NSString *error))failureBlock;
/** 消息信息 —— QQ空间分享 */
+ (void)QZoneShareWithText:(NSString *)mesText
                 currentVC:(UIViewController *)currentVC
                   success:(void (^)(NSString *result))successBlock
                   failure:(void (^)(NSString *error))failureBlock;
@end
