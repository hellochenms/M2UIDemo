//
//  M2CycleTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CycleTabBarView.h"

#define M2CTBV_ItemTagOffset 6000

@interface M2CycleTabBarView()<UIScrollViewDelegate>{
    NSInteger       _itemsCountInPage;
    NSInteger       _itemCount;
    NSInteger       _realCount;
    NSInteger       _extraCountEachSide;
    NSArray         *_titles;
    NSMutableArray  *_items;
    float           _itemWidth;
    NSInteger       _curSelectedIndex;
    UIScrollView    *_scrollView;
    NSInteger       _preIndex;
    NSInteger       _prePassedFullItemCount;
}
@property (nonatomic) UIColor   *unSelectedTextColor;
@property (nonatomic) UIFont    *unSelectedFont;
@property (nonatomic) UIColor   *selectedTextColor;
@property (nonatomic) UIFont    *selectedFont;
@end

@implementation M2CycleTabBarView

- (id)initWithFrame:(CGRect)frame itemsCountInPage:(NSInteger)itemsCountInPage titles:(NSArray *)titles{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor cyanColor];
        
        // check
        if ([titles count] <=0 || [titles count] < itemsCountInPage) {
            NSLog(@"参数错误  @@%s", __func__);
            return self;
        }
        
        // 参数
        _itemCount = [titles count];
        _itemsCountInPage = itemsCountInPage;
        if (_itemsCountInPage % 2 == 0) {// TODO:暂时只支持奇数个元素可见
            _itemsCountInPage -= 1;
        }
        _titles = titles;
        
        // 样式
        _curSelectedIndex = NSNotFound;
        _unSelectedTextColor = [UIColor grayColor];
        _unSelectedFont = [UIFont systemFontOfSize:13];
        _selectedTextColor = [UIColor redColor];
        _selectedFont = [UIFont systemFontOfSize:16];
        
        // UI
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _extraCountEachSide = _itemsCountInPage / 2 + 1;
        _realCount = _itemCount + _extraCountEachSide * 2;
        
        _items = [NSMutableArray arrayWithCapacity:_realCount];
        UIView *item = nil;
        _itemWidth = CGRectGetWidth(_scrollView.bounds) / _itemsCountInPage;
        float itemHeight = CGRectGetHeight(_scrollView.bounds);
        for (NSInteger i = 0; i < _realCount; i++) {
            item = [self itemWithIndex:i];
            item.frame = CGRectMake(_itemWidth * i, 0, _itemWidth, itemHeight);
            [_scrollView addSubview:item];
            [_items addObject:item];
        }
        _scrollView.contentSize = CGSizeMake(_itemWidth * _realCount, CGRectGetHeight(_scrollView.bounds));
        [_scrollView setContentOffset:CGPointMake(_itemWidth, 0)];
        _prePassedFullItemCount = 1;
    }
    
    return self;
}

#pragma mark - 定制item样式
- (UIView*)itemWithIndex:(NSInteger)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
    button.titleLabel.font = _unSelectedFont;
    [button setTitle:[_titles objectAtIndex:(index - _extraCountEachSide + _itemCount) % _itemCount] forState:UIControlStateNormal];
    button.tag = index + M2CTBV_ItemTagOffset;
    [button addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - tap item
- (void)onTapItem:(UIButton *)sender{
    NSInteger index = sender.tag - M2CTBV_ItemTagOffset;
    NSInteger resultIndex = (index - _extraCountEachSide + _itemCount) % _itemCount;
    NSLog(@"index(%d) realIndex(%d)  @@%s", index, resultIndex, __func__);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger passedFullItemCount = [self indexWhenOffsetX:scrollView.contentOffset.x];
    if (passedFullItemCount == _prePassedFullItemCount) {
        return;
    }
    NSLog(@"计算后的index(%d)  @@%s", passedFullItemCount, __func__);
    
    float offsetX = scrollView.contentOffset.x;
    if (passedFullItemCount == 0 && passedFullItemCount - _prePassedFullItemCount < 0) {
        passedFullItemCount += _itemCount;
        offsetX += _itemWidth * _itemCount;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }else if (passedFullItemCount + _itemsCountInPage == _realCount && index - _prePassedFullItemCount > 0){
        passedFullItemCount -= _itemCount;
        offsetX -= _itemWidth * _itemCount;
        [_scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }
    
     NSLog(@"index从(%d)变为(%d)  @@%s", _prePassedFullItemCount, passedFullItemCount, __func__);
    _prePassedFullItemCount = passedFullItemCount;
}

- (NSInteger)indexWhenOffsetX:(float)offsetX{
//    NSLog(@"offsetX(%f)  @@%s", offsetX, __func__);
    float quotient = offsetX / _itemWidth;
    NSInteger index = (NSInteger)quotient;
    float remainder = offsetX - _itemWidth * index;
    if (remainder / _itemWidth >= 0.5) {
        index++;
    }
    
    return index;
}

@end
