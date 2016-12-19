//
//  AppDelegate.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

// 引 JPush功能所需头 件
#import "JPUSHService.h"
// iOS10注册APNs所需头 件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max 
#import <UserNotifications/UserNotifications.h> 
#endif
#import "MBProgressHUD+Extension.h"
#import <UMSocialCore/UMSocialCore.h>
#import "MessageViewController.h"
#import "NetworkManager.h"
#import "SystemManager.h"
#import "AppDelegate.h"
#import "XQAlertView.h"
#import "UserModel.h"

static NSString *UMengAppKey = @"5838115c734be42627000d73";
static NSString *UMeng_redirectURL = @"http://www.6happ.com/6h/6hcbt";

static NSString *JPushAppKey = @"36d8319967066bded734b83f";
static NSString *channel     = @"Publish channel";
static BOOL isProduction     = FALSE;

@interface AppDelegate () <JPUSHRegisterDelegate>

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
    
    // 极光SDK
    [self initJPushSDKWithOptions:launchOptions];
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

#pragma mark - start 推送跳转界面
- (void)goToMssageViewController:(NSString *)message
{
    MessageViewController *vc = [[MessageViewController alloc] init];
    vc.message = message;
    [self.tabBarController presentViewController:vc animated:YES completion:nil];
}
#pragma mark end 推送跳转界面

#pragma mark - start 极光推送
- (void)initJPushSDKWithOptions:(NSDictionary *)launchOptions
{
    // notice: 3.0.0及以后版本注册可以这样写，也可以继续 旧的注册 式
    if (IOS_10_LATER) {
        JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }else if (IOS_8_LATER) {
        // 可以添加 定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册 法，改成可上报IDFA，如果没有使 IDFA直接传nil
    // 如需继续使 pushConfig.plist 件声明appKey等配置内容，请依旧使 [JPUSHService setupWithOption:launchOptions] 式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSDictionary *dict = [remoteNotification valueForKey:@"aps"];
            NSString *content  = [dict valueForKey:@"alert"];
            [self goToMssageViewController:content];
        }
    }
}
#pragma mark end 极光推送

#pragma mark - start 友盟分享
- (void)initUMengUShareSDK
{
    // 打开日志
    [[UMSocialManager defaultManager] openLog:YES];
    
    // 设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
    
    // 设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx97de6ce81fe10292" appSecret:@"2df199edc429bf3afb857b75cfbf144b" redirectURL:UMeng_redirectURL];
    // 设置QQ的
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105813089" appSecret:nil redirectURL:UMeng_redirectURL];
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

/** 注册APNs成功并上报DeviceToken */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

/** 注册APNs失败接  */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
//    [application setApplicationIconBadgeNumber:0];
//    [JPUSHService resetBadge];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
//    [application setApplicationIconBadgeNumber:0];
//    [JPUSHService resetBadge];
    
    NSDictionary *dict = [userInfo valueForKey:@"aps"];
    NSString *content  = [dict valueForKey:@"alert"];
    if (application.applicationState == UIApplicationStateActive) {
    }else {
        [self goToMssageViewController:content];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
    [JPUSHService resetBadge];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark start - JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        NSDictionary *dict = [userInfo valueForKey:@"aps"];
        NSString *content  = [dict valueForKey:@"alert"];
        [self goToMssageViewController:content];
        NSLog(@"iOS10 收到远程通知:%@", content);
    }else { // 判断为本地通知
    }
    completionHandler();  // 系统要求执行这个方法
}
#pragma mark end JPUSHRegisterDelegate
@end
