//
//  PicLibraryTableView.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>
#import "PicLibraryTableView.h"
#import "PicLibraryCell.h"

@interface PicLibraryTableView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation PicLibraryTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createView];
    }
    return self;
}

- (void)createView
{
    self.rowHeight         = HEIGHT(44);
    UITableView *tableView = [[UITableView alloc] init];
    _tableView             = tableView;
    tableView.delegate     = self;
    tableView.dataSource   = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [self addSubview:tableView];
    
    __weak typeof(self) ws = self;
    tableView.mj_header    = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (ws.delegate && [ws.delegate respondsToSelector:@selector(picLTableView:refreshingDataWithMore:)]) {
            [ws.delegate picLTableView:ws refreshingDataWithMore:NO];
        }
    }];
    tableView.mj_footer    = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (ws.delegate && [ws.delegate respondsToSelector:@selector(picLTableView:refreshingDataWithMore:)]) {
            [ws.delegate picLTableView:ws refreshingDataWithMore:YES];
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

#pragma mark - start 公共方法
- (void)endRefreshing
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)setHideMJFooter:(BOOL)hide
{
    self.tableView.mj_footer.hidden = hide;
}

- (void)setHideMJHeader:(BOOL)hide
{
    self.tableView.mj_header.hidden = hide;
}
#pragma mark end 公共方法

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicLibraryCell *cell   = [PicLibraryCell picLibraryCell:tableView];
    PicLibraryModel *model = self.dataList[indexPath.row];
    [cell setCellData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PicLibraryModel *model = self.dataList[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(picLTableView:didSelectCellWithModel:)]) {
        [self.delegate picLTableView:self didSelectCellWithModel:model];
    }
}
#pragma mark end UITableViewDelegate, UITableViewDataSource
@end
