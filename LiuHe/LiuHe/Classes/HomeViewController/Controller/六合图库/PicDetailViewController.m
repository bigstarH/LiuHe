//
//  PicDetailViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/3.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIImageView+WebCache.h>
#import "PicDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "PicLibraryModel.h"
#import "PictureBrowser.h"
#import "NetworkManager.h"
#import "PictureCell.h"
#import "ColumnView.h"
#import "XQToast.h"

@interface PicDetailViewController () <ColumnViewDelegate, PictureCellDelegate, PictureBrowserDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, weak) ColumnView *columnView;

@property (nonatomic, weak) PictureBrowser *browser;

@property (nonatomic, weak) UIImageView *bigImageView;

@property (nonatomic) NSInteger currentIndex;

@end

@implementation PicDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex         = 0;
    
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
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    [[NetworkManager shareManager] collectingWithClassID:self.classID
                                                      ID:_model.sid
                                                 success:^(NSString *string) {
                                                     [hud hideAnimated:YES];
                                                     [[XQToast makeText:string] show];
                                                 } failure:^(NSString *error) {
                                                     [hud hideAnimated:YES];
                                                     [MBProgressHUD showFailureInView:self.view mesg:error];
                                                 }];
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
/** 创建栏目栏 */
- (void)createColumnView
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *list  = [NSMutableArray array];
    if (self.isYearLibrary) {
        [array addObject:_model.urlString];
        [list addObject:_model.urlString];
    }else {
        for (int i = _model.qishu.intValue; i > 0 ; i--) {
            NSString *str = [NSString stringWithFormat:@"第%d期", i];
            NSString *url = [NSString stringWithFormat:@"%@%03d/%@.jpg", _model.url, i, _model.type];
            [array addObject:str];
            [list addObject:url];
        }
        ColumnView *columnView = [[ColumnView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(35))];
        self.columnView        = columnView;
        columnView.itemWidth   = SCREEN_WIDTH * 0.23;
        columnView.delegate    = self;
        columnView.items       = array;
        [columnView setBackgroundColor:RGBCOLOR(245, 245, 245)];
        [self.view addSubview:columnView];
    }
    self.dataList = list;
}

/** 创建CollectionView */
- (void)createCollectionView
{
    CGFloat originY = self.isYearLibrary ? 65 : CGRectGetMaxY(self.columnView.frame);
    
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

#pragma mark - start 懒加载
- (PictureBrowser *)browser
{
    if (!_browser) {
        PictureBrowser *browser = [PictureBrowser pictureBrowser:self.dataList];
        _browser         = browser;
        browser.delegate = self;
        [self.view addSubview:browser];
    }
    return _browser;
}
#pragma mark end 懒加载

#pragma mark - start ColumnViewDelegate
- (void)columnView:(ColumnView *)columnView didSelectedAtItem:(NSInteger)item
{
    self.currentIndex = item;
    CGFloat offsetX   = item * _collectionView.bounds.size.width;
    [_collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}
#pragma mark end ColumnViewDelegate

#pragma mark - start PictureBrowserDelegate
/** 点击了浏览器的第index张图片 */
- (void)pictureBrowser:(PictureBrowser *)browser didClickItemAtIndex:(NSInteger)index
{
    self.bigImageView.hidden = NO;
    [self columnView:self.columnView didSelectedAtItem:index];
    [self.columnView scrollToCurrentIndex:self.currentIndex animated:NO];
}
#pragma mark end PictureBrowserDelegate

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
    cell.delegate     = self;
    NSString *url     = self.dataList[indexPath.item];
    [cell setImageWithUrl:url];
    return cell;
}

/** 点击了图片 */
- (void)pictureCell:(PictureCell *)cell didClickWithImageView:(UIImageView *)imageView originFrame:(CGRect)originFrame
{
    self.bigImageView = imageView;
    CGRect frame  = [cell.contentView convertRect:originFrame toView:self.browser];
    [self.browser hideCollectionView:YES];
    
    NSString *url = self.dataList[self.currentIndex];
    UIImageView *tempImgV = [[UIImageView alloc] initWithFrame:frame];
    [tempImgV setContentMode:UIViewContentModeScaleAspectFill];
    [tempImgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    [imageView setHidden:YES];
    [self.browser addSubview:tempImgV];
    
    CGRect endFrame   = frame;
    endFrame.origin.x = (SCREEN_WIDTH - frame.size.width) * 0.5;
    endFrame.origin.y = (SCREEN_HEIGHT - frame.size.height) * 0.5;
    [self.browser setOriginFrame:frame];
    [UIView animateWithDuration:0.3 animations:^{
        tempImgV.frame = endFrame;
    } completion:^(BOOL finished) {
        [tempImgV removeFromSuperview];
        [self.browser hideCollectionView:NO];
        [self.browser setCurrentIndex:self.currentIndex];
    }];
}
#pragma mark end UICollectionViewDelegate, UICollectionViewDataSource

#pragma mark - start UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.currentIndex = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.columnView scrollToCurrentIndex:self.currentIndex animated:YES];
}
#pragma mark end UIScrollViewDelegate
@end
