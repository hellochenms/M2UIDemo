//
//  M2LoadMoreView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M2LoadMoreViewDelegate;

@interface M2LoadMoreView : UIView
@property (nonatomic, weak) id<M2LoadMoreViewDelegate> delegate;
@property (nonatomic) BOOL ended;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)endLoading:(UIScrollView*)scrollView isSuccess:(BOOL)isSuccess;
@end

@protocol M2LoadMoreViewDelegate <NSObject>
- (void)onBeginLoadingMoreInView:(M2LoadMoreView*)view;
@end