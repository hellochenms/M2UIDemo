//
//  M2TabbarView_A.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：2.0
//  分支特点：1、view背景、item分隔线、指示当前选中的下划线，只支持纯色；button默认透明；
//          2、tabbar中的item（1、只支持显示文本，不支持图像；2、只支持点击，不支持滑动）；

#import <UIKit/UIKit.h>

@protocol M2TabBarViewDelegate;

@interface M2TabBarView_A : UIView
@property (nonatomic)       NSArray                     *titles;
@property (nonatomic)       UIColor                     *unSelectedTextColor;
@property (nonatomic)       UIColor                     *selectedTextColor;
@property (nonatomic)       UIFont                      *itemFont;
@property (nonatomic)       UIColor                     *seperatorLineViewColor;
@property (nonatomic)       BOOL                        seperarorLineViewHidden;
@property (nonatomic)       UIColor                     *underLinerViewColor;
@property (nonatomic, weak) id<M2TabBarViewDelegate>    delegate;
- (void)selectIndex:(NSInteger)index animated:(BOOL)animated;
@end

@protocol M2TabBarViewDelegate <NSObject>
- (void)tabBarView:(M2TabBarView_A *)tabBarView didSelectItemAtIndex:(NSInteger)index;
@end