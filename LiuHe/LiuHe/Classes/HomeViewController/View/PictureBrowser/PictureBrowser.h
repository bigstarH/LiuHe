//
//  PictureBrowser.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/7.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureBrowser;
@protocol PictureBrowserDelegate <NSObject>

- (void)pictureBrowser:(PictureBrowser *)browser didClickItemAtIndex:(NSInteger)index;

@end

/** 图片浏览器 */
@interface PictureBrowser : UIView

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, weak) id <PictureBrowserDelegate> delegate;

@property (nonatomic) CGRect originFrame;

+ (instancetype)pictureBrowser:(NSArray *)imageUrls;

- (void)hideCollectionView:(BOOL)isHidden;


@end
