//
//  CollectionModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 我的收藏 */
@interface CollectionModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *classid;

@property (nonatomic, copy) NSString *linkStr;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *tid;

+ (instancetype)collectionModelWithDict:(NSDictionary *)dict;

@end
