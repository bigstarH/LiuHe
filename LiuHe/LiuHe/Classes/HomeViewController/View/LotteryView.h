//
//  LotteryView.h
//  LiuHe
//
//  Created by huxingqin on 2016/11/29.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LotteryNumberModel.h"

@interface LotteryItem : UIView

@property (nonatomic, weak) UIImageView *bgImageView;

@property (nonatomic, weak) UILabel *numberLab;

@property (nonatomic, weak) UILabel *animalLab;

- (void)selectBgImageWithNumber:(NSString *)number;

@end

@interface LotteryView : UIView

@property (nonatomic, strong) LotteryNumberModel *model;

@end
