//
//  MMultiRowTabView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MMultiRowTabView.h"
#import "M2MultiRowTabbarView.h"

@interface MMultiRowTabView()<M2MultiRowTabbarViewDelegate>
@property (nonatomic) M2MultiRowTabBarView *tabbarView;
@end

@implementation MMultiRowTabView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // tabbar
        _tabbarView = [[M2MultiRowTabBarView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), 100)
                                                           titles:@[@"新闻", @"财经", @"科技", @"轻松一刻"]
                                                   itemCountInRow:3];
        _tabbarView.delegate = self;
        _tabbarView.backgroundColor = [UIColor lightGrayColor];
        _tabbarView.disableIndexs = @[@(1)];
        [self addSubview:_tabbarView];

    }
    return self;
}

- (void)tabBarView:(M2MultiRowTabBarView *)tableView didSelectRowAtIndex:(NSUInteger)index{
    NSLog(@"tapIndex(%d)  @@%s", index, __func__);
}

@end
