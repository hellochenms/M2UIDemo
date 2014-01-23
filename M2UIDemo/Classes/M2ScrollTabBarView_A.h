//
//  M2TabBarView_B.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：1.0
//  分支特点：1、tabBar支持滑动，且当前选中item位于tabBar中央；
//          2、使用者根据需要定制样式；

#import <UIKit/UIKit.h>

@protocol M2ScrollTabBarViewDelegate;

@interface M2ScrollTabBarView_A : UIView
@property (nonatomic) NSArray   *titles;
// 为了保持选中行在正中央，变量itemsCountInPage应赋奇数值，如果是偶数，会被修改为接近的奇数；
- (id)initWithFrame:(CGRect)frame itemsCountInPage:(NSInteger)itemsCountInPage;
- (void)selectIndex:(NSInteger)index;
@property (nonatomic, weak) id<M2ScrollTabBarViewDelegate> delegate;
@end

@protocol M2ScrollTabBarViewDelegate <NSObject>
// tabBar内部产生的事件会触发didSelectItemAtIndex通知（如点击item，或滑动tabBar），而外界事件（如通过selectIndex:方法设置index）不会触发；
- (void)tabBarView:(M2ScrollTabBarView_A *)tabBarView didSelectItemAtIndex:(NSInteger)index;
@end