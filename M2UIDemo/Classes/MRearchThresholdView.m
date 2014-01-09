//
//  MRearchThresholdView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MRearchThresholdView.h"
#import "MScrollableView.h"

@interface MRearchThresholdView()
@property (nonatomic) UIView            *aboveView;
@property (nonatomic) MScrollableView   *scrollableView;
@end

@implementation MRearchThresholdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _aboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 150)];
        _aboveView.backgroundColor = [UIColor blackColor];
        [self addSubview:_aboveView];
        
        //
        _scrollableView = [[MScrollableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_aboveView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetHeight(_aboveView.bounds))];
        [self addSubview:_scrollableView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
