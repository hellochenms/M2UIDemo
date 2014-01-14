//
//  M2ImageGalleryView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2GalleryViewDataSource;

@interface M2GalleryView : UIView
@property (nonatomic, weak) id<M2GalleryViewDataSource> datasource;
@end

@protocol M2GalleryViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsInGalleryView:(M2GalleryView *)galleryView;
- (UIView *)galleryView:(M2GalleryView *)galleryView itemAtIndex:(NSInteger)index;
@end