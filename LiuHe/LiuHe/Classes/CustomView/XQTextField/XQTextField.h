//
//  XQTextField.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQTextField : UIView

@property (nonatomic, weak, readonly) UITextField *textField;
/** 文字对其方式 */
@property (nonatomic) NSTextAlignment textAlignment;
/** 左视图模式 */
@property (nonatomic) UITextFieldViewMode leftViewMode;
/** 右视图模式 */
@property (nonatomic) UITextFieldViewMode rightViewMode;
/** 边框样式 */
@property (nonatomic) UITextBorderStyle borderStyle;
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 文字 */
@property (nonatomic, copy) NSString *text;
/** 文字颜色 */
@property (nonatomic, strong) UIColor *textColor;
/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 字体 */
@property (nonatomic, strong) UIFont *font;
/** 左边图片 */
@property (nonatomic, strong) UIImage *leftImage;
/** 右边图片 */
@property (nonatomic, strong) UIImage *rightImage;
/** 左视图 */
@property (nonatomic, weak) UIView *leftView;
/** 右视图 */
@property (nonatomic, weak) UIView *rightView;
/** 密文模式 */
@property (nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
/** returnKey */
@property (nonatomic) UIReturnKeyType returnKeyType;
/** 键盘样式 */
@property (nonatomic) UIKeyboardType keyboardType;

@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;
/** 代理 */
@property (nonatomic, weak) id <UITextFieldDelegate> delegate;

@end
