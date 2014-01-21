//
//  MTapTabPanSubView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MPanTabPanSubViewView.h"
#import "M2TabBarView_B.h"

@interface MPanTabPanSubViewView()<M2TabBarViewDelegate, UIScrollViewDelegate>{
    M2TabBarView_B  *_tabBarView;
    UIScrollView    *_contentContainerView;
    NSArray         *_contentViews;
    NSArray         *_titles;
}
@end

@implementation MPanTabPanSubViewView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // tab
        _tabBarView = [[M2TabBarView_B alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50) itemsCountInPage: 5];
        _tabBarView.delegate = self;
        _tabBarView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tabBarView];
        
        // content
        _contentContainerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabBarView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetMaxY(_tabBarView.frame))];
        _contentContainerView.delegate = self;
        _contentContainerView.pagingEnabled = YES;
        _contentContainerView.showsHorizontalScrollIndicator = NO;
        _contentContainerView.showsVerticalScrollIndicator = NO;
        [self addSubview:_contentContainerView];
    }
    
    return self;
}

#pragma mark - public
- (void)reloadDataWithTitles:(NSArray *)titles contentViews:(NSArray *)contentViews{
    // check
    if ([titles count] != [contentViews count]) {
        return;
    }
    
    // clear old
    UIView *contentView = nil;
    for (contentView in _contentViews) {
        [contentView removeFromSuperview];
    }
    _contentContainerView.contentSize = CGSizeMake(0, _contentContainerView.contentSize.height);
    
    // bulid new
    // tab
    _titles = titles;
    _tabBarView.titles = _titles;
    // content
    _contentViews = contentViews;
    int count = [contentViews count];
    float itemWidth = CGRectGetWidth(_contentContainerView.bounds);
    float itemHeight = CGRectGetHeight(_contentContainerView.bounds);
    for (int i = 0; i < count; i++) {
        contentView = [contentViews objectAtIndex:i];
        contentView.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        [_contentContainerView addSubview:contentView];
    }
    if (count > 0) {
        _contentContainerView.contentSize = CGSizeMake(CGRectGetMaxX(contentView.frame), _contentContainerView.contentSize.height);
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    float itemWidth = CGRectGetWidth(_contentContainerView.bounds);
    int index = (int)(scrollView.contentOffset.x + 5) / itemWidth;
    [_tabBarView selectIndex:index];
}

#pragma mark - M2TabBarViewDelegate
- (void)tabBarView:(M2TabBarView_B *)tabBarView didSelectItemAtIndex:(NSInteger)index{
    float itemWidth = CGRectGetWidth(_contentContainerView.bounds);
    [_contentContainerView setContentOffset:CGPointMake(itemWidth * index, 0) animated:NO];
}

@end
