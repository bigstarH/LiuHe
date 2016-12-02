//
//  PicLibraryCell.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicLibraryModel.h"

@interface PicLibraryCell : UITableViewCell

+ (instancetype)picLibraryCell:(UITableView *)tableView;

- (void)setCellData:(PicLibraryModel *)model;

@end
