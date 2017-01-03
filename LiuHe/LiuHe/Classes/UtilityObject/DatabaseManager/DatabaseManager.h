//
//  DatabaseManager.h
//  LiuHe
//
//  Created by huxingqin on 2017/1/3.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 数据库管理 */
@interface DatabaseManager : NSObject
/**
 *  连接打开已读数据库，创建数据表
 */
+ (void)databaseOfReadData;
/**
 *  添加已读数据
 *  @parameter : sid   已读文章ID
 *  @parameter : type  文章类型
 */
+ (void)addReadDataWithSid:(NSString *)sid
                      type:(NSInteger)type;
/**
 *  读取已读数据
 *  @parameter : type  文章类型
 */
+ (NSArray *)readDataWithType:(NSInteger)type;
/**
 *  清除表数据
 *  @parameter : tableName  表名
 *  @return    : 是否成功清除
 */
+ (BOOL)eraseTable:(NSString *)tableName;
@end
