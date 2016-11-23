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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout   = UIRectEdgeNone;
    self.navigationItem.titleView = [self setTitleView];
    self.navigationController.navigationBar.barStyle     = [self setStatuBar];
    self.navigationController.navigationBar.barTintColor = [self setBarTintColor];
    self.navigationController.navigationBar.tintColor    = [self setTintColor];
    self.navigationController.navigationBar.translucent  = [self setBarTranslucent];
    self.navigationBar.delegate = self;
}

- (UIBarStyle)setStatuBar
{
    return UIBarStyleBlack;
}

- (UIColor *)setBarTintColor
{
    return [UIColor whiteColor];
}

- (UIColor *)setTintColor
{
    return [UIColor whiteColor];
}

- (UILabel *)setTitleView
{
    return nil;
}

- (BOOL)setBarTranslucent
{
    return NO;
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
    _navigationBar = navigationBar;
    _navigationBar.frame = CGRectMake(0, 0, self.view.bounds.size.width, 64);
    [_navigationBar setBarTintColor:[self setBarTintColor]];
    [self.view addSubview:navigationBar];
}

@end
