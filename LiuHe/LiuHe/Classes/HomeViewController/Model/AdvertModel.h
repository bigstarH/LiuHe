//
//  AdvertModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 广告模型 */
@interface AdvertModel : NSObject

@property (nonatomic, copy) NSString *linkStr;

@property (nonatomic, copy) NSString *titlepic;

+ (instancetype)advertModelWithDict:(NSDictionary *)dict;

@end
