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

@interface M2SimpleGalleryView : UIView
- (id)initWithFrame:(CGRect)frame itemWidth:(float)itemWidth;
@property (nonatomic, weak)     id<M2SimpleGalleryViewDataSource> dataSource;
- (void)reloadData;
@end

@protocol M2SimpleGalleryViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInGalleryView:(M2SimpleGalleryView *)galleryView;
- (M2SimpleGalleryViewCell *)galleryView:(M2SimpleGalleryView *)galleryView itemAtIndex:(NSInteger)index;
@end