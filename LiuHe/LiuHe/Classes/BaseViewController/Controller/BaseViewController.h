//
//  BaseViewController.h
//  Text
//
//  Created by huxingqin on 2016/11/21.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XQNavigationBar.h"

@interface BaseViewController : UIViewController

@property (nonatomic, weak, readonly) XQNavigationBar *navigationBar;

@property (nonatomic) BOOL needsCustomNavigationBar;

- (UIBarStyle)setStatuBar;

- (UIColor *)setBarTintColor;

- (UIColor *)setTintColor;

- (UILabel *)setTitleView;

- (BOOL)setBarTranslucent;

@end
