//
//  XQAlertView.h
//  Example
//
//  Created by NB-022 on 16/8/25.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XQAlertButtonStyle) {
    XQAlertButtonStyleCancel      = 0,
    XQAlertButtonStyleDestructive = 1,
    XQAlertButtonStyleDefault     = 2,
};

@interface XQAlertView : UIView

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *themeColor;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title style:(XQAlertButtonStyle)style handle:(void (^)())handle;

- (void)addTextFieldWithPlaceholder:(NSString *)placeholder handle:(void (^)(UITextField *textField))handle;

- (void)show;

@end
