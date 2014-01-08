//
//  M2ImageGallery.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2ImageGalleryViewDelegate;

@interface M2ImageGalleryView : UIView
@property (nonatomic) BOOL isLandscape;
@property (nonatomic, weak) id<M2ImageGalleryViewDelegate> delegate;
- (void)reloadDataWithImages:(NSArray *)images;
@end

@protocol M2ImageGalleryViewDelegate <NSObject>
- (void)galleryView:(M2ImageGalleryView *)galleryView
  willChangeIsFullScreen:(BOOL)IsFullScreen
   withAnimationDuration:(int)animationDuration;
@end