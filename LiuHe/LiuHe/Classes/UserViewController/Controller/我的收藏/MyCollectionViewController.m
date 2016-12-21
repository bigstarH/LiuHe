//
//  MyCollectionViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/28.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "ForumDetailViewController.h"
#import "DataDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "PicDetailViewController.h"
#import "PicLibraryModel.h"
#import "CollectionModel.h"
#import "NetworkManager.h"
#import "ShareManager.h"
#import "XQAlertView.h"
#import "ForumModel.h"
#import "ShareMenu.h"
#import "XQToast.h"

@interface MyCollectionViewController () <ShareMenuDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MyCollectionViewController

- (void)dealloc
{
    NSLog(@"MyCollectionViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    [self createView];
    [self getMyCollectionData];
}

- (void)setNavigationBarStyle
{
    self.title = @"我的收藏";
    
    XQBarButtonItem *leftBtn  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftBtn;
    self.navigationBar.rightBarButtonItem = shareBtn;
}

- (void)shareEvent
{
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}

- (void)createView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(30))];
    label.text     = @"提示：向左滑動可以取消收藏";
    label.font     = [UIFont systemFontOfSize:fontSize(12)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:label];
    
    CGFloat tableY = CGRectGetMaxY(label.frame);
    CGFloat tableH = SCREEN_HEIGHT - tableY;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableY, SCREEN_WIDTH, tableH)];
    self.tableView         = tableView;
    tableView.dataSource   = self;
    tableView.delegate     = self;
    [tableView setTableFooterView:[[UIView alloc] init]];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tableView];
}

