//
//  TrendViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "TrendViewController.h"
#import "NetworkManager.h"

@interface TrendViewController ()

@property (nonatomic) VCType type;

@end

@implementation TrendViewController

- (instancetype)initWithType:(VCType)type
{
    if (self = [super initWithHidesBottomBar:YES]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


@end
