//
//  ReplyModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReplyModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *classid;

@property (nonatomic, copy) NSString *linkStr;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *tid;

+ (instancetype)replyModelWithDict:(NSDictionary *)dict;

@end
