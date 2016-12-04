//
//  ForumDetailViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "ForumDetailViewController.h"
#import "XQFasciatePageControl.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "AdvertModel.h"
#import "ForumModel.h"

@interface ForumDetailViewController () <XQCycleImageViewDelegate>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@property (nonatomic, strong) ForumModel *model;

@end

@implementation ForumDetailViewController

- (void)dealloc
{
    NSLog(@"ForumDetailViewController dealloc");
    [SVProgressHUD dismiss];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 创建广告轮播
    [self createCycleImageView];
    
    // 获取广告数据
    [self getAdvertisementPic];
    // 获取帖子详情
    [self getForumPostDetail];
    
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"帖子詳情";
    XQBarButtonItem *leftItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftItem;
}

- (void)replyEvent
{
    NSLog(@"replyEvent");
}
#pragma mark end 设置导航栏

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
    // 创建“回复”按钮
    XQBarButtonItem *replyBtn = [[XQBarButtonItem alloc] initWithTitle:@"回復"];
    [replyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [replyBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [replyBtn addTarget:self action:@selector(replyEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = replyBtn;
    
    // 设置“轮播”数据
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
#pragma mark end 初始化控件

#pragma mark - start XQCycleImageViewDelegate
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index
{
    AdvertModel *model = self.imageArr[index];
    if (![model.linkStr isEqualToString:@"#"]){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.linkStr]];
    }
}

- (void)cycleImageViewDidScrollingAnimation:(XQCycleImageView *)cycleImageView atIndex:(int)index
{
    self.pageControl.currentPage = index;
}
#pragma mark end XQCycleImageViewDelegate

#pragma mark - start 网络请求
/** 获取帖子详情 */
- (void)getForumPostDetail
{
    [SVProgressHUD showWithStatus:@"正在加載中..."];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] forumPostDetailWithSid:self.sid
                                                  success:^(NSDictionary *dict) {
                                                      [SVProgressHUD dismiss];
                                                      ws.model = [ForumModel forumModelWithDict:dict];
                                                  } failure:^(NSString *error) {
                                                      [SVProgressHUD showErrorWithStatus:error];
                                                  }];
}

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
                                            [SVProgressHUD showErrorWithStatus:error];
                                        }];
}
#pragma mark end 网络请求
@end
