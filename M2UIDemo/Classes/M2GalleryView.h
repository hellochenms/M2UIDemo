//
//  M2ImageGalleryView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：B；
//  版本：1.0；
//  配套：M2GalleryViewCell；

#import <UIKit/UIKit.h>

@class M2GalleryViewCell;

@protocol M2GalleryViewDataSource;

@interface M2GalleryView : UIView
- (id)initWithFrame:(CGRect)frame withFullScreenHeight:(float)fullScreenHeight;
@property (nonatomic, weak) id<M2GalleryViewDataSource> datasource;
// pageControl属性被设置时，会自动将pageControl addSubView到self上；
@property (nonatomic)       UIPageControl               *pageControl;
@end

@protocol M2GalleryViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInGalleryView:(M2GalleryView *)galleryView;
- (M2GalleryViewCell *)galleryView:(M2GalleryView *)galleryView itemAtIndex:(NSInteger)index;
@end