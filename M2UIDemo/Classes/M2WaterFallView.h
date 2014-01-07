//
//  M2WaterFallView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2WaterFallViewDataSource;
@protocol M2WaterFallViewDelegate;

@interface M2WaterFallView : UIView<UITableViewDelegate>
@property (nonatomic, weak) id<M2WaterFallViewDataSource> dataSource;
@property (nonatomic, weak) id<M2WaterFallViewDelegate> delegate;
- (void)reloadData;
@end

@protocol M2WaterFallViewDataSource <NSObject>
@required
- (NSInteger)numberOfItemsForWaterFallView:(M2WaterFallView *)waterFallView;
- (UIView *)waterFallView:(M2WaterFallView *)waterFallView viewForIndex:(int)index;
@end

@protocol M2WaterFallViewDelegate <NSObject>
@optional
- (void)waterFallView:(M2WaterFallView *)waterFallView didSelectItemAtIndex:(int)index;
- (void)waterFallView:(M2WaterFallView *)waterFallView willRemoveView:(UIView *)view forIndex:(int)index;
@end