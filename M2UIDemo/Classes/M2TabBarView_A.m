//
//  M2TabbarView_A.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2TabBarView_A.h"

#define M2TV_ItemTagOffset 6000
#define M2TV_AnimationDuration 0.1

@interface M2TabBarView_A(){
    NSInteger       _curSelectedIndex;
    NSMutableArray  *_items;
    NSMutableArray  *_seperators;
}
@property (nonatomic) UIView *underLineView;
@end

@implementation M2TabBarView_A

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _items = [NSMutableArray array];
        _curSelectedIndex = NSNotFound;
        
        // 默认
        _unSelectedTextColor = [UIColor grayColor];
        _selectedTextColor = [UIColor blueColor];
        _seperatorLineViewColor = [UIColor lightGrayColor];
        _underLinerViewColor = [UIColor blueColor];
    }
    
    return self;
}

#pragma mark - setter
- (void)setTitles:(NSArray *)titles{
    _titles = titles;
    
    // clear old
    UIView *view = nil;
    for (view in _items) {
        [view removeFromSuperview];
    }
    [_items removeAllObjects];
    for (view in _seperators) {
        [view removeFromSuperview];
    }
    [_seperators removeAllObjects];
    [_underLineView removeFromSuperview];
    
    if ([_titles count] <= 0) {
        return;
    }
    
    // items
    NSUInteger count = [_titles count];
    float itemWidth = CGRectGetWidth(self.bounds) / count;
    float itemHeight = CGRectGetHeight(self.bounds);
    UIButton *button = nil;
    for (NSInteger i = 0; i < count; i++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        button.titleLabel.font = _itemFont;
        [button setTitleColor:_unSelectedTextColor forState:UIControlStateNormal];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = M2TV_ItemTagOffset + i;
        [button addTarget:self action:@selector(onTapItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_items addObject:button];
    }
    
    // 分隔线
    UIView *seperatorLineView = nil;
    NSInteger seperatorCount = count - 1;
    float seperatorWidth = 1;
    float seperatorHeight = itemHeight - 10;
    for (int i = 0; i < seperatorCount; i++) {
        seperatorLineView = [[UIView alloc] initWithFrame:CGRectMake(itemWidth * (i + 1) - seperatorWidth / 2.0, (itemHeight - seperatorHeight) / 2, seperatorWidth , seperatorHeight)];
        seperatorLineView.backgroundColor = _seperatorLineViewColor;
        seperatorLineView.hidden = _seperarorLineViewHidden;
        [self addSubview:seperatorLineView];
        [_seperators addObject:seperatorLineView];
    }
    
    // 下划线
    _underLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 2, itemWidth, 2)];
    _underLineView.backgroundColor = _underLinerViewColor;
    [self addSubview:_underLineView];
    
    // init
    [self selectIndex:0 animated:NO];
}

#pragma mark - tap event
- (void)onTapItem:(UIButton *)sender{
    NSUInteger index = sender.tag - M2TV_ItemTagOffset;
    [self selectIndex:index animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectItemAtIndex:)]) {
        [_delegate tabBarView:self didSelectItemAtIndex:index];
    }
}

#pragma mark - public
- (void)selectIndex:(NSInteger)index animated:(BOOL)animated{
    if (index == _curSelectedIndex) {
        return;
    }
    if (_curSelectedIndex != NSNotFound) {
        UIButton *lastSelectedButton = (UIButton *)[self viewWithTag:M2TV_ItemTagOffset + _curSelectedIndex];
        [lastSelectedButton setTitleColor: self.unSelectedTextColor forState:UIControlStateNormal];
    }
    
    UIButton *curSelectButton = (UIButton *)[self viewWithTag:M2TV_ItemTagOffset + index];
    [curSelectButton setTitleColor: self.selectedTextColor forState:UIControlStateNormal];
    
    _curSelectedIndex = index;
    
    // 下划线
    CGRect frame = _underLineView.frame;
    frame.origin.x = CGRectGetWidth(frame) * index;
    if (animated) {
        __weak M2TabBarView_A *weakSelf = self;
        [UIView animateWithDuration:M2TV_AnimationDuration
                         animations:^{
                             weakSelf.underLineView.frame = frame;
                         }];
    }else{
        _underLineView.frame = frame;
    }
}

#pragma mark - setter
- (void)setUnSelectedTextColor:(UIColor *)unSelectedTextColor{
    _unSelectedTextColor = unSelectedTextColor;
    UIButton *item = nil;
    for (item in _items) {
        if (item.tag - M2TV_ItemTagOffset != _curSelectedIndex) {
            [item setTitleColor: self.unSelectedTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor{
    _selectedTextColor = selectedTextColor;
    UIButton *item = nil;
    for (item in _items) {
        if (item.tag - M2TV_ItemTagOffset == _curSelectedIndex) {
            [item setTitleColor: self.selectedTextColor forState:UIControlStateNormal];
            break;
        }
    }
}

- (void)setItemFont:(UIFont *)itemFont{
    _itemFont = itemFont;
    UIButton *item = nil;
    for (item in _items) {
        item.titleLabel.font = itemFont;
    }
}

- (void)setSeperarorLineViewHidden:(BOOL)seperarorLineViewHidden{
    _seperarorLineViewHidden = seperarorLineViewHidden;
    UIView *seperator = nil;
    for (seperator in _seperators) {
        seperator.hidden = seperarorLineViewHidden;
    }
}

- (void)setSeperatorLineViewColor:(UIColor *)seperatorLineViewColor{
    _seperatorLineViewColor = seperatorLineViewColor;
    UIView *seperator = nil;
    for (seperator in _seperators) {
        seperator.backgroundColor = _seperatorLineViewColor;
    }
}

- (void)setUnderLinerViewColor:(UIColor *)underLinerViewColor{
    _underLinerViewColor = underLinerViewColor;
    _underLineView.backgroundColor = _underLinerViewColor;
}

@end
