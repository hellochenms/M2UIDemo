//
//  MCycleTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCycleTabBarView.h"
#import "M2CycleTabBarView.h"

@interface MCycleTabBarView(){
    M2CycleTabBarView *_tabBarView;
}
@end

@implementation MCycleTabBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _tabBarView = [[M2CycleTabBarView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50) itemsCountInPage:3 titles:@[@"详情", @"评论", @"攻略", @"测评"]];//, @"资讯", @"美图"]];
        [self addSubview:_tabBarView];
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
