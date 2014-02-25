//
//  M2CycleScrollView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol M2CycleScrollViewDelegate;

@interface M2CycleScrollView : UIView
@property (nonatomic) NSArray *contentViews;
@property (nonatomic) NSInteger curLogicIndex;
@property (nonatomic, weak) id<M2CycleScrollViewDelegate> delegate;
@end

@protocol M2CycleScrollViewDelegate <NSObject>
- (void)cycleScrollView:(M2CycleScrollView *)cycleScrollView changedCurIndexWithIsToNext:(BOOL)isToNext;
@end