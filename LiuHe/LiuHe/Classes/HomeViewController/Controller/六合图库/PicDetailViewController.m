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
#import "XQPickerView.h"
#import "PictureCell.h"
#import "ColumnView.h"
#import "XQToast.h"

@interface PicDetailViewController () <ColumnViewDelegate, PictureCellDelegate, PictureBrowserDelegate, XQPickerViewDelegate, XQPickerViewDataSource>

@property (strong, nonatomic) NSArray *dataList;

@property (strong, nonatomic) NSMutableArray *yearList;

@property (strong, nonatomic) NSMutableDictionary *yearDict;

@property (weak, nonatomic) UICollectionView *collectionView;

@property (weak, nonatomic) ColumnView *columnView;

@property (weak, nonatomic) PictureBrowser *browser;

@property (weak, nonatomic) UIImageView *bigImageView;

@property (weak, nonatomic) XQPickerView *picker;

@property (nonatomic) NSInteger currentIndex;
/** picker选中的下标 */
@property (nonatomic) NSInteger pickerIndex;
/** 最近一次picker选择的下标 */
@property (nonatomic) NSInteger lastPickerIndex;
@end

@implementation PicDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.currentIndex         = 0;
    self.pickerIndex          = 0;
    self.lastPickerIndex      = 0;
    
    if (self.classID.intValue != 65) {
        // 获取往年期数
        [self getYearData];
    }
    
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
    self.navigationBar.leftBarButtonItem  = leftItem;
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.classID.intValue != 65) {
        XQBarButtonItem *dateBtn = [[XQBarButtonItem alloc] initWithTitle:@"年份"];
        [dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [dateBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        [dateBtn addTarget:self action:@selector(showDatePick) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:dateBtn];
    }
    
    if (self.isCollectedBtn) {
        XQBarButtonItem *collect = [[XQBarButtonItem alloc] initWithTitle:@"收藏"];
        [collect setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [collect setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
        [collect addTarget:self action:@selector(collectEvent) forControlEvents:UIControlEventTouchUpInside];
        [array addObject:collect];
    }
    self.navigationBar.rightBarButtonItems = array;
}

/** 历史年份 */
- (void)showDatePick
{
    XQPickerView *picker = self.picker;
    if (!picker) {
        picker = [XQPickerView pickerView];
        picker.delegate   = self;
        picker.dataSource = self;
        self.picker       = picker;
        [self.picker selectRow:_pickerIndex inComponent:0 animated:NO];
    }
    [picker showWithAnimated:YES];
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
    if (self.classID.intValue == 65) {
        [array addObject:_model.url];
        [list addObject:_model.url];
    }else {
        for (int i = _model.qishu.intValue; i > 0 ; i--) {
            NSString *str = [NSString stringWithFormat:@"第%d期", i];
            NSString *url = [NSString stringWithFormat:@"%@%@/%03d/%@.jpg", _model.url, _curYear, i, _model.type];
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
    CGFloat originY = self.classID.intValue == 65 ? 65 : CGRectGetMaxY(self.columnView.frame);
    
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

- (NSMutableDictionary *)yearDict
{
    if (!_yearDict) {
        _yearDict = [NSMutableDictionary dictionary];
    }
    return _yearDict;
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

#pragma mark - start XQPickerViewDelegate, XQPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.yearList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = self.yearList[row];
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.pickerIndex = row;
}

- (void)sureButtonDidClickWithPicker:(UIPickerView *)picker
{
    NSString *key   = self.yearList[self.pickerIndex];
    NSString *qishu = self.yearDict[key];
    if (qishu.intValue == 0) {
        [[XQToast makeText:@"当前年份没有数据哦！"] show];
        return;
    }
    
    if (self.lastPickerIndex == self.pickerIndex) return;
    self.lastPickerIndex = self.pickerIndex;
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *list  = [NSMutableArray array];
    for (int i = qishu.intValue; i > 0 ; i--) {
        NSString *str = [NSString stringWithFormat:@"第%d期", i];
        NSString *url = [NSString stringWithFormat:@"%@%@/%03d/%@.jpg", _model.url, key, i, _model.type];
        [array addObject:str];
        [list addObject:url];
    }
    self.columnView.items = array;
    [self.columnView reloadData];
    
    self.dataList = list;
    [self.collectionView reloadData];
}
#pragma mark end XQPickerViewDelegate, XQPickerViewDataSource

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

#pragma mark - start 往年期数
- (void)getYearData
{
    self.yearList = [NSMutableArray arrayWithObject:_curYear];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] picLibYearQishuWithSuccess:^(NSDictionary *dict) {
        NSArray *keys = [dict allKeys];
        NSArray *sort = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString *  _Nonnull obj2) {
            if (IOS_9_LATER) {
                return NSOrderedAscending;
            }
            return NSOrderedDescending;
        }];
        [ws.yearList addObjectsFromArray:sort];
        [ws.yearDict setDictionary:dict];
        [ws.yearDict setObject:_model.qishu forKey:_curYear];
    } failure:nil];
}
#pragma mark end 往年期数
@end
