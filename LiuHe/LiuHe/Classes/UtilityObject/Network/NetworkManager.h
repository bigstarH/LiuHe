//
//  NetworkManager.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype)shareManager;

#pragma mark - start 网络请求
/**
 *  获取首页广告图
 */
- (void)getHomeADWithSuccess:(void (^)(NSArray *imagesArray))successBlock
                     failure:(void (^)(NSString *error))failureBlock;
#pragma mark end 网络请求

@end
