//
//  M2CycleTabBarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol M2CycleTabBarViewDelegate;

@interface M2CycleTabBarView : UIView
@property (nonatomic, weak) id<M2CycleTabBarViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame itemsCountPerPage:(NSInteger)itemsCountPerPage;
- (void)selectPreItem;
- (void)selectNextItem;
@property (nonatomic) NSArray *titles;
@end

@protocol M2CycleTabBarViewDelegate <NSObject>
- (void)tabBarView:(M2CycleTabBarView *)tabBarView didSelectedAtIndex:(NSInteger)index;
@end