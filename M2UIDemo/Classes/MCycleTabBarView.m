//
//  MCycleTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCycleTabBarView.h"
#import "M2CycleTabBarView.h"
#import "M2CycleScrollView.h"
#import "MSubViewController.h"

@interface MCycleTabBarView()<M2CycleTabBarViewDelegate, M2CycleScrollViewDelegate>{
    M2CycleTabBarView   *_tabBarView;
    M2CycleScrollView   *_contentView;
    MSubViewController  *_sub0;
    UILabel             *_sub1;
    MSubViewController  *_sub2;
    MSubViewController  *_sub3;
}
@end

@implementation MCycleTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *titles = @[@"详情", @"评论", @"攻略", @"测评"];
        
        _tabBarView = [[M2CycleTabBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50) itemsCountPerPage:3];//, @"资讯", @"美图"]];
        _tabBarView.titles = titles;
        _tabBarView.backgroundColor = [UIColor whiteColor];
        _tabBarView.delegate = self;
        [self addSubview:_tabBarView];
        
        _contentView = [[M2CycleScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabBarView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetHeight(_tabBarView.bounds))];
        _contentView.backgroundColor = [UIColor lightGrayColor];
        _contentView.delegate = self;
        [self addSubview:_contentView];
        
        // content views
        NSMutableArray *contentViews = [NSMutableArray array];
        _sub0 = [MSubViewController new];
        _sub0.subTitle = [titles objectAtIndex:0];
        [contentViews addObject:_sub0.view];
        
        _sub1 = [[UILabel alloc] initWithFrame:_contentView.bounds];
        _sub1.backgroundColor = [UIColor lightGrayColor];
        _sub1.text = [titles objectAtIndex:1];
        [contentViews addObject:_sub1];
                      
        _sub2 = [MSubViewController new];
        _sub2.subTitle = [titles objectAtIndex:2];
        [contentViews addObject:_sub2.view];
        
        _sub3 = [MSubViewController new];
        _sub3.subTitle = [titles objectAtIndex:3];
        [contentViews addObject:_sub3.view];
        _contentView.contentViews = contentViews;
        
        // 双向同步
        _contentView.synchronizeObserver = _tabBarView;
        _tabBarView.synchronizeObserver = _contentView;
    }
    return self;
}

#pragma mark - M2CycleTabBarViewDelegate
- (void)tabBarView:(M2CycleTabBarView *)tabBarView didSelectedAtIndex:(NSInteger)index{
    NSLog(@"tabBarView选择index(%d)  @@%s", index, __func__);
}
#pragma mark - M2CycleScrollViewDelegate
- (void)cycleScrollView:(M2CycleScrollView *)cycleScrollView didSelectedAtIndex:(NSInteger)index{
    NSLog(@"scrollView选择index(%d)  @@%s", index, __func__);
}

@end
