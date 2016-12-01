//
//  DataDetailViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/1.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "DataDetailViewController.h"
#import "NetworkManager.h"
#import "DataModel.h"

@interface DataDetailViewController ()

@end

@implementation DataDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getDataDetail];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.title = @"详情";
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
    NSLog(@"分享");
}
#pragma mark end 设置导航栏

#pragma mark - start 网络请求
- (void)getDataDetail
{
    [[NetworkManager shareManager] dataDetailWithSid:_model.sid
                                             success:^(NSDictionary *dict) {
                                                 NSString *newstext = dict[@"newstext"];
                                                 NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithData:[newstext dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
                                                 NSLog(@"newstext = %@", str.string);
                                             } failure:^(NSString *error) {
                                                 [SVProgressHUD showErrorWithStatus:error];
                                             }];
}
#pragma mark end 网络请求
@end
