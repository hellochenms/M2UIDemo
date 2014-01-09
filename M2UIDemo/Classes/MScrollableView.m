//
//  MScrollableView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MScrollableView.h"

#define MSV_ItemHeight 100
#define MSV_ItemCount 6

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

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
@end
