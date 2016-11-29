//
//  CollectionWebViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

/** 收藏, 回复链接 */
@interface CollectionWebViewController : BaseViewController

@property (nonatomic, copy) NSString *titleStr;

- (instancetype)initWithLinkStr:(NSString *)linkStr;

@end
