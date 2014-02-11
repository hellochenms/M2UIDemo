//
//  M2SimpleGalleryView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A；
//  版本：1.0；
//  配套：M2SimpleGalleryViewCell；

#import <UIKit/UIKit.h>
#import "M2SimpleGalleryViewCell.h"

@protocol M2SimpleGalleryViewDataSource;
@protocol M2SimpleGalleryViewDelegate;

@interface M2SimpleGalleryView_A : UIView
- (id)initWithFrame:(CGRect)frame itemWidth:(float)itemWidth;
@property (nonatomic, weak)     id<M2SimpleGalleryViewDataSource>   dataSource;
@property (nonatomic, weak)     id<M2SimpleGalleryViewDelegate>     delegete;
- (void)reloadData;
@end

@protocol M2SimpleGalleryViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInGalleryView:(M2SimpleGalleryView_A *)galleryView;
- (M2SimpleGalleryViewCell *)galleryView:(M2SimpleGalleryView_A *)galleryView itemAtIndex:(NSInteger)index;
@end

@protocol M2SimpleGalleryViewDelegate <NSObject>
- (void)galleryView:(M2SimpleGalleryView_A *)galleryView didSelectedItemAtIndex:(NSInteger)index;
@end