/** 取消收藏 */
- (void)cancelCollectingWithRow:(NSIndexPath *)indexPath
{
    __weak typeof(self) ws = self;
    XQAlertView *alert = [[XQAlertView alloc] initWithTitle:@"提示" message:@"確定要取消收藏麽？"];
    alert.themeColor   = RGBCOLOR(238, 154, 0);
    [alert addButtonWithTitle:@"再想一想" style:XQAlertButtonStyleCancel handle:nil];
    [alert addButtonWithTitle:@"確定" style:XQAlertButtonStyleDefault handle:^{
        CollectionModel *model  = ws.array[indexPath.section][indexPath.row];
        MBProgressHUD *hud      = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
        NetworkManager *manager = [NetworkManager shareManager];
        [manager cancelCollectingWithSid:model.sid
                                 success:^(NSString *str) {
                                     [hud hideAnimated:YES];
                                     [[XQToast makeText:str] show];
                                     NSMutableArray *array = [ws.array mutableCopy];
                                     NSMutableArray *list = array[indexPath.section];
                                     if (list.count == 1) {
                                         [array removeObjectAtIndex:indexPath.section];
                                         NSMutableArray *titles = [ws.titleArray mutableCopy];
                                         [titles removeObjectAtIndex:indexPath.section];
                                         ws.titleArray = titles;
                                         ws.array      = array;
                                         [ws.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     }else {
                                         [list removeObject:model];
                                         array[indexPath.section] = list;
                                         ws.array = array;
                                         [ws.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     }
                                 } failure:^(NSString *error) {
                                     [hud hideAnimated:YES];
                                     [MBProgressHUD showFailureInView:ws.view mesg:error];
                                 }];
    }];
    [alert show];
}

/** 图库详情 */
- (void)goToPicDetailVCWithDict:(NSDictionary *)dict classid:(NSString *)classid
{
    PicLibraryModel *pModel = [PicLibraryModel picLibraryWithDict:dict];
    NSString *url    = pModel.url;
    if (classid.intValue != 65) {
        url  = [NSString stringWithFormat:@"%@%@/%@.jpg", pModel.url, pModel.qishu, pModel.type];
    }
    pModel.urlString  = url;
    PicDetailViewController *vc = [[PicDetailViewController alloc] init];
    vc.classID = classid;
    vc.model   = pModel;
    vc.collectedBtn = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - start ShareMenuDelegate
/** 分享事件 */
- (void)shareMenu:(ShareMenu *)shareMenu didSelectMenuItemWithType:(ShareMenuItemType)type
{
    switch (type) {
        case ShareMenuItemTypeWeChat:  // 微信
            [ShareManager weChatShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeWechatTimeLine:  // 朋友圈
            [ShareManager weChatTimeLineShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQQ:  // QQ
            [ShareManager QQShareWithCurrentVC:self success:nil failure:nil];
            break;
        case ShareMenuItemTypeQZone:  // QQ空间
            [ShareManager QZoneWithCurrentVC:self success:nil failure:nil];
            break;
        default:
            break;
    }
}
#pragma mark end ShareMenuDelegate

#pragma mark - start UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.array[section];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleArray[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 36;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) ws     = self;
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"取消收藏"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      [ws cancelCollectingWithRow:indexPath];
                                                                  }];
    edit.backgroundColor = [UIColor redColor];
    return @[edit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    CollectionModel *model = self.array[indexPath.section][indexPath.row];
    cell.textLabel.text    = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CollectionModel *model = self.array[indexPath.section][indexPath.row];
    [self getMycollectionDetail:model];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start 网络请求——获取我的收藏
- (void)getMyCollectionData
{
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:@"正在加载数据..." removeOnHide:YES];
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] userCollectionWithSuccess:^(NSArray *array) {
        [hud hideAnimated:YES];
        NSMutableArray *totalList = [NSMutableArray array];
        NSMutableArray *titleList = [NSMutableArray array];
        NSMutableArray *postList  = [NSMutableArray array]; // 帖子
        NSMutableArray *dataList  = [NSMutableArray array]; // 资料
        NSMutableArray *picList   = [NSMutableArray array]; // 图片
        for (int i = 0; i < array.count; i++) {
            NSDictionary *dict     = array[i];
            CollectionModel *model = [CollectionModel collectionModelWithDict:dict];
            if (model.classid.intValue == 1) {
                [postList addObject:model];
            }else if (model.classid.intValue == 66 || model.classid.intValue == 89 ||
                      model.classid.intValue == 92 || model.classid.intValue == 65) {
                [picList addObject:model];
            }else {
                NSString *title = model.title;
                title = [title stringByReplacingOccurrencesOfString:@"六合管家" withString:@"六合藏宝"];
                model.title     = title;
                [dataList addObject:model];
            }
        }
        if (postList.count > 0) {
            [totalList addObject:postList];
            [titleList addObject:@"我的帖子"];
        }
        if (dataList.count > 0) {
            [totalList addObject:dataList];
            [titleList addObject:@"我的資料"];
        }
        if (picList.count > 0) {
            [totalList addObject:picList];
            [titleList addObject:@"我的圖庫"];
        }
        ws.titleArray = titleList;
        ws.array      = totalList;
        [ws.tableView reloadData];
    } failure:^(NSString *error) {
        [hud hideAnimated:YES];
        [MBProgressHUD showFailureInView:ws.view mesg:error];
    }];
}

/** 获取我的收藏详情 */
- (void)getMycollectionDetail:(CollectionModel *)model
{
    NSString *classid  = model.classid;
    NSString *sid      = model.tid;
    
    if (classid.intValue == 1) {
        ForumDetailViewController *vc = [[ForumDetailViewController alloc] init];
        ForumModel *fModel = [[ForumModel alloc] init];
        fModel.sid         = sid;
        vc.model           = fModel;
        vc.needReplyBtn    = NO;
        vc.needCollectBtn  = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (classid.intValue == 66 || classid.intValue == 89 ||
              classid.intValue == 92 || classid.intValue == 65) {
        MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
        __weak typeof(self) ws  = self;
        NetworkManager *manager = [NetworkManager shareManager];
        [manager userCollectionWithSid:model.tid
                               success:^(NSDictionary *dict) {
                                   [hud hideAnimated:YES];
                                   [ws goToPicDetailVCWithDict:dict classid:classid];
                               } failure:^(NSString *error) {
                                   [hud hideAnimated:YES];
                                   [MBProgressHUD showFailureInView:ws.view mesg:error];
                               }];
    }else {
        DataDetailViewController *vc = [[DataDetailViewController alloc] init];
        vc.sid = sid;
        vc.classID = classid;
        vc.needCollectedBtn = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark end 网络请求——获取我的收藏
@end
