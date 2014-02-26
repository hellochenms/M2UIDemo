//
//  M2CycleTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleTabBarView_AF.h"

#define M2CTBV_ItemTagOffset 6000
#define M2CTBV_DefaultItemsCountPerPage 3

@interface M2CycleTabBarView_AF()<UIScrollViewDelegate>{
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
@property (nonatomic) UIColor   *unSelectedTextColor;
@property (nonatomic) UIFont    *unSelectedFont;
@property (nonatomic) UIColor   *selectedTextColor;
@property (nonatomic) UIFont    *selectedFont;
@end

@implementation M2CycleTabBarView_AF

- (id)initWithFrame:(CGRect)frame itemsCountPerPage:(NSInteger)itemsCountPerPage{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
   
        // 参数
        _itemsCountInPage = itemsCountPerPage;
        if (_itemsCountInPage <= 0) {
            _itemsCountInPage = M2CTBV_DefaultItemsCountPerPage;
        }
        
        if (_itemsCountInPage % 2 == 0) {// TODO:暂时只支持奇数个元素可见
            _itemsCountInPage -= 1;
        }
        _extraCountEachSide = _itemsCountInPage / 2 + 1;
        
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
    _titles = titles;
    _logicCount = [_titles count];
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
    
    _scrollView.contentSize = CGSizeMake(_itemWidth * _physicalCount, CGRectGetHeight(_scrollView.bounds));
    
    _curPhysicalIndex = _extraCountEachSide;
    [self modifyStylePrePhysicalIndex:_curPhysicalIndex curPhysicalIndex:_curPhysicalIndex];
    [self modifyOffsetXByPhysicalIndex:_curPhysicalIndex animated:NO];
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
//    NSLog(@"~~~tabBar偏移X（%f）  @@%s", scrollView.contentOffset.x, __func__);
    NSInteger leftPhysicalIndex = [self indexWhenOffsetX:scrollView.contentOffset.x];
    NSInteger curLeftPhysicalIndex = [self leftPhysicalIndexByPhysicalIndex:_curPhysicalIndex];
    
    if (leftPhysicalIndex == curLeftPhysicalIndex) {
        return;
    }
//    NSLog(@"之前左index(%d) 之后左index(%d)  @@%s", curLeftPhysicalIndex, leftPhysicalIndex, __func__);
 
//    NSLog(@"~~~tabBarIndex要变  @@%s", __func__);
    float physicalIndex = [self physicalIndexByLeftPhysicalIndex:leftPhysicalIndex];
    float offsetX = scrollView.contentOffset.x;
    BOOL isNeedModifyOffset = YES;
    if (leftPhysicalIndex == 0 && leftPhysicalIndex - curLeftPhysicalIndex < 0) {
        physicalIndex += _logicCount;
        offsetX += _itemWidth * _logicCount;
    }else if (leftPhysicalIndex + _itemsCountInPage == _physicalCount && curLeftPhysicalIndex - leftPhysicalIndex < 0){
        physicalIndex -= _logicCount;
        offsetX -= _itemWidth * _logicCount;
    }else{
//        NSLog(@"!不需要setOffset  @@%s", __func__);
        isNeedModifyOffset = NO;
    }
    [self modifyStylePrePhysicalIndex:_curPhysicalIndex curPhysicalIndex:physicalIndex];
    _curPhysicalIndex = physicalIndex;
    if (isNeedModifyOffset) {
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
//        NSLog(@"!!!设置setOffset  @@%s", __func__);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {
        return;
    }
    [self modifyOffsetXByPhysicalIndex:_curPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_curPhysicalIndex]];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self modifyOffsetXByPhysicalIndex:_curPhysicalIndex animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:_curPhysicalIndex]];
    }
}

#pragma mark - tap item
- (void)onTapItem:(UIButton *)sender{
    NSInteger physicalIndex = sender.tag - M2CTBV_ItemTagOffset;
    [self modifyStylePrePhysicalIndex:_curPhysicalIndex curPhysicalIndex:physicalIndex];
    [self modifyOffsetXByPhysicalIndex:physicalIndex animated:YES];
    _curPhysicalIndex = physicalIndex;
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectedAtIndex:)]) {
        [_delegate tabBarView:self didSelectedAtIndex:[self logicIndexByPhysicalIndex:physicalIndex]];
    }
}

#pragma mark -
- (NSInteger)logicIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger logicIndex = (physicalIndex - _extraCountEachSide + _logicCount) % _logicCount;
    return logicIndex;
}
- (NSInteger)leftPhysicalIndexByPhysicalIndex:(NSInteger)physicalIndex{
    NSInteger leftPhysicalIndex = physicalIndex - (_extraCountEachSide - 1);
    return leftPhysicalIndex;
}
- (NSInteger)physicalIndexByLeftPhysicalIndex:(NSInteger)leftPhysicalIndex{
    NSInteger physicalIndex = leftPhysicalIndex + (_extraCountEachSide - 1);
    return physicalIndex;
}
- (NSInteger)indexWhenOffsetX:(float)offsetX{
    float quotient = offsetX / _itemWidth;
    NSInteger index = (NSInteger)quotient;
    float remainder = offsetX - _itemWidth * index;
//    NSLog(@"offsetX(%f) _itemWidth(%f) quotient(%f) index(%d) remainder(%f)  @@%s", offsetX, _itemWidth, quotient, index, remainder, __func__);
    if (remainder / _itemWidth >= 0.5) {
        index++;
//        NSLog(@"index++");
    }
    
    return index;
}

#pragma mark -
- (void)modifyStylePrePhysicalIndex:(NSInteger)prePhysicalIndex curPhysicalIndex:(NSInteger)curPhysicalIndex{
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
    [_scrollView setContentOffset:CGPointMake(_itemWidth * [self leftPhysicalIndexByPhysicalIndex:physicalIndex] , 0) animated:animated];
}

#pragma mark - public
- (void)selectPreItem{
    [self modifyOffsetXByPhysicalIndex:_curPhysicalIndex - 1 animated:YES];
    NSLog(@"_curPhysicalIndex(%d)  @@%s", _curPhysicalIndex, __func__);
}
- (void)selectNextItem{
    [self modifyOffsetXByPhysicalIndex:_curPhysicalIndex + 1 animated:YES];
//    NSLog(@"_curPhysicalIndex(%d)  @@%s", _curPhysicalIndex, __func__);
}

@end
