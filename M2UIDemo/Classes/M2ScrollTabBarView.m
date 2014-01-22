//
//  M2TabBarView_B.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#define M2STBVA_Default_ItemsCountInPage 5
#define M2STBVA_ItemTagOffset 6000

#import "M2ScrollTabBarView_A.h"

@interface M2ScrollTabBarView_A()<UIScrollViewDelegate>{
    UIScrollView    *_mainView;
    NSMutableArray  *_items;
    NSInteger       _itemsCountInPage;
    NSArray         *_titles;
    NSInteger       _curSelectedIndex;
}
@property (nonatomic) UIColor   *unSelectedTextColor;
@property (nonatomic) UIFont    *unSelectedFont;
@property (nonatomic) UIColor   *selectedTextColor;
@property (nonatomic) UIFont    *selectedFont;
@end

@implementation M2ScrollTabBarView_A

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame itemsCountInPage:M2STBVA_Default_ItemsCountInPage];
}

- (id)initWithFrame:(CGRect)frame itemsCountInPage:(NSInteger)itemsCountInPage{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        if (itemsCountInPage <= 0) {
            return self;
        }
        
        // self
        _curSelectedIndex = NSNotFound;
        _unSelectedTextColor = [UIColor grayColor];
        _unSelectedFont = [UIFont systemFontOfSize:13];
        _selectedTextColor = [UIColor redColor];
        _selectedFont = [UIFont systemFontOfSize:16];
        
        // 保证_itemsCountInPage为奇数
        _itemsCountInPage = itemsCountInPage;
        if (_itemsCountInPage % 2 == 0) {
            _itemsCountInPage = _itemsCountInPage / 2 + 1;
        }
        
        // scroll view
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.delegate = self;
        [self addSubview:_mainView];
    }
    
    return self;
}

#pragma mark -setter
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    // clear old
    UIView *oldItem = nil;
    for (oldItem in _items) {
        [oldItem removeFromSuperview];
    }
    _items = nil;
    _mainView.contentSize = CGSizeMake(0, CGRectGetHeight(_mainView.bounds));
    
    // build new
    NSInteger count = [titles count];
    if (count <= 0) {
        return;
    }
    
    // 尺寸
    float itemWidth = CGRectGetWidth(_mainView.bounds) / _itemsCountInPage;
    float itemHeight = CGRectGetHeight(_mainView.bounds);
    
    // 左端的填充items（填充items保证了第一个目标item和最后一个item也能位于tabBar的正中央）
    NSInteger paddingCount = _itemsCountInPage / 2;
    UIView *item = nil;
    for (NSInteger i = 0; i < paddingCount; i++) {
        item = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight)];
        [_mainView addSubview:item];
    }
    // 目标items
    _items = [NSMutableArray arrayWithCapacity:count];
    float offset = paddingCount ;
    for (NSInteger i = 0; i < count; i++) {
        item = [self itemWithIndex:i];
        item.frame = CGRectMake(itemWidth * (i + offset), 0, itemWidth, itemHeight);
        [_mainView addSubview:item];
        [_items addObject:item];
    }
    // 右端的填充items
    offset = paddingCount + count;
    for (NSInteger i = 0; i < paddingCount; i++) {
        item = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i + offset), 0, itemWidth, itemHeight)];
        [_mainView addSubview:item];
    }
    
    // scroll view
    _mainView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame), CGRectGetHeight(_mainView.bounds));
    
    // init
    [self selectIndex:0];
}

#pragma mark - tools 定制item样式主要在此处
- (UIView*)itemWithIndex:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
    button.titleLabel.font = _unSelectedFont;
    [button setTitle:[_titles objectAtIndex:index] forState:UIControlStateNormal];
    button.tag = index + M2STBVA_ItemTagOffset;
    [button addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index = [self indexWhenOffsetX:scrollView.contentOffset.x];
    [self selectIndex:index needChangeContentOffset:NO];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    NSLog(@"decelerate(%d)  @@%s", decelerate, __func__);
    if (!decelerate) {
        [self modifyOffsetX:scrollView.contentOffset.x];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"  @@%s", __func__);
    [self modifyOffsetX:scrollView.contentOffset.x];
}
#pragma mark -
- (void)modifyOffsetX:(float)offsetX{
    //    NSLog(@"offsetX(%f)  @@%s", offsetX, __func__);
    NSInteger index = [self indexWhenOffsetX:offsetX];
    // delegate
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectItemAtIndex:)]) {
        [_delegate tabBarView:self didSelectItemAtIndex:index];
    }
    [self selectIndex:index];
}

- (NSInteger)indexWhenOffsetX:(float)offsetX{
    float itemWidth = CGRectGetWidth(_mainView.bounds) / _itemsCountInPage;
    int fullItemCount = (int)floorf(offsetX / itemWidth);
    float offsetXRemainder = offsetX - itemWidth * fullItemCount;
    NSInteger index = fullItemCount;
    if (offsetXRemainder < itemWidth / 2) {
        index = fullItemCount;
    }else{
        index = fullItemCount + 1;
    }
    
    if (index < 0) {
        index = 0;
    }else if (index > [_titles count] -1){
        index = [_titles count] - 1;
    }
    
    return index;
}

#pragma mark - tap item
- (void)onTapItem:(UIView *)sender{
    NSInteger index = sender.tag - M2STBVA_ItemTagOffset;
    [self selectIndex:index];
    // delegate
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectItemAtIndex:)]) {
        [_delegate tabBarView:self didSelectItemAtIndex:index];
    }
}

#pragma mark - select index
- (void)selectIndex:(NSInteger)index{
    [self selectIndex:index needChangeContentOffset:YES];
}
- (void)selectIndex:(NSInteger)index needChangeContentOffset:(BOOL)needChangeContentOffset{
    // 设置相关item样式
    if (_curSelectedIndex != NSNotFound) {
        UIButton *lastItem = [_items objectAtIndex:_curSelectedIndex];
        [lastItem setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
        lastItem.titleLabel.font = _unSelectedFont;
    }
    UIButton *curItem = [_items objectAtIndex:index];
    [curItem setTitleColor:_selectedTextColor forState:UIControlStateNormal];
    curItem.titleLabel.font = _selectedFont;
    
    _curSelectedIndex = index;
    
    // 如果需要设置scroll view的offset（如点击item，需要将item调整到最中央），则设置offset
    // 不需要调整的情况如滑动过程中，只变化相关item样式（如滑出中央区的item颜色字体调整为非选中状态，滑入中央区的item调整为选中状态）
    if (needChangeContentOffset) {
        float itemWidth = CGRectGetWidth(_mainView.bounds) / _itemsCountInPage;
        CGPoint offset = _mainView.contentOffset;
        offset.x = itemWidth * index;
        [_mainView setContentOffset:offset animated:YES];
    }
}


@end

