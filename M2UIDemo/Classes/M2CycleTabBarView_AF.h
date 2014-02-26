//
//  M2CycleTabBarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：AF（F代表失败，不继续开发）
//  版本：0

#import <UIKit/UIKit.h>
@protocol M2CycleTabBarViewDelegate_AF;

@interface M2CycleTabBarView_AF : UIView
@property (nonatomic, weak) id<M2CycleTabBarViewDelegate_AF> delegate;
- (id)initWithFrame:(CGRect)frame itemsCountPerPage:(NSInteger)itemsCountPerPage;
- (void)selectPreItem;
- (void)selectNextItem;
@property (nonatomic) NSArray *titles;
@end

@protocol M2CycleTabBarViewDelegate_AF <NSObject>
- (void)tabBarView:(M2CycleTabBarView_AF *)tabBarView didSelectedAtIndex:(NSInteger)index;
@end