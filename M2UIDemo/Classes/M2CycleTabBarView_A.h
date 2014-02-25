//
//  M2CycleTabBarView_A.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：0.1
//  特点：最简版只实现了循环tabBar的思路

#import <UIKit/UIKit.h>
@protocol M2CycleTabBarViewDelegate;

@interface M2CycleTabBarView_A : UIView
@property (nonatomic, weak) id<M2CycleTabBarViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame itemsCountInPage:(NSInteger)itemsCountInPage titles:(NSArray *)titles;
@end

@protocol M2CycleTabBarViewDelegate <NSObject>
- (void)tabBarView:(M2CycleTabBarView_A *)tabBarView didSelectedAtIndex:(NSInteger)index;
@end