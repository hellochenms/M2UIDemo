//
//  M2CycleScrollView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2CycleScrollSynchronizeProtocol.h"
@protocol M2CycleScrollViewDelegate;

@interface M2CycleScrollView : UIView<M2CycleScrollSynchronizeProtocol>
@property (nonatomic) NSArray *contentViews;
@property (nonatomic, weak) id<M2CycleScrollViewDelegate> delegate;
@property (nonatomic, weak) id<M2CycleScrollSynchronizeProtocol> synchronizeObserver;
@end

@protocol M2CycleScrollViewDelegate <NSObject>
- (void)cycleScrollView:(M2CycleScrollView *)cycleScrollView didSelectedAtIndex:(NSInteger)index;
@end