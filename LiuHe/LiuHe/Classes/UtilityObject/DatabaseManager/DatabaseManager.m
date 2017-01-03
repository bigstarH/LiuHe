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
        NSString *table = [NSString stringWithFormat:@"create table if not exists %@ (sid text primary key, uid text, datatype integer);", TABLE_NAME_READ_MARK];
        if ([db executeStatements:table]) {
            NSLog(@"创表成功");
        }else {
            NSLog(@"创表失败");
        }
    }];
}

+ (void)addReadDataWithSid:(NSString *)sid type:(NSInteger)type
{
    NSString *uid = [UserModel getCurrentUser].uid;
    NSString *str = [NSString stringWithFormat:@"insert into %@ (sid, uid, datatype) values (?, ?, ?)", TABLE_NAME_READ_MARK];
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL success = [db executeUpdate:str, sid, uid ? uid : [NSNull null], @(type)];
        if (success) {
            NSLog(@"插入成功");
        }else {
            NSLog(@"插入失败");
        }
    }];
}

+ (NSArray *)readDataWithType:(NSInteger)type
{
    NSString *uid    = [UserModel getCurrentUser].uid;
    NSString *str    = [NSString stringWithFormat:@"select sid from %@ where datatype = ? and (uid = ? or uid = ?)", TABLE_NAME_READ_MARK];
    __block NSMutableArray *array = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:str, @(type), uid ? uid : [NSNull null], [NSNull null]];
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
