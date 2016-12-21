//
//  ShareManager.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UMSocialCore/UMSocialCore.h>
#import "MBProgressHUD+Extension.h"
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

+ (void)QQShareWithCurrentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    UMShareImageObject *imageObject  = [UMShareImageObject shareObjectWithTitle:@"六合藏宝图"
                                                                          descr:[SystemManager shareText]
                                                                      thumImage:nil];
    imageObject.shareImage = [SystemManager qrcodeURL];
    mesObject.shareObject  = imageObject;
    
    [self shareToPlatform:UMSocialPlatformType_QQ
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)QZoneWithCurrentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *webObject  = [UMShareWebpageObject shareObjectWithTitle:@"六合藏宝图"
                                                                            descr:[SystemManager shareText]
                                                                        thumImage:[SystemManager qrcodeURL]];
    webObject.webpageUrl  = [SystemManager shareLink];
    mesObject.shareObject = webObject;
    
    [self shareToPlatform:UMSocialPlatformType_Qzone
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)weChatShareWithText:(NSString *)mesText currentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    mesObject.text = mesText;
    [self shareToPlatform:UMSocialPlatformType_WechatSession
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)weChatTimeLineShareWithText:(NSString *)mesText currentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    mesObject.text = mesText;
    [self shareToPlatform:UMSocialPlatformType_WechatTimeLine
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)QQShareWithText:(NSString *)mesText currentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    mesObject.text = mesText;
    [self shareToPlatform:UMSocialPlatformType_QQ
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)QZoneShareWithText:(NSString *)mesText currentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    UMSocialMessageObject *mesObject = [UMSocialMessageObject messageObject];
    mesObject.text = mesText;
    [self shareToPlatform:UMSocialPlatformType_Qzone
                   mesObj:mesObject
                currentVC:currentVC
                  success:successBlock
                  failure:failureBlock];
}

+ (void)shareToPlatform:(UMSocialPlatformType)type mesObj:(UMSocialMessageObject *)mesObj currentVC:(UIViewController *)currentVC success:(void (^)(NSString *))successBlock failure:(void (^)(NSString *))failureBlock
{
    __weak UIViewController *vc = currentVC;
    [[UMSocialManager defaultManager] shareToPlatform:type
                                        messageObject:mesObj
                                currentViewController:currentVC
                                           completion:^(id result, NSError *error) {
                                               if (error) {
                                                   [MBProgressHUD showFailureInView:vc.view mesg:@"分享失败"];
                                                   failureBlock ? failureBlock(@"分享失败") : nil;
                                               }else {
                                                   [MBProgressHUD showSuccessInView:vc.view mesg:@"分享成功"];
                                                   successBlock ? successBlock(@"分享成功") : nil;
                                               }
                                           }];
}

@end
