//
//  M2LoadingCoverView_B.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-28.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：B
//  版本：2.0
//  特点：
//      1、支持设置cancel区域，此区域触摸事件不会被拦截（例如被本cover覆盖的view的cancel区域上有个button，则该button的事件正常触发）
//      2、show时会将自己add到参数superView上


#import <UIKit/UIKit.h>

@interface M2LoadingCoverView_B : UIView
- (void)showInSuperView:(UIView *)superView cancelFrame:(CGRect)cancelFrame;
- (void)hide;
@end
