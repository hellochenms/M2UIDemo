//
//  M2CycleTabBarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：1.0
//  套件：M2CycleScrollSynchronizeProtocol
//  可选套件：M2CycleScrollView

#import <UIKit/UIKit.h>
#import "M2CycleScrollSynchronizeProtocol.h"
@protocol M2CycleTabBarViewDelegate;

@interface M2CycleTabBarView : UIView<M2CycleScrollSynchronizeProtocol>
- (id)initWithFrame:(CGRect)frame itemsCountPerPage:(NSInteger)itemsCountPerPage;
@property (nonatomic) NSArray *titles;
@property (nonatomic, weak) id<M2CycleTabBarViewDelegate> delegate;
@property (nonatomic, weak) id<M2CycleScrollSynchronizeProtocol> synchronizeObserver;
@end

@protocol M2CycleTabBarViewDelegate <NSObject>
- (void)tabBarView:(M2CycleTabBarView *)tabBarView didSelectedAtIndex:(NSInteger)index;
@end