//
//  M2IconTabBarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-3.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2IconTabBarViewDelegate;

@interface M2IconTabBarView : UIView
@property (nonatomic)       UIColor                     *normalTextColor;
@property (nonatomic)       UIColor                     *selectedTextColor;
@property (nonatomic)       UIFont                      *itemFont;
@property (nonatomic)       UIColor                     *seperatorLineViewColor;
@property (nonatomic)       BOOL                        seperarorLineViewHidden;
@property (nonatomic)       UIColor                     *underLinerViewColor;
@property (nonatomic, weak) id<M2IconTabBarViewDelegate>    delegate;
- (void)loadTitle:(NSArray *)titles normalIconNames:(NSArray *)normalIconNames selectedIconNames:(NSArray *)selectedIconNames;
- (void)selectIndex:(NSInteger)index animated:(BOOL)animated;
@end

@protocol M2IconTabBarViewDelegate <NSObject>
- (void)tabBarView:(M2IconTabBarView *)tabBarView didSelectItemAtIndex:(NSInteger)index;
@end