//
//  M2BaseRefreshView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-2.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2BaseRefreshViewDelegate;

@interface M2BaseRefreshView : UIView
@property (nonatomic)       NSDate *lastUpdateDate;
@property (nonatomic, weak) id<M2BaseRefreshViewDelegate> delegate;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)endLoading:(UIScrollView*)scrollView isSuccess:(BOOL)isSuccess;
@end

@protocol M2BaseRefreshViewDelegate <NSObject>
- (void)onBeginLoadingInView:(M2BaseRefreshView*)view;
@end