//
//  PostModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 我的帖子 */
@interface PostModel : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *classid;
/** 链接 */
@property (nonatomic, copy) NSString *linkStr;

@property (nonatomic, copy) NSString *sid;

+ (instancetype)postModelWithDict:(NSDictionary *)dict;

@end
