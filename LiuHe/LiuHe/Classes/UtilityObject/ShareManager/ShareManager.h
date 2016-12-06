//
//  ShareManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

/** 微信分享 */
+ (void)weChatShareWithImageUrl:(NSString *)imageUrl
                      currentVC:(UIViewController *)currentVC
                        success:(void (^)(NSString *result))successBlock
                        failure:(void (^)(NSString *error))failureBlock;
/** 朋友圈分享 */
+ (void)weChatTimeLineShareWithImageUrl:(NSString *)imageUrl
                              currentVC:(UIViewController *)currentVC
                                success:(void (^)(NSString *result))successBlock
                                failure:(void (^)(NSString *error))failureBlock;
@end
