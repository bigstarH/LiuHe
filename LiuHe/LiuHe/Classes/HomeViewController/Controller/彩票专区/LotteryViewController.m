//
//  LotteryViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/14.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import "LotteryViewController.h"
#import "XQFasciatePageControl.h"
#import "WebViewController.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "ShareManager.h"
#import "AdvertModel.h"
#import "ShareMenu.h"

NSString const *WEB_URL = @"http://wap.jizhou56.com:8090/";
static NSString *lotteryCellID = @"lotteryCell";

@interface LotteryViewController () <ShareMenuDelegate, XQCycleImageViewDelegate>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSArray *urlArray;

@end

@implementation LotteryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCycleImageView];
    // 获取广告图片
    [self getAdvertisementPic];
    
    [self createCollectionView];
}

#pragma mark - start 导航栏
- (void)setNavigationBarStyle
{
    self.title = @"彩票專區";
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = shareBtn;
    self.navigationBar.leftBarButtonItem  = leftItem;
}
/** 按钮分享事件 */
- (void)shareEvent
{
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}
#pragma mark end 导航栏

#pragma mark - start 初始化控件
/** 创建图片轮播 */
- (void)createCycleImageView
{
    CGFloat cycleH = SCREEN_WIDTH * 200 / 1100;
    XQCycleImageView *cycleImage = [XQCycleImageView cycleImageView];
    cycleImage.frame             = CGRectMake(0, 64, SCREEN_WIDTH, cycleH);
    cycleImage.backgroundColor   = RGBCOLOR(245, 245, 245);
    cycleImage.delegate          = self;
    cycleImage.repeatSecond      = 5;
    cycleImage.autoDragging      = YES;
    self.cycleImageView          = cycleImage;
    [self.view addSubview:cycleImage];
}

- (void)setCycleImageData
{
    NSMutableArray *array = [NSMutableArray array];
    for (AdvertModel *model in self.imageArr) {
        [array addObject:model.titlepic];
    }
    self.cycleImageView.images = array;
    
    if (array.count <= 1) return;
    
    CGFloat pageY      = CGRectGetMaxY(self.cycleImageView.frame) - HEIGHT(25);
    XQFasciatePageControl *page  = [XQFasciatePageControl pageControl];
    page.frame         = CGRectMake(0, pageY, SCREEN_WIDTH, HEIGHT(25));
    page.numberOfPages = array.count;
    self.pageControl   = page;
    [page setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
    [page setPageIndicatorTintColor:[UIColor whiteColor]];
    [page setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    [self.view addSubview:page];
}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing          = HEIGHT(6);
    layout.minimumInteritemSpacing     = WIDTH(8);
    CGFloat originY = CGRectGetMaxY(self.cycleImageView.frame);
    CGRect frame    = CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY);
    UICollectionView *collectionView   = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.delegate   = self;
    collectionView.dataSource = self;
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setBackgroundColor:RGBCOLOR(245, 245, 245)];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:lotteryCellID];
    [self.view addSubview:collectionView];
}
#pragma mark end 初始化控件

#pragma mark - start 懒加载
- (NSArray *)array
{
    if (_array == nil) {
        _array = @[@"重慶時時彩", @"黑龍江時時彩", @"吉林時時彩", @"天津時時彩",  @"新疆時時彩",
                   @"雲南時時彩", @"大樂透",      @"福彩3D",    @"排列3",      @"排列5",
                   @"七樂彩",    @"七星彩",      @"雙色球",    @"體彩36選7",   @"安徽11選5",
                   @"北京11選5", @"福建11選5",   @"廣東11選5", @"甘肅11選5",   @"廣西11選5",
                   @"貴州11選5", @"河北11選5",   @"河南11選5", @"黑龍江11選5", @"湖北11選5",
                   @"吉林11選5", @"江蘇11選5",   @"江西11選5", @"遼寧11選5",   @"內蒙古11選5",
                   @"四川11選5", @"山東11選5",   @"上海11選5", @"陜西11選5",   @"山西11選5",
                   @"天津11選5", @"新疆11選5",   @"雲南11選5", @"浙江11選5"];
    }
    return _array;
}

