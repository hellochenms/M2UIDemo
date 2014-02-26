//
//  M2CycleTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleTabBarView.h"

#define M2CTBV_ItemTagOffset 6000

@interface M2CycleTabBarView()<UIScrollViewDelegate>{
    NSInteger       _itemsCountInPage;// 每页内显示的item个数；
    UIScrollView    *_scrollView;
    float           _itemWidth;
    NSInteger       _logicCount;    // 逻辑个数：如3个子界面（详情、评价、其他），本变量为3；
    NSInteger       _physicalCount; // 物理个数：如3个子界面（详情、评价、其他），为了循环左右各扩充了一组，本变量为9；
    NSMutableArray  *_physicalItems;
    NSInteger       _selectedPhysicalIndex;     // 当前选中子界面的物理Index；
    BOOL            _isScrollFromSynchronizeMsg;// scroll消息来源： UIScrollViewDelegate的didScroll方法检查此值，若_isScrollFromSynchronizeMsg为YES，则判定didScroll是Synchronize消息导致的，自身不再通知SynchronizeObserver，防止循环通知；

}
@property (nonatomic) UIColor   *unSelectedTextColor;
@property (nonatomic) UIFont    *unSelectedFont;
@property (nonatomic) UIColor   *selectedTextColor;
@property (nonatomic) UIFont    *selectedFont;
@end

@implementation M2CycleTabBarView

- (id)initWithFrame:(CGRect)frame itemsCountPerPage:(NSInteger)itemsCountPerPage{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // 参数
        // 每页的item个数
        _itemsCountInPage = itemsCountPerPage;
        if (_itemsCountInPage <= 3) {
            _itemsCountInPage = 3;
        }
        // TODO:暂时只支持奇数个元素可见
        if (_itemsCountInPage % 2 == 0) {
            _itemsCountInPage -= 1;
        }
        
        // UI
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        // 样式 //TODO
        _unSelectedTextColor = [UIColor grayColor];
        _unSelectedFont = [UIFont systemFontOfSize:13];
        _selectedTextColor = [UIColor redColor];
        _selectedFont = [UIFont systemFontOfSize:16];
    }
    
    return self;
}

#pragma mark - setter
- (void)setTitles:(NSArray *)titles{
    //clear
    UIView *oldItem = nil;
    for (oldItem in _physicalItems) {
        [oldItem removeFromSuperview];
    }
    _titles = nil;
    _physicalItems = nil;
    _scrollView.contentSize = CGSizeZero;
    _scrollView.contentOffset = CGPointZero;
    
    // 初始化items
    _titles = titles;
    _logicCount = [_titles count];
    _physicalCount = _logicCount * 3;// TODO：扩充至3倍
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
    _scrollView.contentSize = CGSizeMake(_itemWidth * _physicalCount, CGRectGetHeight(_scrollView.bounds));
    // 默认选中中间组逻辑index==0的item；
    _selectedPhysicalIndex = _logicCount;
    [self modifyStylePrePhysicalIndex:_selectedPhysicalIndex curPhysicalIndex:_selectedPhysicalIndex];
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:NO];
}

