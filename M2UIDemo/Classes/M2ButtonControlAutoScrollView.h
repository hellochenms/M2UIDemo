//
//  M2ButtonControlAutoScrollView.h
//  M2UIDemo
//
//  Created by thatsoul on 15/6/29.
//  Copyright (c) 2015年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2ButtonControlAutoScrollViewDataSource;
@protocol M2ButtonControlAutoScrollViewDelegate;

@interface M2ButtonControlAutoScrollView : UIView

@property (nonatomic, weak) id<M2ButtonControlAutoScrollViewDataSource>  dataSource;
@property (nonatomic, weak) id<M2ButtonControlAutoScrollViewDelegate>    delegate;
@property (nonatomic) BOOL scrollClipToBounds;
- (void)invalidate;
- (void)turnPageLeft;
- (void)turnPageRight;
@end

@protocol M2ButtonControlAutoScrollViewDataSource <NSObject>
@required
- (NSInteger)numberOfCellsInAutoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView;
- (UIView *)autoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index;
@end

@protocol M2ButtonControlAutoScrollViewDelegate <NSObject>
@optional
- (void)autoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index;
- (void)autoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index;
@end
