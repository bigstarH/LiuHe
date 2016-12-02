//
//  HistoryCell.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/30.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryNumberModel.h"

@interface HistoryCell : UITableViewCell

+ (instancetype)historyCell:(UITableView *)tableView;

- (void)setCellData:(LotteryNumberModel *)model;

@end
