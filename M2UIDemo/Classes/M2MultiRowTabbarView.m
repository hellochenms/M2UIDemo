//
//  M2MultiRowTabbarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-13.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2MultiRowTabBarView.h"

#define M2MRTV_ItemOffset           6000

@implementation M2MultiRowTabBarView{
    UIView *_containerView;
    NSMutableArray *_items;
}

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray*)titles
     itemCountInRow:(int)itemCountInRow{
    self = [super initWithFrame:frame];
    if (!titles && [titles count] <= 0) {
        return self;
    }
    
    if (self) {
        //

        
        if (itemCountInRow <= 0) {
            itemCountInRow = M2MRTV_Default_ItemCountInRow;
        }

        // container
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(M2MRTV_ItemHorizontalMargin, M2MRTV_ItemVerticalMargin, CGRectGetWidth(frame) - M2MRTV_ItemHorizontalMargin * 2, CGRectGetHeight(frame) - M2MRTV_ItemVerticalMargin * 2)];
        [self addSubview:_containerView];
        
        // items
        int count = [titles count];
        _items = [NSMutableArray arrayWithCapacity:count];
        
        int rowCount = (count - 1) / itemCountInRow + 1;
        UIButton *button = nil;
        float itemWidth = CGRectGetWidth(_containerView.frame) / itemCountInRow - M2MRTV_ItemHorizontalMargin * 2;
        float itemHeight = CGRectGetHeight(_containerView.frame) / rowCount - M2MRTV_ItemVerticalMargin * 2;
        for (int i = 0; i < count; i++) {
            button = [self buttonWithFrame:CGRectMake((itemWidth + M2MRTV_ItemHorizontalMargin * 2) * (i % itemCountInRow) + M2MRTV_ItemHorizontalMargin, (itemHeight + M2MRTV_ItemVerticalMargin * 2) * (i / itemCountInRow) + M2MRTV_ItemVerticalMargin, itemWidth, itemHeight)
                                  andTitle:[titles objectAtIndex:i]
                                  andIndex:i];
            [_containerView addSubview:button];
            [_items addObject:button];
        }
    }
    
    return self;
}

#pragma mark - item build & event
- (UIButton*)buttonWithFrame:(CGRect)frame andTitle:(NSString*)title andIndex:(int)index{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@"white_rect"] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = M2MRTV_ItemOffset + index;
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (void)onTapButton:(UIButton*)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(tabBarView:didSelectRowAtIndex:)]) {
        [_delegate tabBarView:self didSelectRowAtIndex:sender.tag - M2MRTV_ItemOffset];
    }
}

#pragma mark - setter
- (void)setDisableIndexs:(NSArray *)aDisableIndexs{
    _disableIndexs = aDisableIndexs;
    
    if (!_disableIndexs || [_disableIndexs count] <= 0) {
        return;
    }
    
    NSNumber *indexNumber = nil;
    int index = 0;
    int maxIndex = [_items count] - 1;
    UIButton *button = nil;
    for (indexNumber in _disableIndexs) {
        index = [indexNumber intValue];
        if (index >= 0 && index <= maxIndex) {
            button = [_items objectAtIndex:index];
            button.enabled = NO;
        }
    }
}

@end
