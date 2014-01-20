//
//  MButtonTabBarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MButtonTabBarView.h"
#import "M2TabBarView_A.h"

@interface MButtonTabBarView()<M2TabBarViewDelegate>{
    M2TabBarView_A *_tabBarViewA;
}
@end

@implementation MButtonTabBarView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        // Initialization code
        _tabBarViewA = [[M2TabBarView_A alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 50) titles:@[@"新闻", @"财经", @"科技", @"轻松一刻"]];
        _tabBarViewA.backgroundColor = [UIColor lightGrayColor];
        _tabBarViewA.unSelectedTextColor = [UIColor whiteColor];
        _tabBarViewA.selectedTextColor = [UIColor blueColor];
        _tabBarViewA.seperarorLineViewHidden = YES;
        _tabBarViewA.delegate = self;
        [self addSubview:_tabBarViewA];
        
        UIButton *randomSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        randomSelectButton.frame = CGRectMake(100, CGRectGetMaxY(_tabBarViewA.frame) + 10, 120, 50);
        [randomSelectButton setTitle:@"随机选择" forState:UIControlStateNormal];
        [randomSelectButton setBackgroundImage:[UIImage imageNamed:@"white_rect"] forState:UIControlStateNormal];
        [randomSelectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [randomSelectButton addTarget:self action:@selector(onTapRandomSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:randomSelectButton];
    }
    
    return self;
}

#pragma mark - M2TabBarViewDelegate
- (void)tabBarView:(M2TabBarView_A *)tabBarView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"select index(%d)  @@%s", index, __func__);
}

#pragma mark - 
- (void)onTapRandomSelectButton:(UIButton *)sender{
    NSInteger index = arc4random() % 3;
    [sender setTitle:[NSString stringWithFormat:@"随机选择：%d", index] forState:UIControlStateNormal];
    [_tabBarViewA selectIndex:index animated:YES];
}

@end
