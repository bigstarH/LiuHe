//
//  VideoViewController.m
//  LiuHe
//
//  Created by huxingqin on 2016/12/12.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VideoViewController.h"
#import "NetworkManager.h"
#import "LotteryView.h"

@interface VideoViewController ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
/** 期数 */
@property (nonatomic, weak) UILabel *bqLab;

@property (nonatomic, weak) UIView *numberBackgroundView;
/** "+"号图片 */
@property (nonatomic, weak) UIImageView *addImageView;

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) AVAudioPlayer *aVAudioPlayer;

@property (nonatomic, strong) NSTimer *timer;
/** 是否静音 */
@property (nonatomic, getter=isSilence) BOOL silence;

@property (nonatomic, getter=isRefreshing) BOOL refreshing;
/** 当前开到第index个号码 */
@property (nonatomic) NSInteger index;
/** 号码球宽 */
@property (nonatomic) CGFloat itemWidth;
/** 号码球高 */
@property (nonatomic) CGFloat itemHeight;
@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.silence    = [UserDefaults boolForKey:LOTTERY_SILENCE];
    self.refreshing = YES;
    self.index      = 0;
    
    // 播放背景音乐
    [self playBackgroundMusic];
    
    [self createView];
    // 网络请求
    [self getLotteryNumber];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [self.player stop];
    [self.aVAudioPlayer stop];
}

