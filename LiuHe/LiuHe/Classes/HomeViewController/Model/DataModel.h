//
//  DataModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 资料模型 */
@interface DataModel : NSObject

@property (nonatomic, copy) NSString *newstime;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *dateStr;
/** 是否已读 */
@property (nonatomic) NSInteger isRead;

@property (nonatomic) CGFloat height;

+ (instancetype)dataWithDict:(NSDictionary *)dict;

@end
