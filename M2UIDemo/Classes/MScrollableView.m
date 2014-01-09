//
//  MScrollableView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MScrollableView.h"

#define MSV_ItemHeight 100
#define MSV_ItemCount 30

@interface MScrollableView()<UIScrollViewDelegate>{
    UIScrollView *_scrollView;
}
@end

@implementation MScrollableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 5 * 2)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        
        UIView *item = nil;
        for (int i = 0; i < MSV_ItemCount; i++) {
            item = [[UIView alloc] initWithFrame:CGRectMake(0, MSV_ItemHeight * i, CGRectGetWidth(_scrollView.bounds), MSV_ItemHeight)];
            item.backgroundColor = randomColor;
            [_scrollView addSubview:item];
        }
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.bounds), CGRectGetMaxY(item.frame));
        [self addSubview:_scrollView];
    }
    return self;
}

#pragma mark - public
- (void)changeFrameByDeltaHeight:(float)deltaHeight{
    CGRect selfFrame = self.frame;
    selfFrame.size.height += deltaHeight;
    self.frame = selfFrame;
    
    CGRect scrollFrame = _scrollView.frame;
    scrollFrame.size.height += deltaHeight;
    _scrollView.frame = scrollFrame;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    NSLog(@"开始Drag  @@%s", __func__);
    if (_observerDelegate && [_observerDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_observerDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    NSLog(@"结束Drag  @@%s", __func__);
    if (_observerDelegate && [_observerDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [_observerDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"scrollView.contentOffset.y(%f)  @@%s", scrollView.contentOffset.y, __func__);
    if (_observerDelegate && [_observerDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_observerDelegate scrollViewDidScroll:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_observerDelegate && [_observerDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [_observerDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

@end