#pragma mark - start 设置导航栏
- (void)setNavigationBarStyle
{
    self.navigationBar.imageView.hidden = YES;
    self.title = @"六合藏宝图";
    XQBarButtonItem *leftItem  = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"]];
    [leftItem addTarget:self action:@selector(goBackVC) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.leftBarButtonItem  = leftItem;
    XQBarButtonItem *rightItem = [[XQBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_horn_open"]];
    [rightItem setImage:[UIImage imageNamed:@"ic_horn_close"] forState:UIControlStateSelected];
    [rightItem setSelected:[UserDefaults boolForKey:LOTTERY_SILENCE]];
    [rightItem addTarget:self action:@selector(volumeEvent:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBar.rightBarButtonItem = rightItem;
}

- (void)goBackVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)volumeEvent:(XQBarButtonItem *)sender
{
    sender.selected = !sender.selected;
    self.silence    = sender.selected;
    [UserDefaults setBool:sender.selected forKey:LOTTERY_SILENCE];
    _aVAudioPlayer.volume = !self.silence;
    _player.volume        = !self.silence;
}
#pragma mark end 设置导航栏

#pragma mark - start 初始化控件
- (void)createView
{
    UIImageView *imageView   = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundImageView = imageView;
    [imageView setImage:[UIImage imageNamed:@"StarAnimation1"]];
    [self.view insertSubview:imageView belowSubview:self.navigationBar];
    
    CGFloat labelX  = WIDTH(15);
    CGFloat labelY  = SCREEN_HEIGHT * 0.67;
    CGFloat labelW  = SCREEN_WIDTH - labelX * 2;
    CGFloat labelH  = HEIGHT(45);
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
    self.bqLab      = label;
    label.font      = [UIFont fontWithName:@"Arial" size:fontSize(20)];
    label.textColor = [UIColor redColor];
    [self.view addSubview:label];
    
    CGFloat viewX   = WIDTH(12);
    CGFloat viewW   = SCREEN_WIDTH - viewX * 2;
    CGFloat viewY   = CGRectGetMaxY(self.bqLab.frame);
    CGFloat viewH   = HEIGHT(80);
    UIView *numberBackground  = [[UIView alloc] initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    self.numberBackgroundView = numberBackground;
    [numberBackground setBackgroundColor:RGBACOLOR(0, 0, 0, 0.12)];
    [numberBackground.layer setMasksToBounds:YES];
    [numberBackground.layer setCornerRadius:WIDTH(6)];
    [self.view addSubview:numberBackground];
    
    _itemHeight   = HEIGHT(50);
    _itemWidth    = WIDTH(26);
    CGFloat addW  = WIDTH(20);
    CGFloat addY  = (viewH - addW) * 0.5;
    CGFloat space = (viewW - 7 * _itemWidth - addW) / 9;
    CGFloat addX  = viewW - space * 2 - addW - _itemWidth;
    imageView     = [[UIImageView alloc] initWithFrame:CGRectMake(addX, addY, addW, addW)];
    _addImageView = imageView;
    [imageView setImage:[UIImage imageNamed:@"add"]];
    [_numberBackgroundView addSubview:imageView];
}

/** 创建号码 */
- (LotteryItem *)createLotteryNumber:(NSString *)number animal:(NSString *)animal
{
    LotteryItem *item   = [[LotteryItem alloc] init];
    item.numberLab.text = number;
    item.animalLab.text = animal;
    [item selectBgImageWithNumber:number];
    [self.view addSubview:item];
    return item;
}
#pragma mark end 初始化控件

#pragma mark - start 开始摇奖，摇奖过程、摇奖结束动画
/** 开始摇奖动画 */
- (void)beginAniamtion
{
    if ([_backgroundImageView isAnimating]) {
        return;
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 25; i++) {
        NSString *imageName = [NSString stringWithFormat:@"StarAnimation%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    _backgroundImageView.animationImages = images;
    _backgroundImageView.animationRepeatCount = 0;
    _backgroundImageView.animationDuration = _backgroundImageView.animationImages.count * 0.1;
    [_backgroundImageView startAnimating];
    
    [_backgroundImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:_backgroundImageView.animationDuration * 10000];
    
    __weak typeof(self) ws = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [ws courseAnimation];
    });
}

/** 摇奖过程动画 */
- (void)courseAnimation
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 27; i++) {
        NSString *imageName = [NSString stringWithFormat:@"CourseAnimation%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    _backgroundImageView.animationImages      = images;
    _backgroundImageView.animationRepeatCount = 0;
    _backgroundImageView.animationDuration = _backgroundImageView.animationImages.count * 0.1;
    _backgroundImageView.image = [UIImage imageNamed:@"CourseAnimation14"];
    [_backgroundImageView startAnimating];
    
    [_backgroundImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:_backgroundImageView.animationDuration * 100000];
}

/** 摇奖结束动画 */
- (void)endAnimation
{
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i <= 25; i++) {
        NSString *imageName = [NSString stringWithFormat:@"EndAnimation%d",i];
        UIImage *image = [UIImage imageNamed:imageName];
        [images addObject:image];
    }
    _backgroundImageView.animationImages   = images;
    _backgroundImageView.animationDuration = _backgroundImageView.animationImages.count * 0.1;
    [_backgroundImageView startAnimating];
    
    [_backgroundImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:_backgroundImageView.animationDuration];
}
#pragma mark end 开始摇奖，摇奖过程、摇奖结束动画

#pragma mark - start 音效、音乐
/** 播放背景音乐 */
- (void)playBackgroundMusic
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"musicBackground_1.mp3" ofType:nil];
    NSURL *url     = [NSURL fileURLWithPath:path];
    _player        = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.numberOfLoops = 1000;
    if (self.isSilence) {
        _player.volume = !self.isSilence;
    }else{
        _player.volume = 1.2f;
    }
    [_player prepareToPlay];
    [_player play];
}

/** 播放“开始搅珠”音效 */
- (void)playSoundStartPrize
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:@"1111.mp3" withExtension:nil];
    _aVAudioPlayer  = [[AVAudioPlayer alloc]initWithContentsOfURL:soundURL error:nil];
    _aVAudioPlayer.numberOfLoops = 0;
    if (self.isSilence) {
        _aVAudioPlayer.volume = !self.isSilence;
    }else{
        _aVAudioPlayer.volume = 1.2f;
    }
    [_aVAudioPlayer prepareToPlay];
    [_aVAudioPlayer play];
}

/** 播放“第n个号码”的音效 */
- (void)playSoundsForOrdinalNumeral:(NSString *)number
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:number withExtension:nil];
    _aVAudioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    _aVAudioPlayer.numberOfLoops = 0;
    if (self.isSilence) {
        _aVAudioPlayer.volume = !self.isSilence;
    }else{
        _aVAudioPlayer.volume = 1.2f;
    }
    [_aVAudioPlayer prepareToPlay];
    [_aVAudioPlayer play];
}

