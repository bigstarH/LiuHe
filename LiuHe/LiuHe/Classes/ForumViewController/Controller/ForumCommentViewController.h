//
//  ForumCommentViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"


typedef NS_ENUM(NSInteger, FCVCType) {
    FCVCTypeNew  = 0, /**< 新发布 */
    FCVCTypeEdit = 1  /**< 修改 */
};

@interface ForumCommentViewController : BaseViewController

@property (nonatomic, copy) NSString *mSid;

@property (nonatomic, copy) NSString *mTitle;

@property (nonatomic) FCVCType type;

@property (nonatomic) NSInteger status;

@end
