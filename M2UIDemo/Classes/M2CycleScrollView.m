//
//  M2CycleScrollView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleScrollView.h"
@interface M2CycleScrollView()<UIScrollViewDelegate>{
    NSInteger       _itemsCountInPage;  // 每页内显示的item个数：本类是pagingEnabled类型，故本变量恒为1，不使用了常量或宏是为了本类M2CycleScrollSynchronizeProtocol中方法的实现与tabBarView中相应方法的实现保持一致；
    UIScrollView    *_scrollView;
    float           _itemWidth;
    NSInteger       _logicCount;        // 逻辑个数：如3个子界面（详情、评价、其他），本变量为3；
    NSInteger       _physicalCount;     // 物理个数：如3个子界面（详情、评价、其他），为了循环左右各扩充了一组，本变量为9；
    NSInteger       _selectedPhysicalIndex;     // 当前选中子界面的物理Index；
    BOOL            _isScrollFromSynchronizeMsg;// scroll消息来源： UIScrollViewDelegate的didScroll方法检查此值，若_isScrollFromSynchronizeMsg为YES，则判定didScroll是Synchronize消息导致的，自身不再通知SynchronizeObserver，防止循环通知；
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
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
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
    
    // 初始化items
    _contentViews = contentViews;
    _logicCount = [contentViews count];
    if (_logicCount <= 0) {
        return;
    }
    _physicalCount = _logicCount * 3;// TODO：扩充至3倍
    _itemWidth = CGRectGetWidth(_scrollView.bounds);
    _scrollView.contentSize = CGSizeMake(_itemWidth * _physicalCount, CGRectGetHeight(_scrollView.bounds));
    // 默认选中中间组逻辑index==0的item；
    _selectedPhysicalIndex = _logicCount;
    _scrollView.contentOffset = CGPointMake(_itemWidth * _selectedPhysicalIndex, 0);
    [self prepareItemsAtPhysicalIndex:_selectedPhysicalIndex];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 如果didScroll是Synchronize消息导致的，不再通知自身的synchronizeObserver，防止循环通知；
    if (!_isScrollFromSynchronizeMsg && _synchronizeObserver && [_synchronizeObserver respondsToSelector:@selector(view:didScrollOffsetX:itemWidth:itemsCountPerPage:)]) {
        [_synchronizeObserver view:self didScrollOffsetX:scrollView.contentOffset.x itemWidth:_itemWidth itemsCountPerPage:1];
    }
    // 本次didScroll结束，flag弹回NO；
    _isScrollFromSynchronizeMsg = NO;
    
    NSInteger curPhysicalIndex = [self physicalIndexWhenOffsetX:scrollView.contentOffset.x];
    if (curPhysicalIndex == _selectedPhysicalIndex) {
        return;
    }
//    NSLog(@"~~physicalIndex从(%d)变为(%d)  @@%s", _selectedPhysicalIndex, curPhysicalIndex, __func__);
    
    float offsetX = scrollView.contentOffset.x;
    BOOL isNeedModifyOffset = NO;
    // ((_itemsCountInPage - 1) / 2)是计算页内中间item一侧的item个数，这个写法是适应业内项数是奇数或偶数；
    // 如果限制为只能为技术，则((_itemsCountInPage - 1) / 2)可改写为(_itemsCountInPage / 2)，更容易理解；
    if (curPhysicalIndex - ((_itemsCountInPage - 1) / 2) == 0) {
//        NSLog(@"( 到达左边缘  @@%s", __func__);
        curPhysicalIndex += _logicCount;
        offsetX += _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
    }else if (curPhysicalIndex + ((_itemsCountInPage - 1) / 2) == _physicalCount){
//        NSLog(@") 到达右边缘  @@%s", __func__);
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
    // 因为调用本方法前offset已经调整到了合适的位置，physicalIndex加减1不会越界；
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
// offset同步通知，接到通知后，修改自己的offset，与目标offset保持一致；
- (void)view:(UIView *)view didScrollOffsetX:(float)offsetX itemWidth:(float)itemWidth itemsCountPerPage:(NSInteger)itemsCountPerPage{
//    NSLog(@")))scrollView接到同步通知offsetX(%f)  @@%s", offsetX, __func__);
    _isScrollFromSynchronizeMsg = YES;
    NSInteger deltaCount = ((_itemsCountInPage - 1) / 2) - ((itemsCountPerPage - 1) / 2);
    float myOffsetX = offsetX * (_itemWidth / itemWidth) - (_itemWidth * deltaCount);
    [_scrollView setContentOffset:CGPointMake(myOffsetX, 0)];
}

@end