/** 播放"号码"音效 */
- (void)playSoundsForNumber:(NSString *)number
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:number withExtension:nil];
    _aVAudioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    _aVAudioPlayer.numberOfLoops = 0;
    if (self.isSilence) {
        _aVAudioPlayer.volume = !self.isSilence;
    }else{
        _aVAudioPlayer.volume = 1.2f;
    }
    [_aVAudioPlayer prepareToPlay];
    [_aVAudioPlayer play];
}

/** 播放“生肖”音效 */
- (void)playSoundsForAnimal:(NSString *)animal
{
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:animal withExtension:nil];
    _aVAudioPlayer  = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:nil];
    _aVAudioPlayer.numberOfLoops = 0;
    if (self.isSilence) {
        _aVAudioPlayer.volume = !self.isSilence;
    }else{
        _aVAudioPlayer.volume = 1.2f;
    }
    [_aVAudioPlayer prepareToPlay];
    [_aVAudioPlayer play];
}
#pragma mark end 音效、音乐

#pragma mark - start 私有方法
/** 创建“号码球”动画 */
- (void)initNumberAnimateWithNo:(NSString *)no animal:(NSString *)animal index:(NSInteger)index
{
    CGFloat originX   = _numberBackgroundView.frame.size.width * 0.435;
    CGFloat originY   = self.view.frame.size.height * 0.60;
    CGRect frame      = CGRectMake(originX, originY, _itemWidth, _itemHeight);
    LotteryItem *item = [[LotteryItem alloc] initWithFrame:frame];
    [self.view addSubview:item];
    
    CGFloat itemY     = _numberBackgroundView.frame.origin.y + (_numberBackgroundView.frame.size.height - _itemHeight) * 0.5;
    CGFloat space     = (CGRectGetWidth(_numberBackgroundView.frame) - 7 * _itemWidth - CGRectGetWidth(_addImageView.frame)) / 9;
    frame.origin.y    = itemY;
    frame.origin.x    = WIDTH(12) + space * index + _itemWidth * (index - 1);
    if (index == 7) {
        frame.origin.x += space + CGRectGetWidth(_addImageView.frame);
    }
    [UIView animateWithDuration:2.0 animations:^{
        item.frame    = frame;
    }];
    
    item.numberLab.text = no;
    item.animalLab.text = animal;
    [item selectBgImageWithNumber:no];
    
    NSString *soundName = [NSString stringWithFormat:@"%02zd.mp3", index];
    [self playSoundsForOrdinalNumeral:soundName];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playSoundsForNumber:[NSString stringWithFormat:@"%02d.m4a", [no intValue]]];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playSoundsForAnimal:[animal stringByAppendingString:@".m4a"]];
    });
}

- (void)secondViewWithModel:(LotteryNumberModel *)model
{
    if (![model.z2m isEqualToString:@"00"]) {
        if (self.index == 1) {
            self.index = 2;
            [self initNumberAnimateWithNo:model.z2m animal:model.z2sx index:2];
        }
        [self thirdViewWithModel:model];
    }
}

- (void)thirdViewWithModel:(LotteryNumberModel *)model
{
    if (![model.z3m isEqualToString:@"00"]) {
        if (self.index == 2) {
            self.index = 3;
            [self initNumberAnimateWithNo:model.z3m animal:model.z3sx index:3];
        }
        [self forthViewWithModel:model];
    }
}

- (void)forthViewWithModel:(LotteryNumberModel *)model
{
    if (![model.z4m isEqualToString:@"00"]) {
        if (self.index == 3) {
            self.index = 4;
            [self initNumberAnimateWithNo:model.z4m animal:model.z4sx index:4];
        }
        [self fifthViewWithModel:model];
    }
}

- (void)fifthViewWithModel:(LotteryNumberModel *)model
{
    if (![model.z5m isEqualToString:@"00"]) {
        if (self.index == 4) {
            self.index = 5;
            [self initNumberAnimateWithNo:model.z5m animal:model.z5sx index:5];
        }
        [self sixthViewWithModel:model];
    }
}

- (void)sixthViewWithModel:(LotteryNumberModel *)model
{
    if (![model.z6m isEqualToString:@"00"]) {
        if (self.index == 5) {
            self.index = 6;
            [self initNumberAnimateWithNo:model.z6m animal:model.z6sx index:6];
        }
        [self seventhViewWithModel:model];
    }
}

