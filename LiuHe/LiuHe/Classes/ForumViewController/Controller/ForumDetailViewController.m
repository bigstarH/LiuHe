//
//  ForumDetailViewController.m
//  LiuHe
//
//  Created by 胡兴钦 on 2016/12/5.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ForumCommentViewController.h"
#import "ForumDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "XQFasciatePageControl.h"
#import "NSString+Extension.h"
#import "ForumDetailHeader.h"
#import "ForumCommentCell.h"
#import "XQCycleImageView.h"
#import "ForumReplyModel.h"
#import "NetworkManager.h"
#import "AdvertModel.h"
#import "ForumModel.h"
#import "XQToast.h"

@interface ForumDetailViewController () <XQCycleImageViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ForumDetailViewController

- (void)dealloc
{
    NSLog(@"ForumDetailViewController dealloc");
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

- (void)createReplyBtn
{
    // 创建“回复”按钮
    XQBarButtonItem *replyBtn = [[XQBarButtonItem alloc] initWithTitle:@"回復"];
    [replyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [replyBtn setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [replyBtn addTarget:self action:@selector(replyEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = replyBtn;
}

- (void)replyEvent
{
    BOOL didLogin = [UserDefaults boolForKey:USER_DIDLOGIN];
    if (!didLogin) {
        [[XQToast makeText:@"您還沒有登錄，請先登錄"] show];
        return;
    }
    ForumCommentViewController *vc = [[ForumCommentViewController alloc] init];
    vc.type   = FCVCTypeNew;
    vc.mSid   = self.model.sid;
    vc.mTitle = self.model.title;
    [self.navigationController pushViewController:vc animated:YES];
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

/** 创建详情页 */
- (void)createDetailView
{
    ForumDetailHeader *header = [[ForumDetailHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    [header setModel:self.model];
    
    CGFloat tableY = CGRectGetMaxY(self.cycleImageView.frame);
    CGFloat tableH = SCREEN_HEIGHT - tableY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, tableH)];
    self.tableView = tableView;
    [tableView setTableHeaderView:header];
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
}
#pragma mark end 初始化控件

#pragma mark - start 私有方法
- (void)setForumModelWithDict:(NSDictionary *)dict
{
    NSString *newstext   = dict[@"newstext"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithData:[newstext dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    ForumModel *model    = [ForumModel forumModelWithDict:dict];
    model.userNameWidth  = self.model.userNameWidth;
    model.groupNameWidth = self.model.groupNameWidth;
    model.dateString     = self.model.dateString;
    model.newstext       = str.string;
    self.model           = model;
    
    UIFont *font      = [UIFont boldSystemFontOfSize:fontSize(16)];
    CGSize maxSize    = CGSizeMake(SCREEN_WIDTH - WIDTH(24), CGFLOAT_MAX);
    CGSize realSize   = [model.title realSize:maxSize font:font];
    model.titleHeight = realSize.height + HEIGHT(10);
    
    font = [UIFont systemFontOfSize:fontSize(16)];
    realSize = [model.newstext realSize:maxSize font:font];
    model.contentHeight = realSize.height + HEIGHT(10);
    
    for (int i = 0; i < model.hf.count; i++) {
        ForumReplyModel *rmodel = model.hf[i];
        realSize = [rmodel.hftext realSize:maxSize font:font];
        rmodel.textHeight = realSize.height + HEIGHT(10);
        rmodel.cellHeight = rmodel.textHeight + HEIGHT(29) + HEIGHT(20) + HEIGHT(12);
    }
}
#pragma mark end 私有方法

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.hf.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumReplyModel *rmodel = self.model.hf[indexPath.row];
    return rmodel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ForumCommentCell *cell = [ForumCommentCell forumCommentCell:tableView];
    [cell setModel:self.model.hf[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

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
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:@"正在加載中..." removeOnHide:YES];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] forumPostDetailWithSid:self.model.sid
                                                  success:^(NSDictionary *dict) {
                                                      [ws createReplyBtn];
                                                      [ws setForumModelWithDict:dict];
                                                      [ws createDetailView];
                                                      [hud hideAnimated:YES];
                                                  } failure:^(NSString *error) {
                                                      [hud hideAnimated:YES];
                                                      [MBProgressHUD showFailureInView:ws.view mesg:error];
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
                                            [MBProgressHUD showFailureInView:ws.view mesg:error];
                                        }];
}
#pragma mark end 网络请求
@end
