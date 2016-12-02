//
//  DataCell.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"

/** 资料cell */
@interface DataCell : UITableViewCell

+ (instancetype)dataCell:(UITableView *)tableView;

- (void)setCellData:(DataModel *)model;

@end
