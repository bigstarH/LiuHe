//
//  DataDetailViewController.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "BaseViewController.h"

@class DataModel;
/** 资料详情 */
@interface DataDetailViewController : BaseViewController

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *classID;

@property (nonatomic) BOOL needCollectedBtn;

@end
