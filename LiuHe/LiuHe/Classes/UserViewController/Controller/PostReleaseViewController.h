//
//  PostReleaseViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

typedef NS_ENUM(NSInteger, VCType) {
    VCTypePostNew  = 0, /**< 新发布帖子 */
    VCTypePostEdit = 1  /**< 编辑帖子 */
};

#import "BaseViewController.h"

/** 发表帖子 */
@interface PostReleaseViewController : BaseViewController

@property (nonatomic) VCType type;
/** 状态： 0: 为未审核， 1: 为已审核 */
@property (nonatomic) NSInteger status;
/** 帖子ID */
@property (nonatomic, copy) NSString *sid;

@end
