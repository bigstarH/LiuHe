//
//  NSString+Extension.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)realSize:(CGSize)maxSize font:(UIFont *)font
{
    CGRect rect = [self boundingRectWithSize:maxSize
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil];
    return rect.size;
}

@end
