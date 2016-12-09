//
//  XQTextView.h
//  LiuHe
//
//  Created by 胡兴钦 on 2016/11/26.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQTextView : UIView

@property (nonatomic, weak, readonly) UITextView *textView;

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic) UITextAutocapitalizationType autocapitalizationType;

@property (nonatomic, weak) id <UITextViewDelegate> delegate;

@end
