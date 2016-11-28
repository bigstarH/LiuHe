//
//  BaseViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/21.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <XQNavigationBarDelegate>

@end

@implementation BaseViewController

- (instancetype)initWithHidesBottomBar:(BOOL)hide
{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = hide;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout   = UIRectEdgeNone;
    [self setNavigationBarStyle];
}

- (void)setNavigationBarStyle
{
    self.navigationItem.titleView = [self setTitleView];
    self.navigationController.navigationBar.barStyle     = [self setStatuBar];
    self.navigationController.navigationBar.barTintColor = [self setBarTintColor];
    self.navigationController.navigationBar.tintColor    = [self setTintColor];
}

- (UIBarStyle)setStatuBar
{
    return UIBarStyleBlack;
}

- (UIColor *)setBarTintColor
{
    return MAIN_COLOR;
}

- (UIColor *)setTintColor
{
    return [UIColor whiteColor];
}

- (UIView *)setTitleView
{
    return nil;
}

/**
 *  设置标题
 */
- (void)setTitle:(NSString *)title
{
    if (self.needsCustomNavigationBar) {
        NSDictionary *dictionary = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(200, 27) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictionary context:nil];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width + 2, 27)];
        [label setText:title];
        [label setFont:[UIFont boldSystemFontOfSize:17]];
        [label setTextColor:[self setTintColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        self.navigationBar.titleView = label;
    }else {
        [super setTitle:title];
    }
}

- (void)setNeedsCustomNavigationBar:(BOOL)needsCustomNavigationBar
{
    _needsCustomNavigationBar = needsCustomNavigationBar;
    if (!needsCustomNavigationBar) return;
    
    XQNavigationBar *navigationBar = [[XQNavigationBar alloc] init];
    _navigationBar          = navigationBar;
    _navigationBar.delegate = self;
    _navigationBar.frame    = CGRectMake(0, 0, SCREEN_WIDTH, 64);
    [_navigationBar setBarTintColor:[self setBarTintColor]];
    [_navigationBar setTitleView:[self setTitleView]];
    [self.view addSubview:navigationBar];
}

- (void)goBackWithNavigationBar:(XQNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
