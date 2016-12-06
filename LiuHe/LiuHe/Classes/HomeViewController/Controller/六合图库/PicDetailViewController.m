//
//  PicDetailViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/3.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "PicDetailViewController.h"
#import "PicLibraryModel.h"
#import "NetworkManager.h"
#import "PictureCell.h"
#import "ColumnView.h"
#import "XQToast.h"

@interface PicDetailViewController () <UIScrollViewDelegate, ColumnViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) ColumnView *columnView;

@property (nonatomic, weak) UIView *maskView;

@property (nonatomic, weak) UIImageView *imageView;
/** imageView原来的位置尺寸 */
@property (nonatomic) CGRect originFrame;

@property (nonatomic, weak) UIImageView *bigImageView;

@end

@implementation PicDetailViewController

- (void)dealloc
{
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建栏目栏
    [self createColumnView];
    
    // 创建CollectionView
    [self createCollectionView];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = _model.title;
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *collect = [[XQBarButtonItem alloc] initWithTitle:@"收藏"];
    [collect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collect setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [collect addTarget:self action:@selector(collectEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = collect;
    self.navigationBar.leftBarButtonItem  = leftItem;
}

/** 按钮收藏事件 */
- (void)collectEvent
{
    [SVProgressHUD show];
    [[NetworkManager shareManager] collectingWithClassID:self.classID
                                                      ID:_model.sid
                                                 success:^(NSString *string) {
                                                     [SVProgressHUD dismiss];
                                                     [[XQToast makeText:string] show];
                                                 } failure:^(NSString *error) {
                                                     [SVProgressHUD showErrorWithStatus:error];
                                                 }];
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
/** 创建栏目栏 */
- (void)createColumnView
{
//    NSMutableArray *list  = [NSMutableArray array];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = _model.qishu.intValue; i > 0 ; i--) {
        NSString *str = [NSString stringWithFormat:@"第%d期", i];
        [array addObject:str];
//        [list addObject:@(i)];
    }
    ColumnView *columnView = [[ColumnView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(35))];
    self.columnView        = columnView;
    columnView.itemWidth   = SCREEN_WIDTH * 0.23;
    columnView.delegate    = self;
    columnView.items       = array;
    [columnView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [self.view addSubview:columnView];
    
    self.dataList = array;
}

/** 创建CollectionView */
- (void)createCollectionView
{
    CGFloat originY = CGRectGetMaxY(self.columnView.frame);
    
    CGFloat height  = SCREEN_HEIGHT - originY;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing          = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:CGRectMake(0, originY, SCREEN_WIDTH, height) collectionViewLayout:layout];
    self.collectionView       = collectionView;
    collectionView.delegate   = self;
    collectionView.dataSource = self;
    [collectionView setPagingEnabled:YES];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView registerClass:[PictureCell class] forCellWithReuseIdentifier:@"CELLID"];
    [self.view addSubview:collectionView];
}
#pragma mark end 初始化控件

#pragma mark - start 手势事件
/** 移除大图，恢复原图 */
- (void)removeBigPic:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = (UIScrollView *)tap.view;
    
    CGRect frame = [self.view convertRect:self.originFrame toView:scrollView];
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha     = 0.0;
        self.bigImageView.frame = frame;
    } completion:^(BOOL finished) {
        self.imageView.hidden = NO;
        [self.maskView removeFromSuperview];
        [self.bigImageView removeFromSuperview];
        [scrollView removeFromSuperview];
    }];
}
#pragma mark end 手势事件

#pragma mark - start ColumnViewDelegate
- (void)columnView:(ColumnView *)columnView didSelectedAtItem:(NSInteger)item
{
    NSLog(@"item = %zd", item);
}
#pragma mark end ColumnViewDelegate

#pragma mark - start UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH, collectionView.bounds.size.height);
}
#pragma mark end UICollectionViewDelegateFlowLayout

#pragma mark - start UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureCell *cell = (PictureCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CELLID" forIndexPath:indexPath];
    NSInteger index = self.model.qishu.integerValue - indexPath.item;
    NSString *url   = [NSString stringWithFormat:@"%@%zd/%@.jpg", _model.url, index, _model.type];
    [cell setImageWithUrl:url];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark end UICollectionViewDelegate, UICollectionViewDataSource

#pragma mark - start UIScrollViewDelegate
/** 实现图片的缩放 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImageView;
}

/** 实现图片在缩放过程中居中 */
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?(scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _bigImageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}
#pragma mark end UIScrollViewDelegate
@end
