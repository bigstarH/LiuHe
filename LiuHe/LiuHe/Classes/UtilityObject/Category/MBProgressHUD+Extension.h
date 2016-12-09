//
//  MBProgressHUD+Extension.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/8.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extension)

+ (instancetype)hudView:(UIView *)view text:(NSString *)text removeOnHide:(BOOL)hide;

/**
 *  成功时，显示信息
 */
+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg;
/** 
 *  成功时，显示信息
 */
+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time;

/**
 *  失败时，显示信息
 */
+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg;
/**
 *  失败时，显示信息
 */
+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time;
@end
