//
//  AppDelegate.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import <UMSocialCore/UMSocialCore.h>
#import "NetworkManager.h"
#import "SystemManager.h"
#import "AppDelegate.h"
#import "XQAlertView.h"
#import "UserModel.h"

static NSString *UMengAppKey = @"5838115c734be42627000d73";

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self initTabBarController];
    
    // 用户登录
    [self userLogin];
    // 获取app版本，二维码等信息
    [self appInfomation];
    
    // 友盟SDK
    [self initUMengUShareSDK];
    return YES;
}

- (void)initTabBarController
{
    _tabBarController = [[BaseTabBarController alloc] init];
    self.window.rootViewController = _tabBarController;
}

- (void)userLogin
{
    UserModel *model = [UserModel getCurrentUser];
    if (model) {
        [[NetworkManager shareManager] userLoginWithUsername:model.userName
                                                    password:model.password
                                                     success:nil failure:nil];
    }
}

/** 获取app信息 */
- (void)appInfomation
{
    [[NetworkManager shareManager] appInfoWithSuccess:^(NSDictionary *dict) {
        [SystemManager setAppInfoWithDict:dict];
        [self checkVersion];
    } failure:^(NSString *error) {
        [MBProgressHUD showFailureInView:KeyWindow mesg:error];
    }];
}

/** 检查版本 */
- (void)checkVersion
{
    NSString *newVersion = [SystemManager newVersion];
    NSString *content = [SystemManager updateContent];
    NSString *url     = [SystemManager downloadURL];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (![version isEqualToString:newVersion]) {
        XQAlertView *alert = [[XQAlertView alloc] initWithTitle:@"新版本" message:content];
        [alert setThemeColor:MAIN_COLOR];
        [alert addButtonWithTitle:@"下次再说" style:XQAlertButtonStyleCancel handle:nil];
        [alert addButtonWithTitle:@"前往更新" style:XQAlertButtonStyleDefault handle:^{
            NSURL *address = [NSURL URLWithString:url];
            [[UIApplication sharedApplication] openURL:address];
        }];
        [alert show];
    }
}

#pragma mark - start 友盟分享
- (void)initUMengUShareSDK
{
    //打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
    
    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx97de6ce81fe10292" appSecret:@"2df199edc429bf3afb857b75cfbf144b" redirectURL:@"http://mobile.umeng.com/social"];
}
#pragma mark end 友盟分享

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
