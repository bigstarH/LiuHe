//
//  BaseTabBarController.m
//  Text
//
//  Created by huxingqin on 2016/11/21.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "UserViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *attr       = @{NSForegroundColorAttributeName : [UIColor lightGrayColor]};
    NSDictionary *attrSelect = @{NSForegroundColorAttributeName : [UIColor colorWithRed:209/255.0 green:192/255.0 blue:166/255.0 alpha:1.0]};
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:attrSelect forState:UIControlStateSelected];
    
    HomeViewController *homeVC  = [[HomeViewController alloc] init];
    BaseViewController *forumVC = [[BaseViewController alloc] init];
    UserViewController *userVC  = [[UserViewController alloc] init];
    
    homeVC.tabBarItem    = [[UITabBarItem alloc] initWithTitle:@"首頁"
                                                         image:[UIImage imageNamed:@"tabbar_menu"]
                                                 selectedImage:[UIImage imageNamed:@"tabbar_menu_press"]];
    
    forumVC.tabBarItem   = [[UITabBarItem alloc] initWithTitle:@"论坛"
                                                         image:[UIImage imageNamed:@"tabbar_forum"]
                                                 selectedImage:[UIImage imageNamed:@"tabbar_forum_press"]];
    
    userVC.tabBarItem    = [[UITabBarItem alloc] initWithTitle:@"用户"
                                                         image:[UIImage imageNamed:@"tabbar_user"]
                                                 selectedImage:[UIImage imageNamed:@"tabbar_user_press"]];
    
    self.viewControllers = @[[[BaseNavigationController alloc] initWithRootViewController:homeVC],
                             [[BaseNavigationController alloc] initWithRootViewController:forumVC],
                             [[BaseNavigationController alloc] initWithRootViewController:userVC]];
    [self setSelectedIndex:0];
}

@end
