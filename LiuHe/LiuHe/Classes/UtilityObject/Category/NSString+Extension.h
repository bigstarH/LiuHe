//
//  NSString+Extension.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  计算字符串的真正尺寸
 *  @parameter  :  maxSize 最大尺寸
 *  @parameter  :  font    字体
 */
- (CGSize)realSize:(CGSize)maxSize font:(UIFont *)font;

@end
