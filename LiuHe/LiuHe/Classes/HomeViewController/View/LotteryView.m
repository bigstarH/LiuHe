//
//  LotteryView.m
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#define ITEM_TAG(tag)  (tag) + 101

#import "LotteryView.h"

@interface LotteryItem : UIView

@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, weak) UILabel *numberLab;

@property (nonatomic, weak) UILabel *animalLab;

@end

@interface LotteryView ()

@property (nonatomic, weak) UIImageView *addImageView;

@end

@implementation LotteryView
{
    BOOL setLayout;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        setLayout = YES;
        [self createView];
    }
    return self;
}

- (void)createView
{
    for (int i = 0; i < 8; i++) {
        if (i == 6) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image        = [UIImage imageNamed:@"add"];
            self.addImageView      = imageView;
            [self addSubview:imageView];
        }else {
            LotteryItem *item = [[LotteryItem alloc] init];
            item.tag          = ITEM_TAG(i);
            [self addSubview:item];
        }
    }
}

- (void)layoutSubviews
{
    if (!setLayout) return;
    
    CGFloat width  = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat addW   = WIDTH(20);
    CGFloat itemH  = HEIGHT(50);
    CGFloat itemW  = WIDTH(26);
    CGFloat itemY  = (height - itemH) * 0.5;
    CGFloat space  = (width - 7 * itemW - addW) / 9;
    CGFloat itemX  = space;
    for (int i = 0; i < 8; i++) {
        if (i == 6) {
            CGFloat originY         = (height - itemW) * 0.5;
            self.addImageView.frame = CGRectMake(itemX, originY, addW, addW);
            itemX += space + addW;
        }else {
            LotteryItem *item = (LotteryItem *)[self viewWithTag:ITEM_TAG(i)];
            item.frame        = CGRectMake(itemX, itemY, itemW, itemH);
            itemX += space + itemW;
        }
    }
    
    setLayout = NO;
}

- (void)setModel:(LotteryNumberModel *)model
{
    _model = model;
    NSArray *images = @[@"redball", @"redball", @"greenball", @"greenball", @"blueball", @"blueball", @"", @"redball"];
    for (int i = 0; i < 8; i++) {
        if (i == 6) continue;
        LotteryItem *item   = [self viewWithTag:ITEM_TAG(i)];
        item.numberLab.text = [self numberWithTag:i model:model];
        item.animalLab.text = [self animalWithTag:i model:model];
        [item.bgImageView setImage:[UIImage imageNamed:images[i]]];
    }
}

- (NSString *)numberWithTag:(int)tag model:(LotteryNumberModel *)model
{
    switch (tag) {
        case 0:
            return model.z1m;
        case 1:
            return model.z2m;
        case 2:
            return model.z3m;
        case 3:
            return model.z4m;
        case 4:
            return model.z5m;
        case 5:
            return model.z6m;
        case 7:
            return model.tm;
        default:
            return @"";
    }
}

- (NSString *)animalWithTag:(int)tag model:(LotteryNumberModel *)model
{
    switch (tag) {
        case 0:
            return model.z1sx;
        case 1:
            return model.z2sx;
        case 2:
            return model.z3sx;
        case 3:
            return model.z4sx;
        case 4:
            return model.z5sx;
        case 5:
            return model.z6sx;
        case 7:
            return model.tmsx;
        default:
            return @"";
    }
}

@end

@implementation LotteryItem

- (instancetype)init
{
    if (self = [super init]) {
        [self createView];
    }
    return self;
}

- (void)createView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bgImageView       = imageView;
    imageView.image        = [UIImage imageNamed:@"greenball"];
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    self.numberLab = label;
    label.text     = @"25";
    label.font     = [UIFont systemFontOfSize:fontSize(13)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [imageView addSubview:label];
    
    label          = [[UILabel alloc] init];
    self.animalLab = label;
    label.text     = @"猴";
    label.font     = [UIFont systemFontOfSize:fontSize(14)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:label];
}

- (void)layoutSubviews
{
    if (!CGRectEqualToRect(self.bgImageView.frame, CGRectZero)) return;
    
    CGFloat width      = self.bounds.size.width;
    CGFloat height     = self.bounds.size.height;
    
    _bgImageView.frame = CGRectMake(0, 0, width, width);
    
    CGFloat numberW    = WIDTH(20);
    _numberLab.frame   = CGRectMake(WIDTH(1.5), 0, numberW, numberW);
    
    CGFloat aniLabY    = width + HEIGHT(5);
    CGFloat aniLabH    = height - aniLabY;
    _animalLab.frame   = CGRectMake(0, aniLabY, width, aniLabH);
}

@end
