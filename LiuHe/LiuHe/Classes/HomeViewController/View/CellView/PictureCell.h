//
//  PictureCell.h
//  LiuHe
//
//  Created by huxingqin on 2016/12/6.
//  Copyright © 2016年 huxingqin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PictureCell;
@protocol PictureCellDelegate <NSObject>

@optional
- (void)pictureCell:(PictureCell *)cell didClickWithImageView:(UIImageView *)imageView originFrame:(CGRect)originFrame;

@end

@interface PictureCell : UICollectionViewCell

@property (nonatomic, weak) id <PictureCellDelegate> delegate;

- (void)setImageWithUrl:(NSString *)imageUrl;

@end
