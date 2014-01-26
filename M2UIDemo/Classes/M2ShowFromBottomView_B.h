//
//  M2ShowFromBottomView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：B
//  版本：1.0
//  特点：增加show与hide通知，以适应弹出时需要加载（典型的如从网络加载）数据的场景；

#import <UIKit/UIKit.h>

@protocol M2ShowFromBottomViewDelegate;

@interface M2ShowFromBottomView : UIView
@property (nonatomic)       UIView *contentView;
@property (nonatomic, weak) id<M2ShowFromBottomViewDelegate> delegate;
- (void)show;
- (void)hide;
@end

@protocol M2ShowFromBottomViewDelegate <NSObject>
- (void)willShowView:(M2ShowFromBottomView *)view;
- (void)willHideView:(M2ShowFromBottomView *)view;
@end
