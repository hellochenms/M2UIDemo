//
//  M2ImageGalleryView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2GalleryView.h"
#import "M2GalleryViewCell.h"

#define M2GV_ContainerTag       6000
#define M2GV_ItemTag            7000
#define M2GV_AnimationDuration  0.25

@interface M2GalleryView()<M2GalleryViewCellDelegate, UIScrollViewDelegate>{
    NSMutableArray  *_itemContainers;
    UIScrollView    *_mainView;
    BOOL            _isFullScreen;
    NSInteger       _curIndex;
}
@end

@implementation M2GalleryView

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame withFullScreenHeight:CGRectGetHeight(frame)];
}

- (id)initWithFrame:(CGRect)frame withFullScreenHeight:(float)fullScreenHeight{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemContainers = [NSMutableArray array];
        
        // self
        _originHeight = CGRectGetHeight(frame);
        _fullScreenHeight = fullScreenHeight;
        self.clipsToBounds = YES;
        
        // scroll view
        _mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), _fullScreenHeight)];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.pagingEnabled = YES;
        _mainView.delegate = self;
        [self addSubview:_mainView];
        
        // event
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [_mainView addGestureRecognizer:tap];
        
        //
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
    
    // pageControl
    if (_pageControl) {
        _pageControl.numberOfPages = count;
    }
    
    // build new
    UIView *newItemContainer = nil;
    float containerWidth = CGRectGetWidth(_mainView.bounds);
    float containerHeight = _fullScreenHeight;
    M2GalleryViewCell *item = nil;
    for (NSInteger i = 0; i < count; i++) {
        // container
        newItemContainer = [[UIView alloc] initWithFrame: CGRectMake(containerWidth * i, 0, containerWidth, containerHeight)];
        newItemContainer.clipsToBounds = YES;
        newItemContainer.tag = M2GV_ContainerTag + i;
        [_mainView addSubview:newItemContainer];
        [_itemContainers addObject:newItemContainer];
        
        // item
        item = [_dataSource galleryView:self itemAtIndex:i];
        item.delegate = self;
        item.tag = M2GV_ItemTag;
        // 调整item frame
        [self modifyFrameOfItem:item];
        [newItemContainer addSubview:item];
    }
    
    //
    _mainView.contentSize = CGSizeMake(CGRectGetMaxX(newItemContainer.frame), CGRectGetHeight(_mainView.frame));
}

#pragma mark - tap event
- (void)onTap:(UIGestureRecognizer*)tap{
    _isFullScreen = !_isFullScreen;
    
    // delegate
    if (_delegate && [_delegate respondsToSelector:@selector(galleryView:willChangeIsFullScreen:withAnimationDuration:)]) {
        [_delegate galleryView:self willChangeIsFullScreen:_isFullScreen withAnimationDuration:M2GV_AnimationDuration];
    }
    
    // self
    CGRect frame = self.frame;
    frame.size.height = (_isFullScreen ? _fullScreenHeight : _originHeight);
    __weak M2GalleryView *weakSelf = self;
    [UIView animateWithDuration:M2GV_AnimationDuration
                     animations:^{
                         weakSelf.frame = frame;
                     }];
    // item
    UIView *container = nil;
    M2GalleryViewCell *item = nil;
    for (container in _itemContainers) {
        item = (M2GalleryViewCell *)[container viewWithTag:M2GV_ItemTag];
        if (item.isDidLoadImageFinish) {
            [self tryTransformOfItem: item byIsFullScreen: _isFullScreen animated:(container.tag - M2GV_ContainerTag) == _curIndex];
        }
    }
}

#pragma mark - M2GalleryViewCellDelegate
- (void)didLoadImageFinishByCell:(M2GalleryViewCell *)cell{
    UIView *container = nil;
    M2GalleryViewCell *item = nil;
    for (container in _itemContainers) {
        item = (M2GalleryViewCell *)[container viewWithTag:M2GV_ItemTag];
        if (item == cell) {
            item.transform = CGAffineTransformIdentity;
            [self modifyFrameOfItem:item];
            [self tryTransformOfItem:item byIsFullScreen:_isFullScreen animated:NO];
            break;
        }
    }
}

#pragma mark - item frame transform 的调整
// 根据图片宽高比调整item frame
- (void)modifyFrameOfItem:(M2GalleryViewCell *)item{
//    NSLog(@"%@  @@%s", NSStringFromCGSize(item.image.size), __func__);
    float widthHeightFactor = 1;
    if (item.image.size.width <= 0 || item.image.size.height <= 0) {
        widthHeightFactor = 1;
    }else{
        widthHeightFactor = item.image.size.width / item.image.size.height;
    }
    float itemWidth = 0;
    float itemHeight = 0;
    float containerWidth = CGRectGetWidth(_mainView.bounds);
    float containerHeight = _fullScreenHeight;
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

// 如果是横屏图片，点击全屏时要有旋转处理
- (void)tryTransformOfItem:(M2GalleryViewCell *)item byIsFullScreen:(BOOL)isFullScreen animated:(BOOL)animated{
    float itemWidth = CGRectGetWidth(item.bounds);
    float itemHeight = CGRectGetHeight(item.bounds);
    if (itemWidth <= itemHeight) {
        return;
    }
    float centerYModifier = (itemWidth - itemHeight) / 2;
    CGAffineTransform transform = item.transform;
    if (isFullScreen) {
        transform = CGAffineTransformTranslate(transform, 0, centerYModifier);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    }else{
        transform = CGAffineTransformIdentity;
    }
    
    // 只要用户点击时，当前图片有旋转动画，其他情况都无动画
    if (animated) {
        [UIView animateWithDuration:M2GV_AnimationDuration
                         animations:^{
                             item.transform = transform;
                         }];
    }else{
        item.transform = transform;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _curIndex = floorf((scrollView.contentOffset.x + 5) / CGRectGetWidth(scrollView.bounds));
    if (_pageControl) {
        _pageControl.currentPage = _curIndex;
    }
}

#pragma mark - pageControl
- (void)setPageControl:(UIPageControl *)pageControl{
    if (pageControl.superview) {
        return;
    }
    // clear old
    [_pageControl removeFromSuperview];
    
    // build new
    _pageControl = pageControl;
    CGRect frame = _pageControl.frame;
    if (CGRectIsEmpty(frame)) {
        frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30);
        _pageControl.frame = frame;
    }
    [self addSubview:_pageControl];
}

@end