#pragma mark - 定制item样式
- (UIView*)itemWithPhysicalIndex:(NSInteger)physicalIndex{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
    button.titleLabel.font = _unSelectedFont;
    [button setTitle:[_titles objectAtIndex:[self logicIndexByPhysicalIndex:physicalIndex]] forState:UIControlStateNormal];
    button.tag = physicalIndex + M2CTBV_ItemTagOffset;
    [button addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 如果didScroll是Synchronize消息导致的，不再通知自身的synchronizeObserver，防止循环通知；
    if (!_isScrollFromSynchronizeMsg && _synchronizeObserver && [_synchronizeObserver respondsToSelector:@selector(view:didScrollOffsetX:itemWidth:itemsCountPerPage:)]) {
        [_synchronizeObserver view:self didScrollOffsetX:scrollView.contentOffset.x itemWidth:_itemWidth itemsCountPerPage:_itemsCountInPage];
    }
    // 本次didScroll结束，flag弹回NO；
    _isScrollFromSynchronizeMsg = NO;
    
    // LeftPhysicalIndex是靠近左边缘的item，计算scrollView时用其比较方便；
    NSInteger curLeftPhysicalIndex = [self leftPhysicalIndexWhenOffsetX:scrollView.contentOffset.x];
    // curPhysicalIndex是选中的item，在tabBar中间；修改选中item状态及通知delegate用其比较方便；
    NSInteger curPhysicalIndex = [self physicalIndexByLeftPhysicalIndex:curLeftPhysicalIndex];

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
        curLeftPhysicalIndex += _logicCount;
        offsetX += _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
    }else if (curPhysicalIndex + ((_itemsCountInPage - 1) / 2) == _physicalCount - 1){
//        NSLog(@") 到达右边缘  @@%s", __func__);
        curLeftPhysicalIndex -= _logicCount;
        offsetX -= _itemWidth * _logicCount;
        isNeedModifyOffset = YES;
    }
    
    // 修改item样式（之前选中的item弹回默认状态，当前选中的item变为选中状态）
    [self modifyStylePrePhysicalIndex:_selectedPhysicalIndex curPhysicalIndex:curPhysicalIndex];
    // 一定要先修改_selectedPhysicalIndex的值，再设置_scrollView的offset，scrollViewDidScroll会用到最新的_selectedPhysicalIndex；
    _selectedPhysicalIndex = curPhysicalIndex;
    if (isNeedModifyOffset) {
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        return;
    }
    // 静止后吸附
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 静止后吸附
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}

#pragma mark - 点击item
- (void)onTapItem:(UIButton *)sender{
    NSInteger physicalIndex = sender.tag - M2CTBV_ItemTagOffset;
    [self modifyStylePrePhysicalIndex:_selectedPhysicalIndex curPhysicalIndex:physicalIndex];
    _selectedPhysicalIndex = physicalIndex;
    [self modifyOffsetXByPhysicalIndex:_selectedPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_selectedPhysicalIndex]];
    }
}

#pragma mark - index换算
- (NSInteger)logicIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger logicIndex = physicalIndex % _logicCount;
    return logicIndex;
}
- (NSInteger)leftPhysicalIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger leftPhysicalIndex = physicalIndex - ((_itemsCountInPage - 1) / 2);
    return leftPhysicalIndex;
}
- (NSInteger)physicalIndexByLeftPhysicalIndex:(NSInteger)leftPhysicalIndex{
    NSInteger physicalIndex = leftPhysicalIndex + ((_itemsCountInPage - 1) / 2);
    return physicalIndex;
}

#pragma mark - 修改选中item的样式、位置等
- (void)modifyStylePrePhysicalIndex:(NSInteger)prePhysicalIndex curPhysicalIndex:(NSInteger)curPhysicalIndex{
    // 修改item样式（之前选中的item弹回默认状态，当前选中的item变为选中状态）
    if (prePhysicalIndex != curPhysicalIndex) {
        UIButton *preItem = [_physicalItems objectAtIndex:prePhysicalIndex];
        [preItem setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
        preItem.titleLabel.font = _unSelectedFont;
    }
    UIButton *curItem = [_physicalItems objectAtIndex:curPhysicalIndex];
    [curItem setTitleColor:_selectedTextColor forState:UIControlStateNormal];
    curItem.titleLabel.font = _selectedFont;
}
- (void)modifyOffsetXByPhysicalIndex:(NSInteger)physicalIndex animated:(BOOL)animated{
    // 调整offset使item有吸附效果（停在适当的位置）
    float offsetX = _itemWidth * [self leftPhysicalIndexByPhysicalIndex:physicalIndex];
    [_scrollView setContentOffset:CGPointMake(offsetX, 0) animated:animated];
}

#pragma mark - 
- (NSInteger)leftPhysicalIndexWhenOffsetX:(float)offsetX{
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
//    NSLog(@")))tabBarView接到同步通知offsetX(%f)  @@%s", offsetX, __func__);
    _isScrollFromSynchronizeMsg = YES;
    NSInteger deltaCount = ((_itemsCountInPage - 1) / 2) - ((itemsCountPerPage - 1) / 2);
    float myOffsetX = offsetX * (_itemWidth / itemWidth) - (_itemWidth * deltaCount);
    [_scrollView setContentOffset:CGPointMake(myOffsetX, 0)];
}

@end
