//
//  ForumModel.h
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/4.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 论坛帖子模型 */
@interface ForumModel : NSObject

/** 回答数量 */
@property (nonatomic, strong) NSNumber *rnum;

@property (nonatomic, strong) NSArray *hf;
/** 内容 */
@property (nonatomic, copy) NSString *newstext;

@property (nonatomic, copy) NSString *groupname;
/** 时间戳 */
@property (nonatomic, copy) NSString *newstime;
/** 阅读人数 */
@property (nonatomic, copy) NSString *onclick;
/** 帖子ID */
@property (nonatomic, copy) NSString *sid;
/** 帖子标题 */
@property (nonatomic, copy) NSString *title;
/** 用户分数 */
@property (nonatomic, copy) NSString *userfen;
/** 用户名 */
@property (nonatomic, copy) NSString *username;
/** 用户图片 */
@property (nonatomic, copy) NSString *userpic;
/** 日期 */
@property (nonatomic, copy) NSString *dateString;
/** 用户名的宽度 */
@property (nonatomic) CGFloat userNameWidth;

@property (nonatomic) CGFloat groupNameWidth;

@property (nonatomic) CGFloat replyWith;

+ (instancetype)forumModelWithDict:(NSDictionary *)dict;

@end
