//
//  PicBrowserCell.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/7.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PicBrowserCellID @"PicBrowserCell"

@class PicBrowserCell;
@protocol PicBrowserCellDelegate <NSObject>

@optional
- (void)picBrowserCell:(PicBrowserCell *)cell didClickWithIndex:(NSInteger)index;

@end

@interface PicBrowserCell : UICollectionViewCell

@property (nonatomic, weak) id <PicBrowserCellDelegate> delegate;

- (void)setCellData:(NSString *)imageUrlStr index:(NSInteger)index;

- (CGRect)convertImageViewFrameToMainScreen;

@end
