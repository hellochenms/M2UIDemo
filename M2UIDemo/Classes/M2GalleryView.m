//
//  M2ImageGalleryView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2GalleryView.h"

@interface M2GalleryView(){
    NSMutableArray  *_itemContainers;
    UIScrollView    *_mainView;
}
@end

@implementation M2GalleryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemContainers = [NSMutableArray array];
        
        //
        self.clipsToBounds = YES;
        
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        [self addSubview:_mainView];
        
        //
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
    }
    return self;
}

- (void)reloadData{
    NSLog(@"  @@%s", __func__);
    
    // clear old
    UIView *oldItemContainer = nil;
    for (oldItemContainer in _itemContainers) {
        [oldItemContainer removeFromSuperview];
        [_itemContainers removeObject:oldItemContainer];
    }
    
    // check
    if (!_datasource
        || ![_datasource respondsToSelector:@selector(numberOfItemsInGalleryView:)]
        || ![_datasource respondsToSelector:@selector(galleryView:itemAtIndex:)]) {
        return;
    }
    
    // build new
    NSInteger count = [_datasource numberOfItemsInGalleryView:self];
    UIView *newItemContainer = nil;
    float containerWidth = CGRectGetWidth(_mainView.bounds);
    float containerHeight = CGRectGetHeight(_mainView.bounds);
    UIView *item = nil;
    for (NSInteger i = 0; i < count; i++) {
        // container
        newItemContainer = [[UIView alloc] initWithFrame: CGRectMake(containerWidth * i, 0, containerWidth, containerHeight)];
        newItemContainer.clipsToBounds = YES;
        [_mainView addSubview:newItemContainer];
        [_itemContainers addObject:newItemContainer];
        
        // item
        item = [_datasource galleryView:self itemAtIndex:i];
        item.frame = newItemContainer.bounds;
        [newItemContainer addSubview:item];
    }
    
    //
    _mainView.contentSize = CGSizeMake(CGRectGetMaxX(newItemContainer.frame), CGRectGetHeight(_mainView.frame));
}


@end
