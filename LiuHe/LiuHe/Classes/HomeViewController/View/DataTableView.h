//
//  DataTableView.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TableViewType) {
    TableViewTypeFavor    = 1001,  /**< 心水资料 */
    TableViewTypeText     = 1002,  /**< 文字资料 */
    TableViewTypeSuper    = 1003,  /**< 高手资料 */
    TableViewTypeFx       = 1004,  /**< 公式资料 */
    TableViewTypeBoutique = 1005,  /**< 精品杀项 */
    TableViewTypeCard     = 1006,  /**< 香港挂牌 */
    TableViewTypeYear     = 1007   /**< 全年资料 */
};

#define pageSize 20

@class DataTableView;
@class DataModel;
@protocol DataTableViewDelegate <NSObject>

@optional
/** 
 *  上拉刷新／下拉加载
 */
- (void)dataTableView:(DataTableView *)dataTableView refreshingDataWithMore:(BOOL)more;
/**
 *  点击了某一行
 */
- (void)dataTableView:(DataTableView *)dataTableView didSelectCellWithModel:(DataModel *)model;

@end

@interface DataTableView : UIView
/** 数据源 */
@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, weak, readonly) UITableView *tableView;

@property (nonatomic, weak) id <DataTableViewDelegate> delegate;

@property (nonatomic, copy) NSString *classID;
/** 分页 */
@property (nonatomic) NSInteger star;
/**
 *  开始刷新
 */
- (void)beginRefreshing;
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
