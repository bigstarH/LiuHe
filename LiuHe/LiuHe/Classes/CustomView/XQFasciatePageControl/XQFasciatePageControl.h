//
//  XQFasciatePageControl.h
//  Example
//
//  Created by 胡兴钦 on 2016/11/18.
//  Copyright © 2016年 ufuns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XQFasciatePageControl : UIControl
/** 总个数(页数) */
@property (nonatomic) NSInteger numberOfPages;
/** 未被选中的page的大小 */
@property (nonatomic) CGSize sizeForPages;
/** 当前页颜色 */
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor;
/** 其他页颜色 */
@property (nonatomic, strong) UIColor *pageIndicatorTintColor;
/** 当前页(默认从第0页开始) */
@property (nonatomic) NSInteger currentPage;

+ (instancetype)pageControl;

+ (instancetype)pageControlWithFrame:(CGRect)frame;

@end
