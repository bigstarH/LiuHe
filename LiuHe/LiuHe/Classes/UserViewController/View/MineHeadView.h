//
//  MineHeadView.h
//  Text
//
//  Created by huxingqin on 2016/11/22.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineHeadView;
@protocol MineHeadViewDelegate <NSObject>

@optional
/**
 *  头像被点击
 */
- (void)mineHeadView:(MineHeadView *)header didLogin:(BOOL)login;

- (void)modifyUserInfoWithMineHeadView:(MineHeadView *)header;

@end

@interface MineHeadView : UIView

@property (nonatomic, weak) UIImageView *headView;

@property (nonatomic, weak) UILabel *userLab;

@property (nonatomic, weak) UILabel *integralLab;

@property (nonatomic, weak) UILabel *gradeLab;

@property (nonatomic, weak) id <MineHeadViewDelegate> delegate;

@end
