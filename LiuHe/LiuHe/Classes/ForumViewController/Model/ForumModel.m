//
//  ForumModel.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/4.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ForumModel.h"
#import "ForumReplyModel.h"

@implementation ForumModel

+ (instancetype)forumModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        [self addForumModel];
    }
    return self;
}

- (void)addForumModel
{
    NSMutableArray *array = [NSMutableArray array];
    if (self.hf && self.hf.count > 0) {
        for (int i = 0; i < self.hf.count; i++) {
            NSDictionary *dict = self.hf[i];
            ForumReplyModel *model = [ForumReplyModel forumReplyModelWithDict:dict];
            [array addObject:model];
        }
    }
    self.hf = array;
}

@end
