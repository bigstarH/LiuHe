//
//  ColumnView.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/2.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ColumnView.h"

static NSString *cellID = @"cellID";

@interface ColumnView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
/** 当前选中的下标 */
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation ColumnView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setDefautValue];
        [self createView];
    }
    return self;
}

- (void)setDefautValue
{
    _currentIndex = 0;
    _itemWidth    = WIDTH(70);
}

- (void)createView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing          = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView       = collectionView;
    collectionView.delegate   = self;
    collectionView.dataSource = self;
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    [self addSubview:collectionView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.collectionView.frame, CGRectZero)) return;
    
    _collectionView.frame = self.bounds;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    self.collectionView.backgroundColor = backgroundColor;
}

- (void)scrollToCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated
{
    if (currentIndex > _currentIndex) {  // 向右滑动
        CGFloat curMaxX = _collectionView.contentOffset.x + self.bounds.size.width;
        CGFloat maxX    = (currentIndex + 1) * _itemWidth;
        if (maxX >= curMaxX) {
            CGFloat offsetX = _collectionView.contentOffset.x + maxX - curMaxX;
            if (currentIndex != _items.count - 1) {
                offsetX     = offsetX + _itemWidth;
            }
            [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
        }
    }else {  // 向左滑动
        CGFloat curMinX = _collectionView.contentOffset.x;
        CGFloat minX    = currentIndex * _itemWidth;
        if (minX <= curMinX) {
            CGFloat offsetX = _collectionView.contentOffset.x + minX - curMinX;
            if (currentIndex != 0) {
                offsetX     = offsetX - _itemWidth;
            }
            [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
        }
    }
    _currentIndex = currentIndex;
    [_collectionView reloadData];
}

#pragma mark - start UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:101];
    if (!label) {
        CGFloat labelW = _itemWidth - WIDTH(14);
        CGFloat labelX = WIDTH(7);
        CGFloat labelH = HEIGHT(22);
        CGFloat labelY = (collectionView.bounds.size.height - labelH) * 0.5;
        label      = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.font = [UIFont systemFontOfSize:fontSize(13)];
        label.tag  = 101;
        [label setTextAlignment:NSTextAlignmentCenter];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:labelH * 0.5];
        [cell.contentView addSubview:label];
    }
    label.text = self.items[indexPath.item];
    if (indexPath.item == _currentIndex) {
        label.backgroundColor = MAIN_COLOR;
        label.textColor       = [UIColor whiteColor];
    }else {
        label.backgroundColor = [UIColor clearColor];
        label.textColor       = MAIN_COLOR;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_currentIndex == indexPath.item) return;
    [self scrollToCurrentIndex:indexPath.item animated:NO];
    if (self.delegate) {
        [self.delegate columnView:self didSelectedAtItem:indexPath.item];
    }
}
#pragma mark end UICollectionViewDataSource, UICollectionViewDelegate

#pragma mark - start UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_itemWidth, self.bounds.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
#pragma mark end UICollectionViewDelegateFlowLayout
@end
