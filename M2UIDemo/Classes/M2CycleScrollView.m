//
//  M2CycleScrollView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleScrollView.h"
@interface M2CycleScrollView()<UIScrollViewDelegate>{
    UIScrollView    *_scrollView;
    float           _itemWidth;
    NSInteger       _itemsCountInPage;
    NSInteger       _logicCount;
    NSInteger       _physicalCount;
    NSInteger       _selectedPhysicalIndex;
    BOOL            _isScrollFromSynchronizeMsg;
}
@end

@implementation M2CycleScrollView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _itemsCountInPage = 1;

        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
//        _scrollView.showsHorizontalScrollIndicator = NO;
//        _scrollView.showsVerticalScrollIndicator = NO;
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
    
    // 初始化items
    _contentViews = contentViews;
    _logicCount = [contentViews count];
    if (_logicCount <= 0) {
        return;
    }
    _physicalCount = _logicCount * 3;
    _itemWidth = CGRectGetWidth(_scrollView.bounds);
    _scrollView.contentSize = CGSizeMake(_itemWidth * _physicalCount, CGRectGetHeight(_scrollView.bounds));
    // 选中的第一个逻辑item
    _selectedPhysicalIndex = _logicCount;
    _scrollView.contentOffset = CGPointMake(_itemWidth * _selectedPhysicalIndex, 0);
    [self prepareItemsAtPhysicalIndex:_selectedPhysicalIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_isScrollFromSynchronizeMsg && _synchronizeObserver && [_synchronizeObserver respondsToSelector:@selector(view:didScrollOffsetX:itemWidth:itemsCountPerPage:)]) {
        [_synchronizeObserver view:self didScrollOffsetX:scrollView.contentOffset.x itemWidth:_itemWidth itemsCountPerPage:1];
    }
    _isScrollFromSynchronizeMsg = NO;
    
    NSInteger curPhysicalIndex = [self physicalIndexWhenOffsetX:scrollView.contentOffset.x];
    if (curPhysicalIndex == _selectedPhysicalIndex) {
        return;
    }
//    NSLog(@"~~physicalIndex从(%d)变为(%d)  @@%s", _selectedPhysicalIndex, curPhysicalIndex, __func__);
    
    //
    float offsetX = scrollView.contentOffset.x;
    BOOL isNeedModifyOffset = NO;
//    if (curPhysicalIndex == 0) {
    if (curPhysicalIndex - ((_itemsCountInPage - 1) / 2) == 0) {
        NSLog(@"( 到达左边缘  @@%s", __func__);
        curPhysicalIndex += _logicCount;
        offsetX += _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
//    }else if (curPhysicalIndex == _physicalCount - 1){
    }else if (curPhysicalIndex + ((_itemsCountInPage - 1) / 2) == _physicalCount){
        NSLog(@") 到达右边缘  @@%s", __func__);
        curPhysicalIndex -= _logicCount;
        offsetX -= _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
    }
    [self prepareItemsAtPhysicalIndex:curPhysicalIndex];
    _selectedPhysicalIndex = curPhysicalIndex;
    if (isNeedModifyOffset) {
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollView:didSelectedAtIndex:)]) {
        [_delegate cycleScrollView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(cycleScrollView:didSelectedAtIndex:)]) {
        [_delegate cycleScrollView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}


#pragma mark - 准备目标view及左、右view
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

#pragma mark - index换算
- (NSInteger)logicIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger logicIndex = physicalIndex % ([_contentViews count]);
    return logicIndex;
}

#pragma mark - 计算index
- (NSInteger)physicalIndexWhenOffsetX:(float)offsetX{
    float quotient = offsetX / _itemWidth;
    NSInteger index = (NSInteger)quotient;
    float remainder = offsetX - _itemWidth * index;
    if (remainder / _itemWidth >= 0.5) {
        index++;
    }
    return index;
}

#pragma mark - M2CycleScrollSynchronizeProtocol
- (void)view:(UIView *)view didScrollOffsetX:(float)offsetX itemWidth:(float)itemWidth itemsCountPerPage:(NSInteger)itemsCountPerPage{
//    NSLog(@")))scrollView接到同步通知offsetX(%f)  @@%s", offsetX, __func__);
    _isScrollFromSynchronizeMsg = YES;
    NSInteger deltaCount = ((_itemsCountInPage - 1) / 2) - ((itemsCountPerPage - 1) / 2);
    float myOffsetX = offsetX * (_itemWidth / itemWidth) - (_itemWidth * deltaCount);
    [_scrollView setContentOffset:CGPointMake(myOffsetX, 0)];
}


@end
