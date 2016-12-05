//
//  ForumReplyModel.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ForumReplyModel : NSObject
/** 回复者的昵称 */
@property (nonatomic, copy) NSString *hfusername;
/** 回复的时间戳 */
@property (nonatomic, copy) NSString *hfnewstime;
/** 回复内容 */
@property (nonatomic, copy) NSString *hftext;
/** 回复id */
@property (nonatomic, copy) NSString *hfid;

@property (nonatomic) CGFloat textHeight;

@property (nonatomic) CGFloat cellHeight;

+ (instancetype)forumReplyModelWithDict:(NSDictionary *)dict;
@end
