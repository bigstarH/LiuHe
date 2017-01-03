//
//  Common.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#ifndef Common_h
#define Common_h

// NSUserDefaults 键值
#define CURRENT_BQ                @"CURRENT_BQ"           // 当前期数
#define LOTTERY_SILENCE           @"LOTTERY_SILENCE"      // 摇奖静音
#define USER_DIDLOGIN             @"USER_DIDLOGIN"        // 用户是否登录
#define APP_QRCODE                @"APP_QRCODE"           // 二维码图片
#define APP_UPDATE_CONTENT        @"APP_UPDATE_CONTENT"   // ios更新内容
#define APP_FILE_SIZE             @"APP_FILE_SIZE"        // 文件大小
#define APP_MORE_APPLICATION      @"APP_MORE_APPLICATION" // 更多应用
#define APP_NEW_VERSION           @"APP_NEW_VERSION"      // 最新版本
#define APP_DOWNLOAD_URL          @"APP_DOWNLOAD_URL"     // 下载链接
#define APP_SHARE_TEXT            @"APP_SHARE_TEXT"       // 分享文本
#define APP_SHARE_LINK            @"APP_SHARE_LINK"       // 分享链接

// 通知名
#define USER_LOGIN_SUCCESS        @"USER_LOGIN_SUCCESS"        // 用户登录成功
#define USER_LOGOUT_SUCCESS       @"USER_LOGOUT_SUCCESS"       // 用户注销成功
#define USER_REGISTER_SUCCESS     @"USER_REGISTER_SUCCESS"     // 用户注册成功
#define USER_MODIFY_SUCCESS       @"USER_MODIFY_SUCCESS"       // 用户修改信息成功
#define USER_MODIFYPSW_SUCCESS    @"USER_MODIFYPSW_SUCCESS"    // 用户修改密码成功
#define POST_EDIT_SUCCESS         @"POST_EDIT_SUCCESS"         // 编辑帖子成功
#define FORUM_REPLY_EDIT_SUCCESS  @"FORUM_REPLY_EDIT_SUCCESS"  // 编辑回复成功
#define LOTTERY_KJ_FINISHED       @"LOTTERY_KJ_FINISHED"       // 开奖成功结束
#define SHARE_MESSAGE_SUCCESS     @"SHARE_MESSAGE_SUCCESS"     // 分享成功

// 数据库
#define DATABASE_NAME             @"database.db"     // 数据库名
#define TABLE_NAME_READ_MARK      @"read_mark_table" // 表名称
#define DATATYPE_ZILIAO  1
#define DATATYPE_TUKU    2
#define DATATYPE_FORUM   3

#endif /* Common_h */
