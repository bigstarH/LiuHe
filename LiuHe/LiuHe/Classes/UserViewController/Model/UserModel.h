//
//  UserModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/24.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
/** 用户名 */
@property (nonatomic, copy) NSString *userName;
/** 密码 */
@property (nonatomic, copy) NSString *password;
/** 等级 */
@property (nonatomic, copy) NSString *rank;
/** uid */
@property (nonatomic, copy) NSString *uid;
/** 积分 */
@property (nonatomic, copy) NSString *integral;
/** 头像 */
@property (nonatomic, copy) NSString *headUrlStr;
/** 随机码 */
@property (nonatomic, copy) NSString *rnd;

+ (instancetype)userModelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  获取当前的用户 
 */
+ (instancetype)getCurrentUser;

/**
 *  将用户信息保存到本地
 */
- (void)saveUserInfo;

/**
 *  移除用户信息
 */
+ (void)removeCurrentUser;

@end
