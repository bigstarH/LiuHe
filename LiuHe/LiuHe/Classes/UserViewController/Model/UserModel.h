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
/** 邮箱 */
@property (nonatomic, copy) NSString *email;
/** 手机号码 */
@property (nonatomic, copy) NSString *phone;
/** QQ */
@property (nonatomic, copy) NSString *QQ;
/** 真实姓名 */
@property (nonatomic, copy) NSString *trueName;
/** 微信号 */
@property (nonatomic, copy) NSString *weChat;

+ (instancetype)userModelWithDict:(NSDictionary *)dict;

- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  获取当前的用户 
 */
+ (instancetype)getCurrentUser;

/**
 *  在登录成功后，将用户信息保存到本地
 */
- (void)saveUserInfoWhenLogin;

/**
 *  在成功获取“我的资料”后，将我的信息保存到本地
 */
- (void)saveUserInfoWithMyData;

/**
 *  移除用户信息
 */
+ (void)removeCurrentUser;

@end
