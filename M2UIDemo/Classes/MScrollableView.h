//
//  MScrollableView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2ScrollableViewObserver.h"

@interface MScrollableView : UIView
@property (nonatomic, weak) id<M2ScrollableViewObserverObserveDelegate> observer;
- (void)changeFrameByDeltaHeight:(float)deltaHeight;
@end
