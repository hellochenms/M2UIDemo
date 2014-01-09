//
//  M2ScrollableViewObserver.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define M2SVO_Default_OffsetHeightThreshold 10

@protocol M2ScrollableViewObserverObserveDelegate <NSObject>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@end
@protocol M2ScrollableViewObserverResultDelegate;

@interface M2ScrollableViewObserver : NSObject <M2ScrollableViewObserverObserveDelegate>
@property (nonatomic)       float offsetHeightThreshold;
@property (nonatomic, weak) id<M2ScrollableViewObserverResultDelegate> delegate;
@end

@protocol M2ScrollableViewObserverResultDelegate <NSObject>
- (BOOL)isAlreadyPushUpByObserver:(M2ScrollableViewObserver *)observer;
- (void)disablePullDownBehaviorByObserver:(M2ScrollableViewObserver *)observer;
- (void)pushUpViewsByObserver:(M2ScrollableViewObserver *)observer;
- (void)enablePullDownBehaviorByObserver:(M2ScrollableViewObserver *)observer;
@end