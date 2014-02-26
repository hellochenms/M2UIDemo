//
//  M2CycleScrollView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：AF（F代表失败，不继续开发）
//  版本：0

#import <UIKit/UIKit.h>
@protocol M2CycleScrollViewDelegate_AF;

@interface M2CycleScrollView_AF : UIView
@property (nonatomic) NSArray *contentViews;
@property (nonatomic) NSInteger curLogicIndex;
@property (nonatomic, weak) id<M2CycleScrollViewDelegate_AF> delegate;
@end

@protocol M2CycleScrollViewDelegate_AF <NSObject>
- (void)cycleScrollView:(M2CycleScrollView_AF *)cycleScrollView changedCurIndexWithIsToNext:(BOOL)isToNext;
@end