- (NSArray *)urlArray
{
    if (_urlArray == nil) {
        _urlArray = @[@"cqssc.php",   @"hljssc.php",   @"jlssc.php",   @"tjssc.php",
                      @"xjssc.php",   @"ynssc.php",    @"daletou.php", @"3d.php",
                      @"pl3.php",     @"pl5.php",      @"qlc.php",     @"qxc.php",
                      @"ssq.php",     @"fjtc36x7.php", @"ah11x5.php",  @"bj11x5.php",
                      @"fj11x5.php",  @"gd11x5.php",   @"gs11x5.php",  @"gx11x5.php",
                      @"gz11x5.php",  @"heb11x5.php",  @"hen11x5.php", @"hlj11x5.php",
                      @"hub11x5.php", @"jl11x5.php",   @"js11x5.php",  @"jx11x5.php",
                      @"ln11x5.php",  @"nmg11x5.php",  @"sc11x5.php",  @"sd11x5.php",
                      @"sh11x5.php",  @"sxl11x5.php",  @"sxr11x5.php", @"tj11x5.php",
                      @"xj11x5.php",  @"yn11x5.php",   @"zj11x5.php"];
    }
    return _urlArray;
}
#pragma mark end 懒加载

#pragma mark - start ShareMenuDelegate
/** 分享事件 */
- (void)shareMenu:(ShareMenu *)shareMenu didSelectMenuItemWithType:(ShareMenuItemType)type
{
    switch (type) {
        case ShareMenuItemTypeWeChat:  // 微信
        {
            [ShareManager weChatShareWithCurrentVC:self success:nil failure:nil];
            break;
        }
        case ShareMenuItemTypeWechatTimeLine:  // 朋友圈
        {
            [ShareManager weChatTimeLineShareWithCurrentVC:self success:^(NSString *result) {
                NSLog(@"result = %@", result);
            } failure:^(NSString *error) {
                NSLog(@"error = %@", error);
            }];
            break;
        }
        case ShareMenuItemTypeQQ:  // QQ
            NSLog(@"QQ");
            break;
        case ShareMenuItemTypeQZone:  // QQ空间
            NSLog(@"QQ空间");
            break;
        default:
            break;
    }
}
#pragma mark end ShareMenuDelegate

#pragma mark - start XQCycleImageViewDelegate
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index
{
    AdvertModel *model = self.imageArr[index];
    if (![model.linkStr isEqualToString:@"#"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.linkStr]];
    }
}

- (void)cycleImageViewDidScrollingAnimation:(XQCycleImageView *)cycleImageView atIndex:(int)index
{
    self.pageControl.currentPage = index;
}
#pragma mark end XQCycleImageViewDelegate

#pragma mark - start UICollectionViewDataSource, UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:lotteryCellID forIndexPath:indexPath];
    UILabel *label = [cell.contentView viewWithTag:101];
    if (label == nil) {
        cell.backgroundColor = [UIColor whiteColor];
        CGFloat width  = (SCREEN_WIDTH - WIDTH(8) * 4) / 3;
        CGFloat height = HEIGHT(35);
        label     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        label.tag = 101;
        [label setFont:[UIFont systemFontOfSize:fontSize(14)]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [cell.contentView addSubview:label];
        
        UIView *view         = [[UIView alloc] init];
        view.backgroundColor = RGBACOLOR(0, 0, 0, 0.3);
        cell.selectedBackgroundView = view;
    }
    label.text = self.array[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *url   = [WEB_URL stringByAppendingString:self.urlArray[indexPath.item]];
    NSString *title = self.array[indexPath.item];
    WebViewController *vc = [[WebViewController alloc] init];
    vc.mTitle     = title;
    vc.requestUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end UICollectionViewDataSource, UICollectionViewDelegate

#pragma mark - start UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width  = (SCREEN_WIDTH - WIDTH(8) * 4) / 3;
    CGFloat height = HEIGHT(35);
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(HEIGHT(6), WIDTH(8), HEIGHT(6), WIDTH(8));
}
#pragma mark end UICollectionViewDelegateFlowLayout

#pragma mark - start 网络请求
/** 获取广告轮播图 */
- (void)getAdvertisementPic
{
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] getADWithURL:GET_INDEXAD_AD_URL
                                        success:^(NSArray *imagesArray) {
                                            NSMutableArray *images = [NSMutableArray array];
                                            for (int i = 0; i < imagesArray.count; i++) {
                                                NSDictionary *dict = imagesArray[i];
                                                AdvertModel *model = [AdvertModel advertModelWithDict:dict];
                                                [images addObject:model];
                                            }
                                            ws.imageArr = images;
                                            [ws setCycleImageData];
                                            [ws.cycleImageView startPlayImageView];
                                        } failure:^(NSString *error) {
                                            [MBProgressHUD showFailureInView:ws.view mesg:error];
                                        }];
}
#pragma mark end 网络请求
@end
