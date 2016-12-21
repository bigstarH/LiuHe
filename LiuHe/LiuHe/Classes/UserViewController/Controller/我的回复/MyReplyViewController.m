//
//  MyReplyViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "ForumCommentViewController.h"
#import "ForumDetailViewController.h"
#import "MBProgressHUD+Extension.h"
#import "MyReplyViewController.h"
#import "XQSegmentedControl.h"
#import "NetworkManager.h"
#import "ShareManager.h"
#import "ReplyModel.h"
#import "ForumModel.h"
#import "ShareMenu.h"

@interface MyReplyViewController () <UITableViewDelegate, UITableViewDataSource, ShareMenuDelegate>
/** 0: 未审核， 1: 已审核 */
@property (nonatomic) NSInteger type;

@property (nonatomic, weak) UITableView *tableView;
/** 已审核的回复 */
@property (nonatomic, strong) NSArray *replyArray;
/** 未审核的回复 */
@property (nonatomic, strong) NSArray *unReplyArray;

@end

@implementation MyReplyViewController

- (void)dealloc
{
    [NotificationCenter removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(245, 242, 241);
    self.type = 1;
    
    // 帖子编辑成功时通知
    [NotificationCenter addObserver:self selector:@selector(replyEditSuccess:) name:FORUM_REPLY_EDIT_SUCCESS object:nil];
    
    [self createView];
    [self getMyReply];
}

- (void)setNavigationBarStyle
{
    XQBarButtonItem *leftBtn  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftBtn addTarget:self action:@selector(goBackWithNavigationBar:) forControlEvents:UIControlEventTouchUpInside];
    XQBarButtonItem *shareBtn = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_share"]];
    [shareBtn addTarget:self action:@selector(shareEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftBtn;
    self.navigationBar.rightBarButtonItem = shareBtn;
}

- (UIView *)setTitleView
{
    XQSegmentedControl *segControl = [[XQSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 120, 28)];
    segControl.selectedTextColor   = MAIN_COLOR;
    segControl.textColor           = [UIColor whiteColor];
    segControl.tintColor           = [UIColor clearColor];
    segControl.layer.masksToBounds = YES;
    segControl.layer.borderColor   = [UIColor whiteColor].CGColor;
    segControl.layer.borderWidth   = 1.0;
    segControl.layer.cornerRadius  = 3;
    segControl.panEnabled          = NO;
    [segControl setItems:@[@"已审核", @"未审核"]];
    [segControl setFont:[UIFont systemFontOfSize:13]];
    [segControl addTarget:self action:@selector(segmentEvent:) forControlEvents:UIControlEventValueChanged];
    return segControl;
}

#pragma mark - start 编辑帖子成功时通知
- (void)replyEditSuccess:(NSNotification *)notification
{
    [self getMyReply];
}
#pragma mark end 编辑帖子成功时通知

- (void)createView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, HEIGHT(30))];
    label.text     = @"提示：向左滑動可對回復進行修改";
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

- (void)shareEvent
{
    ShareMenu *menu = [ShareMenu shareMenu];
    menu.delegate   = self;
    [menu show];
}

- (void)segmentEvent:(XQSegmentedControl *)sender
{
    self.type = !sender.selectedSegmentIndex;
    if (self.type == 0 && !self.unReplyArray) {
        [self getMyReply];
    }else if (self.type == 1 && !self.replyArray) {
        [self getMyReply];
    }else {
        [self.tableView reloadData];
    }
}

- (void)goToForumCommentVCWithRow:(NSInteger)row
{
    NSString *sid   = @"";
    if (self.type == 0) {
        ReplyModel *model = [self.unReplyArray objectAtIndex:row];
        sid = model.sid;
    }else {
        ReplyModel *model = [self.replyArray objectAtIndex:row];
        sid = model.sid;
    }
    ForumCommentViewController *vc = [[ForumCommentViewController alloc] init];
    vc.type   = FCVCTypeEdit;
    vc.status = self.type;
    vc.mSid   = sid;
    vc.mTitle = @"";
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.type == 1 ? self.replyArray.count : self.unReplyArray.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.type;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) ws = self;
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                    title:@"编辑"
                                                                  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                      [ws goToForumCommentVCWithRow:indexPath.row];
                                                                  }];
    edit.backgroundColor = MAIN_COLOR;
    return @[edit];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (self.type == 0) { // 未审核
        ReplyModel *model   = self.unReplyArray[indexPath.row];
        cell.textLabel.text = model.title;
    }else {  // 已审核
        ReplyModel *model   = self.replyArray[indexPath.row];
        cell.textLabel.text = model.title;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReplyModel *model = self.type == 0 ? self.unReplyArray[indexPath.row] : self.replyArray[indexPath.row];
    ForumDetailViewController *vc = [[ForumDetailViewController alloc] init];
    ForumModel *fModel = [[ForumModel alloc] init];
    fModel.sid         = model.tid;
    vc.model           = fModel;
    vc.needReplyBtn    = NO;
    vc.needCollectBtn  = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark end UITableViewDelegate, UITableViewDataSource

#pragma mark - start 网络请求
- (void)getMyReply
{
    NSString *enews = @"Myrep";
    if (self.type == 0) {
        enews = @"Myrep1";
    }
    MBProgressHUD *hud = [MBProgressHUD hudView:self.view text:nil removeOnHide:YES];
    NSInteger type     = self.type;
    __weak typeof(self) ws = self;
    [[NetworkManager shareManager] userReplyWithEnews:enews
                                              success:^(NSArray *array) {
                                                  [hud hideAnimated:YES];
                                                  NSMutableArray *data = [NSMutableArray array];
                                                  for (int i = 0; i < array.count; i++) {
                                                      NSDictionary *dict = array[i];
                                                      ReplyModel *model   = [ReplyModel replyModelWithDict:dict];
                                                      [data addObject:model];
                                                  }
                                                  if (type == 0) {
                                                      ws.unReplyArray = data;
                                                  }else {
                                                      ws.replyArray   = data;
                                                  }
                                                  [ws.tableView reloadData];
                                              } failure:^(NSString *error) {
                                                  [hud hideAnimated:YES];
                                                  [MBProgressHUD showFailureInView:ws.view mesg:error];
                                              }];
}
#pragma mark end 网络请求
@end
