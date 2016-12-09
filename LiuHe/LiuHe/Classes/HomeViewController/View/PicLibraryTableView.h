//
//  PicLibraryTableView.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLTableViewType) {
    PLTableViewTypeColours = 1001,  /**< 彩色图库 */
    PLTableViewTypeMystery = 1002,  /**< 玄机图库 */
    PLTableViewTypeBAW     = 1003,  /**< 黑白图库 */
    PLTableViewTypeYear    = 1004   /**< 全年图库 */
};

#define pageSize  20
#define starBegin 50

@class PicLibraryTableView;
@class PicLibraryModel;
@protocol PicLibraryTableViewDelegate <NSObject>

@optional
/**
 *  上拉刷新／下拉加载
 */
- (void)picLTableView:(PicLibraryTableView *)picLTableView refreshingDataWithMore:(BOOL)more;
/**
 *  点击了某一行
 */
- (void)picLTableView:(PicLibraryTableView *)picLTableView didSelectCellWithModel:(PicLibraryModel *)model;

@end

@interface PicLibraryTableView : UIView

/** 数据源 */
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, weak) id <PicLibraryTableViewDelegate> delegate;

@property (nonatomic, copy) NSString *classID;

@property (nonatomic) CGFloat rowHeight;
/** 分页 */
@property (nonatomic) NSInteger star;
/**
 *  停止刷新
 */
- (void)endRefreshing;
/**
 *  是否隐藏上拉刷新
 */
- (void)setHideMJFooter:(BOOL)hide;
/**
 *  是否隐藏下拉刷新
 */
- (void)setHideMJHeader:(BOOL)hide;
@end
