//
//  ForumModel.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/4.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ForumModel.h"

@implementation ForumModel

+ (instancetype)forumModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end
