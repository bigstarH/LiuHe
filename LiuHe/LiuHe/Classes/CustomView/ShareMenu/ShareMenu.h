//
//  ShareMenu.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/6.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareMenuItemType) {
    ShareMenuItemTypeWeChat         = 0, /**< 微信 */
    ShareMenuItemTypeWechatTimeLine = 1, /**< 朋友圈 */
    ShareMenuItemTypeQQ             = 2, /**< QQ */
    ShareMenuItemTypeQZone          = 3  /**< QQ空间 */
};

@class ShareMenu;
@protocol ShareMenuDelegate <NSObject>
/**
 *  点击了第几个菜单项
 */
- (void)shareMenu:(ShareMenu *)shareMenu didSelectMenuItemWithType:(ShareMenuItemType)type;

@end

@interface ShareMenu : UIView

@property (nonatomic, weak) id <ShareMenuDelegate> delegate;

+ (instancetype)shareMenu;

- (void)show;

@end
