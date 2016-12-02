//
//  ColumnView.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColumnView;
@protocol ColumnViewDelegate <NSObject>
/**
 *  点击了某一项
 */
- (void)columnView:(ColumnView *)columnView didSelectedAtItem:(NSInteger)item;

@end

@interface ColumnView : UIView
/** 数据源 */
@property (nonatomic, strong) NSArray *items;
/** 每个栏目标签的宽度 */
@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, weak) id <ColumnViewDelegate> delegate;

- (void)scrollToCurrentIndex:(NSInteger)currentIndex;

@end