- (void)seventhViewWithModel:(LotteryNumberModel *)model
{
    if (![model.tm isEqualToString:@"00"]) {
        if (self.index == 6) {
            self.index = 7;
            [self initNumberAnimateWithNo:model.tm animal:model.tmsx index:7];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self endAnimation];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [NotificationCenter postNotificationName:LOTTERY_KJ_FINISHED object:nil];
                [self goBackVC];
            });
        }
    }
}
#pragma mark end 私有方法

#pragma mark - start 网络请求
- (void)getLotteryNumber
{
    __weak typeof(self) ws = self;
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [[NetworkManager shareManager] lotteryAnimateWithSuccess:^(NSDictionary *dict) {
        LotteryNumberModel *model = [LotteryNumberModel lotteryNumberWithDict:dict];
        if (ws.refreshing) {
            ws.refreshing = NO;
            ws.bqLab.text = [NSString stringWithFormat:@"第%@期", model.bq];
            CGFloat itemY = ws.numberBackgroundView.frame.origin.y + (ws.numberBackgroundView.frame.size.height - ws.itemHeight) * 0.5;
            CGFloat space = (CGRectGetWidth(ws.numberBackgroundView.frame) - 7 * ws.itemWidth - CGRectGetWidth(ws.addImageView.frame)) / 9;
            CGFloat originX = WIDTH(12);
            if ([model.z1m isEqualToString:@"00"]) { // 第1个号码
                [ws beginAniamtion];
                [ws playSoundStartPrize];
            }else {
                [ws courseAnimation];
                LotteryItem *item = [ws createLotteryNumber:model.z1m animal:model.z1sx];
                CGFloat itemX     = space + originX;
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 1;
            }
            if (![model.z2m isEqualToString:@"00"]) { // 第2个号码
                LotteryItem *item = [ws createLotteryNumber:model.z2m animal:model.z2sx];
                CGFloat itemX     = originX + space * 2 + ws.itemWidth;
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 2;
            }
            if (![model.z3m isEqualToString:@"00"]) { // 第3个号码
                LotteryItem *item = [ws createLotteryNumber:model.z3m animal:model.z3sx];
                CGFloat itemX     = originX + space * 3 + ws.itemWidth * 2;
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 3;
            }
            if (![model.z4m isEqualToString:@"00"]) { // 第4个号码
                LotteryItem *item = [ws createLotteryNumber:model.z4m animal:model.z4sx];
                CGFloat itemX     = originX + space * 4 + ws.itemWidth * 3;
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 4;
            }
            if (![model.z5m isEqualToString:@"00"]) { // 第5个号码
                LotteryItem *item = [ws createLotteryNumber:model.z5m animal:model.z5sx];
                CGFloat itemX     = originX + space * 5 + ws.itemWidth * 4;
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 5;
            }
            if (![model.z6m isEqualToString:@"00"]) { // 第6个号码
                LotteryItem *item = [ws createLotteryNumber:model.z6m animal:model.z6sx];
                CGFloat itemX     = originX + space * 6 + ws.itemWidth * 5;
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 6;
            }
            if (![model.tm isEqualToString:@"00"]) { // 第7个号码
                LotteryItem *item = [ws createLotteryNumber:model.tm animal:model.tmsx];
                CGFloat itemX     = originX + space * 8 + ws.itemWidth * 6 + WIDTH(20);
                item.frame        = CGRectMake(itemX, itemY, ws.itemWidth, ws.itemHeight);
                ws.index          = 7;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [ws endAnimation];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [NotificationCenter postNotificationName:LOTTERY_KJ_FINISHED object:nil];
                    [ws goBackVC];
                });
            }
        }else {
            if (![model.z1m isEqualToString:@"00"]) {
                if (ws.index == 0) {
                    ws.index = 1;
                    [self initNumberAnimateWithNo:model.z1m animal:model.z1sx index:1];
                }
                [self secondViewWithModel:model];
            }
        }
    } failure:^(NSString *error) {
    }];
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(getLotteryNumber)
                                                userInfo:nil repeats:YES];
    }
}
#pragma mark end 网络请求
@end
