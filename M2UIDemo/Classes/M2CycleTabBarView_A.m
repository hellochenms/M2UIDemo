//
//  M2CycleTabBarView_A.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleTabBarView_A.h"

#define M2CTBV_ItemTagOffset 6000

@interface M2CycleTabBarView_A()<UIScrollViewDelegate>{
    UIScrollView    *_scrollView;
    float           _itemWidth;
    
    NSArray         *_titles;
    NSInteger       _itemsCountInPage;
    
    NSInteger       _logicCount;
    NSInteger       _extraCountEachSide;
    NSInteger       _physicalCount;
    NSMutableArray  *_physicalItems;
    
    NSInteger       _curPhysicalIndex;
}
@end

@implementation M2CycleTabBarView_A

- (id)initWithFrame:(CGRect)frame itemsCountInPage:(NSInteger)itemsCountInPage titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // check
        if ([titles count] <=0 || [titles count] < itemsCountInPage) {
            NSLog(@"参数错误  @@%s", __func__);
            return self;
        }
        
        // 参数
        _logicCount = [titles count];
        _itemsCountInPage = itemsCountInPage;
        if (_itemsCountInPage % 2 == 0) {// TODO:暂时只支持奇数个元素可见
            _itemsCountInPage -= 1;
        }
        _titles = titles;
        
        // UI
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _extraCountEachSide = _itemsCountInPage / 2 + 1;
        _physicalCount = _logicCount + _extraCountEachSide * 2;
        
        _physicalItems = [NSMutableArray arrayWithCapacity:_physicalCount];
        UIView *item = nil;
        _itemWidth = CGRectGetWidth(_scrollView.bounds) / _itemsCountInPage;
        float itemHeight = CGRectGetHeight(_scrollView.bounds);
        for (NSInteger i = 0; i < _physicalCount; i++) {
            item = [self itemWithPhysicalIndex:i];
            item.frame = CGRectMake(_itemWidth * i, 0, _itemWidth, itemHeight);
            [_scrollView addSubview:item];
            [_physicalItems addObject:item];
        }
        
        _curPhysicalIndex = 1;//TODO
        _scrollView.contentSize = CGSizeMake(_itemWidth * _physicalCount, CGRectGetHeight(_scrollView.bounds));
        [_scrollView setContentOffset:CGPointMake(_itemWidth, 0)];
    }
    
    return self;
}

#pragma mark - 定制item样式
- (UIView*)itemWithPhysicalIndex:(NSInteger)physicalIndex{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:[_titles objectAtIndex:[self logicIndexByPhysicalIndex:physicalIndex]] forState:UIControlStateNormal];
    button.tag = physicalIndex + M2CTBV_ItemTagOffset;
    [button addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - tap item
- (void)onTapItem:(UIButton *)sender{
    NSInteger physicalIndex = sender.tag - M2CTBV_ItemTagOffset;
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:physicalIndex]];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger physicalIndex = [self indexWhenOffsetX:scrollView.contentOffset.x];
    if (physicalIndex == _curPhysicalIndex) {
        return;
    }
    
    float offsetX = scrollView.contentOffset.x;
    if (physicalIndex == 0 && physicalIndex - _curPhysicalIndex < 0) {
        physicalIndex += _logicCount;
        offsetX += _itemWidth * _logicCount;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }else if (physicalIndex + _itemsCountInPage == _physicalCount && physicalIndex - _curPhysicalIndex > 0){
        physicalIndex -= _logicCount;
        offsetX -= _itemWidth * _logicCount;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }
    _curPhysicalIndex = physicalIndex;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_curPhysicalIndex]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:_curPhysicalIndex];
    }
}

#pragma mark -
- (NSInteger)logicIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger logicIndex = (physicalIndex - _extraCountEachSide + _logicCount) % _logicCount;
    return logicIndex;
}
- (NSInteger)indexWhenOffsetX:(float)offsetX{
    float quotient = offsetX / _itemWidth;
    NSInteger index = (NSInteger)quotient;
    float remainder = offsetX - _itemWidth * index;
    if (remainder / _itemWidth >= 0.5) {
        index++;
    }
    return index;
}

@end