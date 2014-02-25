//
//  M2CycleScrollView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleScrollView.h"
@interface M2CycleScrollView()<UIScrollViewDelegate>{
    UIScrollView    *_scrollView;
    NSInteger       _curPhysicalIndex;
    float           _lastOffsetX;
}
@end

@implementation M2CycleScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    
    return self;
}

- (void)setContentViews:(NSArray *)contentViews{
    // clear
    UIView *oldItem = nil;
    for (oldItem in _contentViews) {
        [oldItem removeFromSuperview];
    }
    _contentViews = nil;
    _scrollView.contentSize = CGSizeZero;
    _scrollView.contentOffset = CGPointZero;
    
    // build
    _contentViews = contentViews;
    NSInteger itemCount = [contentViews count];
    if (itemCount <= 0) {
        return;
    }
    // 队首队尾各扩展一个item位置
    NSInteger physicalCount = itemCount + 2;
    float itemWidth = CGRectGetWidth(_scrollView.bounds);
    _scrollView.contentSize = CGSizeMake(itemWidth * physicalCount, CGRectGetHeight(_scrollView.bounds));
    // 初始时，选中逻辑上首个item（扩展后其index==1）
    _curPhysicalIndex = 1;//TODO
    _lastOffsetX = itemWidth;
    _scrollView.contentOffset = CGPointMake(itemWidth, 0);
    [self prepareItemsAtPhysicalIndex:_curPhysicalIndex];
}

#pragma mark -
- (void)prepareItemsAtPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger curLogicIndex = [self logicIndexByPhysicalIndex:physicalIndex];
    UIView *curItem = [_contentViews objectAtIndex:curLogicIndex];
    curItem.frame = CGRectMake(CGRectGetWidth(_scrollView.bounds) * physicalIndex, 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
    [_scrollView addSubview:curItem];
    
    // preView
    NSInteger prePhysicalIndex = physicalIndex - 1;
    NSInteger preLogicIndex = [self logicIndexByPhysicalIndex:prePhysicalIndex];
    UIView *preItem = [_contentViews objectAtIndex:preLogicIndex];
    preItem.frame = CGRectMake(CGRectGetMinX(curItem.frame) - CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
    [_scrollView addSubview:preItem];
    
    // nextView
    NSInteger nextPhisicalIndex = physicalIndex + 1;
    NSInteger nextLogicIndex = [self logicIndexByPhysicalIndex:nextPhisicalIndex];
    UIView *nextItem = [_contentViews objectAtIndex:nextLogicIndex];
    nextItem.frame = CGRectMake(CGRectGetMinX(curItem.frame) + CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
    [_scrollView addSubview:nextItem];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"~开始拖动 scrollView.contentOffset.x(%f) @@%s", scrollView.contentOffset.x, __func__);
    _lastOffsetX = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger curPhysicalIndex = [self physicalIndexWhenOffsetX:scrollView.contentOffset.x];
    if (curPhysicalIndex == _curPhysicalIndex) {
        return;
    }
    
    float offsetX = scrollView.contentOffset.x;
    NSInteger logicCount = [_contentViews count];
    NSInteger physicalCount = logicCount + 2;
    float itemWidth = CGRectGetWidth(_scrollView.bounds);
    if (curPhysicalIndex == 0 && curPhysicalIndex - _curPhysicalIndex < 0) {
        curPhysicalIndex += logicCount;
        offsetX += itemWidth * logicCount;
    }else if (curPhysicalIndex == physicalCount - 1 && curPhysicalIndex - _curPhysicalIndex > 0){
        curPhysicalIndex -= logicCount;
        offsetX -= itemWidth * logicCount;
    }
    
//    NSLog(@"physicalIndex从(%d)变为(%d)  @@%s", _curPhysicalIndex, curPhysicalIndex, __func__);
    _curPhysicalIndex = curPhysicalIndex;
    
    BOOL isSwipeToLeft = NO;
    float delta = offsetX - _lastOffsetX;
//    NSLog(@"_lastOffsetX(%f) cur(%f)  @@%s", _lastOffsetX, offsetX, __func__);
    float absDeleta = fabs(delta);
    float threshold = itemWidth * 1.5;
    if ((delta > 0 && absDeleta < threshold)
        || (delta < 0 && absDeleta > threshold)) {
        isSwipeToLeft = YES;
    }else{
        isSwipeToLeft = NO;
    }
    NSLog(@"%@  @@%s", (isSwipeToLeft ? @"向左滑" : @"向右滑"), __func__);
    
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollView:changedCurIndexWithIsToNext:)]) {
        [_delegate cycleScrollView:self changedCurIndexWithIsToNext:isSwipeToLeft];
    }
    
    
    [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    [self prepareItemsAtPhysicalIndex:_curPhysicalIndex];
    _lastOffsetX = scrollView.contentOffset.x;
}

#pragma mark - setter/getter
- (NSInteger)curLogicIndex{
    return [self logicIndexByPhysicalIndex:_curPhysicalIndex];
}
- (void)setCurLogicIndex:(NSInteger)curIndex{
    // 外界设置的curIndex是面向_contentViews的，面向scrollView时要映射一下；
    // 外界设置值时我们会定位到非扩展item（即[1, realCount - 2]这个范围），故映射时index加1即可；
    _curPhysicalIndex = curIndex + 1;
    float offsetX = CGRectGetWidth(_scrollView.bounds) * _curPhysicalIndex;
    _lastOffsetX = offsetX;
    [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    [self prepareItemsAtPhysicalIndex:_curPhysicalIndex];
}

#pragma mark -
- (NSInteger)logicIndexByPhysicalIndex:(NSInteger)index{
    NSInteger logicCount = [_contentViews count];
    
    return ((index - 1) + logicCount) % logicCount;
}
- (NSInteger)physicalIndexWhenOffsetX:(float)offsetX{
    float itemWidth = CGRectGetWidth(_scrollView.bounds);
    float quotient = offsetX / itemWidth;
    NSInteger index = (NSInteger)quotient;
    float remainder = offsetX - itemWidth * index;
    if (remainder / itemWidth >= 0.5) {
        index++;
    }
    
    return index;
}

@end
