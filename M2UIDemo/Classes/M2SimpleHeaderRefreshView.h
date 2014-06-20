//
//  M2SimpleHeaderRefreshView.h
//  M2Common
//
//  Created by Chen Meisong on 14-6-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol M2SimpleHeaderRefreshViewDelegate;

@interface M2SimpleHeaderRefreshView : UIView
@property (nonatomic)           NSDate  *lastUpdateDate;
@property (nonatomic, readonly) BOOL    isLoading;
@property (nonatomic, weak) id<M2SimpleHeaderRefreshViewDelegate> delegate;
- (void)refreshLayout;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)endLoading:(UIScrollView*)scrollView isSuccess:(BOOL)isSuccess;
@end

@protocol M2SimpleHeaderRefreshViewDelegate <NSObject>
- (void)onBeginLoadingInView:(M2SimpleHeaderRefreshView*)view;
@end
