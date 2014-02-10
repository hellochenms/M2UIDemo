//
//  M2SimpleGalleryView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2SimpleGalleryView.h"
#import "M2SimpleGalleryViewCell.h"

#define M2SGVA_ContainerTag       6000
#define M2SGVA_ItemTag            7000
#define M2SGVA_AnimationDuration  0.25

@interface M2SimpleGalleryView()<M2GalleryViewCellDelegate, UIScrollViewDelegate>{
    float           _itemWidth;
    NSMutableArray  *_itemContainers;
    UIScrollView    *_mainView;
}
@end

@implementation M2SimpleGalleryView

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame itemWidth:CGRectGetWidth(frame)];
}

- (id)initWithFrame:(CGRect)frame itemWidth:(float)itemWidth{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemWidth = itemWidth;
        _itemContainers = [NSMutableArray array];
        
        // self
        self.clipsToBounds = YES;
        
        // scroll view
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.delegate = self;
        [self addSubview:_mainView];
        
        // init
        [self performSelector:@selector(reloadData) withObject:nil afterDelay:0];
    }
    return self;
}

#pragma mark - public
- (void)reloadData{
    // clear old
    UIView *oldItemContainer = nil;
    for (oldItemContainer in _itemContainers) {
        [oldItemContainer removeFromSuperview];
    }
    [_itemContainers removeAllObjects];
    _mainView.contentSize = CGSizeMake(0, CGRectGetHeight(_mainView.frame));
    
    // check
    if (!_dataSource
        || ![_dataSource respondsToSelector:@selector(numberOfItemsInGalleryView:)]
        || ![_dataSource respondsToSelector:@selector(galleryView:itemAtIndex:)]) {
        return;
    }
    NSInteger count = [_dataSource numberOfItemsInGalleryView:self];
    if (count <= 0) {
        return;
    }
    
    // build new
    UIView *newItemContainer = nil;
    float containerWidth = _itemWidth;
    float containerHeight = CGRectGetHeight(_mainView.bounds);
    M2SimpleGalleryViewCell *item = nil;
    for (NSInteger i = 0; i < count; i++) {
        // container
        newItemContainer = [[UIView alloc] initWithFrame: CGRectMake(containerWidth * i, 0, containerWidth, containerHeight)];
        newItemContainer.clipsToBounds = YES;
        newItemContainer.tag = M2SGVA_ContainerTag + i;
        [_mainView addSubview:newItemContainer];
        [_itemContainers addObject:newItemContainer];
        // item
        item = [_dataSource galleryView:self itemAtIndex:i];
        item.delegate = self;
        item.tag = M2SGVA_ItemTag;
        // 调整item frame
        [self modifyFrameOfItem:item];
        [self tryTransformOfItem:item];
        [newItemContainer addSubview:item];
    }
    
    //
    _mainView.contentSize = CGSizeMake(CGRectGetMaxX(newItemContainer.frame), CGRectGetHeight(_mainView.frame));
}

#pragma mark - M2GalleryViewCellDelegate
- (void)didLoadImageFinishByCell:(M2SimpleGalleryViewCell *)cell{
    UIView *container = nil;
    M2SimpleGalleryViewCell *item = nil;
    for (container in _itemContainers) {
        item = (M2SimpleGalleryViewCell *)[container viewWithTag:M2SGVA_ItemTag];
        if (item == cell) {
            [self modifyFrameOfItem:item];
            [self tryTransformOfItem:item];
            break;
        }
    }
}

#pragma mark - item frame transform 的调整
// 根据图片宽高比调整item frame
- (void)modifyFrameOfItem:(M2SimpleGalleryViewCell *)item{
//    NSLog(@"%@  @@%s", NSStringFromCGSize(item.image.size), __func__);
    float widthHeightFactor = 1;
    if (item.image.size.width <= 0 || item.image.size.height <= 0) {
        widthHeightFactor = 1;
    }else{
        widthHeightFactor = item.image.size.width / item.image.size.height;
    }
    float itemWidth = 0;
    float itemHeight = 0;
    float containerWidth = _itemWidth;
    float containerHeight = CGRectGetHeight(_mainView.bounds);
    if (widthHeightFactor <= 1) {
        itemWidth = containerWidth;
        itemHeight = containerHeight;
    }else{
        itemWidth = containerHeight;
        itemHeight = containerWidth;
    }
    item.frame = CGRectMake((itemWidth - containerWidth) / 2 * (-1), 0, itemWidth, itemHeight);
    [item didChangedCellFrame];
}
// 横屏图片要有旋转处理
- (void)tryTransformOfItem:(M2SimpleGalleryViewCell *)item{
    float itemWidth = CGRectGetWidth(item.bounds);
    float itemHeight = CGRectGetHeight(item.bounds);
    if (itemWidth <= itemHeight) {
        return;
    }
    float centerYModifier = (itemWidth - itemHeight) / 2;
    CGAffineTransform transform = item.transform;
    transform = CGAffineTransformTranslate(transform, 0, centerYModifier);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    item.transform = transform;
}

@end
