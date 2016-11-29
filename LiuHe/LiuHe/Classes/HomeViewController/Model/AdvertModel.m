//
//  AdvertModel.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "AdvertModel.h"

@implementation AdvertModel

+ (instancetype)advertModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setAttrWithDict:dict];
    }
    return self;
}

- (void)setAttrWithDict:(NSDictionary *)dict
{
    self.titlepic = dict[@"titlepic"];
    self.linkStr  = dict[@"title"];
}
@end
