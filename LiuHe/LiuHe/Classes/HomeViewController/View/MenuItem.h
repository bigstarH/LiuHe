//
//  MenuItem.h
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MenuItemHighlightedType) {
    MenuItemHighlightedTypeDefault       = 0,
    MenuItemHighlightedTypeWhiteAndFront = 1
};

@interface MenuItem : UIView

@property (nonatomic, weak, readonly) UIImageView *imageView;

@property (nonatomic, weak, readonly) UILabel *label;

@property (nonatomic, readonly) CGSize titleSize;

@property (nonatomic) MenuItemHighlightedType highlightedType;

- (void)setMenuTitle:(NSString *)title font:(UIFont *)font;

- (void)setMenuImage:(UIImage *)image;

- (void)setMenuClickBlock:(void (^)(NSInteger tag))block;

@end
