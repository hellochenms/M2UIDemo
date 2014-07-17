//
//  M2Cell3AutoScrollView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2Cell3AutoScrollViewDataSource;
@protocol M2Cell3AutoScrollViewDelegate;

@interface M2Cell3AutoScrollView : UIView
@property (nonatomic, weak) id<M2Cell3AutoScrollViewDataSource>  dataSource;
@property (nonatomic, weak) id<M2Cell3AutoScrollViewDelegate>    delegate;
- (void)invalidate;
@end

@protocol M2Cell3AutoScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfCellsInAutoScrollView:(M2Cell3AutoScrollView *)autoScrollView;
- (UIView *)autoScrollView:(M2Cell3AutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index;
@end

@protocol M2Cell3AutoScrollViewDelegate <NSObject>
@optional
- (void)autoScrollView:(M2Cell3AutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index;
- (void)autoScrollView:(M2Cell3AutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index;
@end
