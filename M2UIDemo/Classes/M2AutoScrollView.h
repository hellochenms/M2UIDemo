//
//  AutoScrollView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2AutoScrollViewDataSource;
@protocol M2AutoScrollViewDelegate;

@interface M2AutoScrollView : UIView
@property (nonatomic, weak) id<M2AutoScrollViewDataSource>  dataSource;
@property (nonatomic, weak) id<M2AutoScrollViewDelegate>    delegate;
- (void)invalidate;
@end

@protocol M2AutoScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfCellsInAutoScrollView:(M2AutoScrollView *)autoScrollView;
- (UIView *)autoScrollView:(M2AutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index;
@end

@protocol M2AutoScrollViewDelegate <NSObject>
@optional
- (void)autoScrollView:(M2AutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index;
- (void)autoScrollView:(M2AutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index;
@end