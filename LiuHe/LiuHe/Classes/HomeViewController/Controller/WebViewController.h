//
//  WebViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

/** 网页视图控制器 */
@interface WebViewController : BaseViewController
/** 标题 */
@property (nonatomic, copy) NSString *mTitle;
/** url */
@property (nonatomic, copy) NSString *requestUrl;

@end
