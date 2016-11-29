//
//  ForumViewController.m
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "VideoLotteryViewController.h"
#import "XQFasciatePageControl.h"
#import "TrendViewController.h"
#import "ForumViewController.h"
#import "XQCycleImageView.h"
#import "NetworkManager.h"
#import "AdvertModel.h"
#import "MenuItem.h"

@interface ForumViewController ()

@property (nonatomic, strong) NSArray *imageArr;

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@property (nonatomic, weak) XQFasciatePageControl *pageControl;

@end

@implementation ForumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"論壇";
}

#pragma mark - start 设置导航栏
- (void)shareEvent
{
    NSLog(@"分享");
}
#pragma mark end 设置导航栏

@end
