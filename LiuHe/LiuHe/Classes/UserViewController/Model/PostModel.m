//
//  PostModel.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "PostModel.h"

@implementation PostModel

+ (instancetype)postModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self attrForDictionary:dict];
    }
    return self;
}

- (void)attrForDictionary:(NSDictionary *)dict
{
    self.title   = dict[@"bt"] ? dict[@"bt"] : @"";
    self.classid = dict[@"classid"] ? dict[@"classid"] : @"";
    self.linkStr = dict[@"lj"] ? dict[@"lj"] : @"";
    self.sid     = dict[@"sid"] ? dict[@"sid"] : @"";
}

@end
