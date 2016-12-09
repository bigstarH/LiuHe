//
//  MBProgressHUD+Extension.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/8.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MBProgressHUD+Extension.h"

@implementation MBProgressHUD (Extension)

+ (instancetype)hudView:(UIView *)view text:(NSString *)text removeOnHide:(BOOL)hide
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text     = text;
    hud.removeFromSuperViewOnHide = hide;
    hud.userInteractionEnabled    = NO;
    return hud;
}

+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3];
    }
}

+ (void)showSuccessInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_success"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:time];
    }
}

+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failure"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:3];
    }
}

+ (void)showFailureInView:(UIView *)view mesg:(NSString *)mesg afterDismiss:(NSTimeInterval)time
{
    if (view) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.userInteractionEnabled = NO;
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_failure"]];
        hud.label.text = mesg;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:time];
    }
}
@end
