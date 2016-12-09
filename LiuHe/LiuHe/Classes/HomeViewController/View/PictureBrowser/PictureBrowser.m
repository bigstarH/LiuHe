//
//  PictureBrowser.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/7.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "PictureBrowser.h"
#import "PicBrowserCell.h"

@interface PictureBrowser () <PicBrowserCellDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation PictureBrowser

+ (instancetype)pictureBrowser:(NSArray *)imageUrls
{
    return [[self alloc] initWithFrame:[UIScreen mainScreen].bounds imageUrls:imageUrls];
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls
{
    if (self = [super initWithFrame:frame]) {
        _imageUrls = imageUrls;
        [self createView];
    }
    return self;
}

- (void)dealloc
{
    self.imageUrls = nil;
    NSLog(@"PictureBrowser dealloc");
}

- (void)createView
{
    self.backgroundColor = [UIColor blackColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing          = 0;
    layout.itemSize                    = self.bounds.size;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView  = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.backgroundColor    = [UIColor clearColor];
    collectionView.dataSource         = self;
    collectionView.delegate           = self;
    collectionView.pagingEnabled      = YES;
    self.collectionView               = collectionView;
    // 注册cell
    [collectionView registerClass:[PicBrowserCell class] forCellWithReuseIdentifier:PicBrowserCellID];
    [self addSubview:collectionView];
}

- (void)setImageUrls:(NSArray *)imageUrls
{
    _imageUrls = imageUrls;
    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    [_collectionView setContentOffset:CGPointMake(currentIndex * self.bounds.size.width, 0)];
}

- (void)hideCollectionView:(BOOL)isHidden
{
    self.collectionView.hidden = isHidden;
}

#pragma mark - start UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imageUrls count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicBrowserCell *cell = (PicBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PicBrowserCellID forIndexPath:indexPath];
    cell.delegate        = self;
    [cell setCellData:self.imageUrls[indexPath.item] index:indexPath.item];
    return cell;
}
#pragma mark end UICollectionViewDelegate, UICollectionViewDataSource

#pragma mark - start PicBrowserCellDelegate
- (void)picBrowserCell:(PicBrowserCell *)cell didClickWithIndex:(NSInteger)index
{
    NSString *url        = self.imageUrls[index];
    CGRect beginFrame    = [cell convertImageViewFrameToMainScreen];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:beginFrame];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [KeyWindow addSubview:imageView];
    [self.collectionView setHidden:YES];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.alpha      = 0.0;
                         imageView.frame = self.originFrame;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                         [imageView removeFromSuperview];
                         if (self.delegate && [self.delegate respondsToSelector:@selector(pictureBrowser:didClickItemAtIndex:)]) {
                             [self.delegate pictureBrowser:self didClickItemAtIndex:index];
                         }
                     }];
}
#pragma mark end PicBrowserCellDelegate
@end
