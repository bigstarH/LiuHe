//
//  HomeViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/23.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import "HomeViewController.h"
#import "XQCycleImageView.h"
#import "MenuItem.h"

@interface HomeViewController () <XQCycleImageViewDelegate>

@property (nonatomic, weak) XQCycleImageView *cycleImageView;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createCycleImageView];
    [self createBottomButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.cycleImageView startPlayImageView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.cycleImageView startPlayImageView];
}

- (UIColor *)setBarTintColor
{
    return [UIColor orangeColor];
}

- (UILabel *)setTitleView
{
    UILabel *titleLab      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleLab.text          = @"菜单";
    titleLab.font          = [UIFont boldSystemFontOfSize:18];
    titleLab.textColor     = [UIColor whiteColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    return titleLab;
}

/** 创建图片轮播 */
- (void)createCycleImageView
{
    NSArray *images = @[[UIImage imageNamed:@"tara"],
                        [UIImage imageNamed:@"tara"],
                        [UIImage imageNamed:@"tara"]];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    XQCycleImageView *cycleImage = [XQCycleImageView cycleImageView];
    cycleImage.frame             = CGRectMake(0, 0, width, HEIGHT(110));
    cycleImage.images            = images;
    cycleImage.delegate          = self;
    cycleImage.repeatSecond      = 2;
    cycleImage.autoDragging      = YES;
    self.cycleImageView          = cycleImage;
    [self.view addSubview:cycleImage];
}

- (void)createBottomButton
{
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat hSpace = WIDTH(5);
    CGFloat vSpace = HEIGHT(8);
    
    NSArray *array      = @[@"视频开奖", @"六合大全", @"彩票专区", @"时时彩",
                            @"足球比分", @"娱乐城", @"百家乐", @"皇冠网"];
    NSArray *bgColorArr = @[RGBCOLOR(237, 110, 112), RGBCOLOR(139, 49, 226),
                            RGBCOLOR(42, 77, 157)  , RGBCOLOR(47, 171, 137),
                            RGBCOLOR(67, 180, 237) , RGBCOLOR(255, 131, 250),
                            RGBCOLOR(237, 163, 45) , RGBCOLOR(42, 192, 94)];
    
    CGFloat originY   = CGRectGetMaxY(self.cycleImageView.frame) + vSpace;
    CGFloat mHeight   = (height - originY - 113 - 3 * vSpace) / 3;
    for (int i = 0; i < 8; i++) {
        CGFloat itemX = hSpace;
        CGFloat itemY = originY;
        CGFloat itemW = (width - 3 * hSpace) * 0.5;
        CGFloat itemH = (i == 2 || i == 3 || i == 4) ? mHeight + HEIGHT(20) : mHeight - HEIGHT(10);
        if (i == 6 || i == 7) {
            CGFloat tempW = itemW;
            itemW = (itemW - hSpace) * 0.5;
            itemX = i == 6 ? itemX * 2 + tempW : itemX * 2 + tempW + itemW + hSpace;
        }else if (!(i == 2 || i == 3)){
            itemX = itemX + (i < 2 ? (i % 2) * (hSpace + itemW) : ((i + 1) % 2) * (hSpace + itemW));
        }
        if (i == 2 || i == 3) {
            CGFloat tempH = itemH;
            itemH = (itemH - HEIGHT(6)) * 0.5;
            itemY = (i == 2 ? itemY + vSpace + tempH : itemY + vSpace + tempH + itemH + HEIGHT(6)) - HEIGHT(30);
        }else if (i == 4) {
            itemY = itemY + itemH + vSpace - HEIGHT(30);
        }else {
            itemY = i < 5 ? itemY + (i / 2) * (itemH + vSpace) : itemY + (i + 1) / 3 * (itemH + vSpace) + HEIGHT(30);
        }
        MenuItem *item = [[MenuItem alloc] initWithFrame:CGRectMake(itemX, itemY, itemW, itemH)];
        item.tag       = i;
        [item setMenuTitle:array[i] font:[UIFont systemFontOfSize:14]];
        [item.label setTextColor:[UIColor whiteColor]];
        [item setMenuImage:[UIImage imageNamed:array[i]]];
        [item setMenuClickBlock:^(NSInteger tag) {
            NSLog(@"tag = %zd", tag);
        }];
        [self setMenuTitleAndImageFrame:item];
        [item setBackgroundColor:bgColorArr[i]];
        [self.view addSubview:item];
    }
}

- (void)setMenuTitleAndImageFrame:(MenuItem *)item
{
    CGFloat width  = item.bounds.size.width;
    CGFloat height = item.bounds.size.height;
    CGSize labSize = item.titleSize;
    
    if (item.tag == 0 || item.tag == 5) {
        item.label.frame     = CGRectMake(WIDTH(12), HEIGHT(20), labSize.width, labSize.height);
        item.imageView.frame = CGRectMake(width - WIDTH(18) - WIDTH(55), (height - WIDTH(55)) * 0.5, WIDTH(55), WIDTH(55));
    }else if (item.tag == 2 || item.tag == 3) {
        item.label.frame     = CGRectMake(width * 0.5, (height - labSize.height) * 0.5, labSize.width, labSize.height);
        item.imageView.frame = CGRectMake(WIDTH(22), (height - WIDTH(28)) * 0.5, WIDTH(28), WIDTH(28));
    }else if (item.tag == 1 || item.tag == 4) {
        CGFloat imageW = WIDTH(55) * (item.tag == 4 ? 1.3 : 1.0);
        item.imageView.frame = CGRectMake(WIDTH(10), (height - imageW) * 0.5, imageW, imageW);
        item.label.frame     = CGRectMake(width - WIDTH(10) - labSize.width, HEIGHT(20), labSize.width, labSize.height);
    }else {
        item.imageView.frame = CGRectMake((width - WIDTH(45)) * 0.5, HEIGHT(10), WIDTH(45), WIDTH(45));
        item.label.frame     = CGRectMake(0, height - HEIGHT(10) - labSize.height, width, labSize.height);
    }
}

#pragma mark - start XQCycleImageViewDelegate
- (void)cycleImageView:(XQCycleImageView *)cycleImageView didClickAtIndex:(int)index
{
    
}

- (void)cycleImageViewDidScrollingAnimation:(XQCycleImageView *)cycleImageView atIndex:(int)index
{
    
}
#pragma mark end XQCycleImageViewDelegate

@end
