//
//  ShareManager.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>
#import "SystemManager.h"
#import "ShareManager.h"

/** 分享 */
@implementation ShareManager

+ (void)weChatShareWithCurrentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    
    UMShareImageObject *imageObject  = [[UMShareImageObject alloc] init];
    imageObject.shareImage = [SystemManager qrcodeURL];
    mesObject.shareObject  = imageObject;
    
    [self shareToPlatform:UMSocialPlatformType_WechatSession
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)weChatTimeLineShareWithCurrentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    
    UMShareImageObject *imageObject  = [[UMShareImageObject alloc] init];
    imageObject.shareImage = [SystemManager qrcodeURL];
    mesObject.shareObject  = imageObject;
    
    [self shareToPlatform:UMSocialPlatformType_WechatTimeLine
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)shareToPlatform:(UMSocialPlatformType)type mesObj:(UMSocialMessageObject *)mesObj currentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    [[UMSocialManager defaultManager] shareToPlatform:type
                                        messageObject:mesObj
                                currentViewController:currentVC
                                           completion:^(id result, NSError *error) {
                                               if (error) {
                                                   failureBlock ? failureBlock(@"分享失败") : nil;
                                               }else {
                                                   successBlock ? successBlock(@"分享成功") : nil;
                                               }
                                           }];
}

@end
