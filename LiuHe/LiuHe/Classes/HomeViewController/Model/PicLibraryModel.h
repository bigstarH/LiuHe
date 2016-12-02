//
//  PicLibraryModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicLibraryModel : NSObject
/** 时间戳 */
@property (nonatomic, copy) NSString *newstime;
/** 文章id */
@property (nonatomic, copy) NSString *sid;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 序号 */
@property (nonatomic, copy) NSString *type;
/** 图片链接 */
@property (nonatomic, copy) NSString *url;
/** 期数 */
@property (nonatomic, copy) NSString *qishu;
/** 时间 */
@property (nonatomic, copy) NSString *dateString;
/** 图片地址 */
@property (nonatomic, copy) NSString *urlString;
/** 序号 + 标题 */
@property (nonatomic, copy) NSString *text;

+ (instancetype)picLibraryWithDict:(NSDictionary *)dict;

@end
