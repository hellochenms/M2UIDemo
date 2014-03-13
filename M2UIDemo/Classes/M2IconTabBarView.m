//
//  M2IconTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-3.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2IconTabBarView.h"

#define M2ITBV_ItemTagOffset 6000
#define M2ITBV_AnimationDuration 0.1

@interface M2IconTabBarView(){
    NSInteger       _curSelectedIndex;
    NSMutableArray  *_items;
    NSMutableArray  *_seperators;
    NSArray         *_normalIconNames;
    NSArray         *_selectedIconNames;
}
@property (nonatomic) UIView *underLineView;
@end

@implementation M2IconTabBarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _items = [NSMutableArray array];
        _curSelectedIndex = NSNotFound;
        
        // 默认
        _normalTextColor = [UIColor blackColor];
        _selectedTextColor = [UIColor colorWithRed:0x01/255.0 green:0x7a/255.0 blue:0xfd/255.0 alpha:1.0];
        _seperatorLineViewColor = [UIColor blackColor];
        _underLinerViewColor = _selectedTextColor;
        _itemFont = [UIFont systemFontOfSize:16];
    }
    
    return self;
}

- (void)loadTitle:(NSArray *)titles normalIconNames:(NSArray *)normalIconNames selectedIconNames:(NSArray *)selectedIconNames{
    if ([titles count] <= 0) {
        return;
    }
    if ([titles count] != [normalIconNames count]
        || [titles count] != [selectedIconNames count]
        || [normalIconNames count] != [selectedIconNames count]) {
        return;
    }
    
    _normalIconNames = normalIconNames;
    _selectedIconNames = selectedIconNames;
    // items
    NSUInteger count = [titles count];
    float itemWidth = CGRectGetWidth(self.bounds) / count;
    float itemHeight = CGRectGetHeight(self.bounds);
    UIButton *button = nil;
    for (NSInteger i = 0; i < count; i++) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(itemWidth * i, 0, itemWidth, itemHeight);
        button.titleLabel.font = _itemFont;
        [button setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[_normalIconNames objectAtIndex:i]] forState:UIControlStateNormal];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        button.tag = M2ITBV_ItemTagOffset + i;
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
    NSUInteger index = sender.tag - M2ITBV_ItemTagOffset;
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
        UIButton *lastSelectedButton = (UIButton *)[self viewWithTag:M2ITBV_ItemTagOffset + _curSelectedIndex];
        [lastSelectedButton setTitleColor: self.normalTextColor forState:UIControlStateNormal];
        [lastSelectedButton setImage:[UIImage imageNamed:[_normalIconNames objectAtIndex:_curSelectedIndex]] forState:UIControlStateNormal];
    }
    
    UIButton *curSelectButton = (UIButton *)[self viewWithTag:M2ITBV_ItemTagOffset + index];
    [curSelectButton setTitleColor: self.selectedTextColor forState:UIControlStateNormal];
    [curSelectButton setImage:[UIImage imageNamed:[_selectedIconNames objectAtIndex:index]] forState:UIControlStateNormal];
    
    _curSelectedIndex = index;
    
    // 下划线
    CGRect frame = _underLineView.frame;
    frame.origin.x = CGRectGetWidth(frame) * index;
    if (animated) {
        __weak M2IconTabBarView *weakSelf = self;
        [UIView animateWithDuration:M2ITBV_AnimationDuration
                         animations:^{
                             weakSelf.underLineView.frame = frame;
                         }];
    }else{
        _underLineView.frame = frame;
    }
}

#pragma mark - setter
- (void)setNormalTextColor:(UIColor *)unSelectedTextColor{
    _normalTextColor = unSelectedTextColor;
    UIButton *item = nil;
    for (item in _items) {
        if (item.tag - M2ITBV_ItemTagOffset != _curSelectedIndex) {
            [item setTitleColor: self.normalTextColor forState:UIControlStateNormal];
        }
    }
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor{
    _selectedTextColor = selectedTextColor;
    UIButton *item = nil;
    for (item in _items) {
        if (item.tag - M2ITBV_ItemTagOffset == _curSelectedIndex) {
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
