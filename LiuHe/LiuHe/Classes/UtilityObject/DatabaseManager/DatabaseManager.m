//
//  DatabaseManager.m
//  LiuHe
//
//  Created by huxingqin on 2017/1/3.
//  Copyright © 2017年 huxingqin. All rights reserved.
//

#import "DatabaseManager.h"
#import <FMDB/FMDB.h>
#import "UserModel.h"

static FMDatabaseQueue *_queue;

@implementation DatabaseManager

+ (void)databaseOfReadData
{
    if (_queue == nil) {
        // 连接数据库
        NSString *path      = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [path stringByAppendingPathComponent:DATABASE_NAME];
        _queue = [FMDatabaseQueue databaseQueueWithPath:plistPath];
    }
    // 创建表
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *table = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key autoincrement, sid text, uid text, datatype integer);", TABLE_NAME_READ_MARK];
        [db executeStatements:table];
    }];
}

+ (void)addReadDataWithSid:(NSString *)sid type:(NSInteger)type
{
    NSString *uid = [UserModel getCurrentUser].uid;
    NSString *str = [NSString stringWithFormat:@"insert into %@ (sid, uid, datatype) values (?, ?, ?);", TABLE_NAME_READ_MARK];
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:str, sid, uid ? uid : [NSNull null], @(type)];
        if (success) {
            NSDictionary *dict = @{@"sid" : sid};
            if (type == 1) {
                [NotificationCenter postNotificationName:ZILIAO_READ_SUCCESS object:nil userInfo:dict];
            }else if (type == 2) {
                [NotificationCenter postNotificationName:TUKU_READ_SUCCESS object:nil userInfo:dict];
            }else {
                [NotificationCenter postNotificationName:FORUM_READ_SUCCESS object:nil userInfo:dict];
            }
        }
    }];
}

+ (NSMutableArray *)readDataWithType:(NSInteger)type
{
    NSString *uid    = [UserModel getCurrentUser].uid;
    __block NSMutableArray *array = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = nil;
        if (uid) {
            NSString *str = [NSString stringWithFormat:@"select sid from %@ where datatype = ? and (uid is null or uid = ?);", TABLE_NAME_READ_MARK];
            rs = [db executeQuery:str, @(type), uid];
        }else {
            NSString *str = [NSString stringWithFormat:@"select sid from %@ where datatype = ? and uid is null;", TABLE_NAME_READ_MARK];
            rs = [db executeQuery:str, @(type)];
        }
        while (rs.next) {
            NSString *sid = [rs stringForColumn:@"sid"];
            [array addObject:sid];
        }
    }];
    return array;
}

+ (BOOL)eraseTable:(NSString *)tableName
{
    __block BOOL rs = YES;
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *str = [NSString stringWithFormat:@"delete from %@", tableName];
        rs = [db executeUpdate:str];
        if (rs) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"删除失败");
        }
    }];
    
    return rs;
}
@end
