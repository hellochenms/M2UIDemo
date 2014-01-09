//
//  M2ScrollableViewObserver.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2ScrollableViewObserver.h"

@interface M2ScrollableViewObserver(){
    float _lastOffsetY;
    
}
@end

@implementation M2ScrollableViewObserver

- (id)init{
    self = [super init];
    if (self) {
        _offsetHeightThreshold = M2SVO_Default_OffsetHeightThreshold;
    }
    
    return self;
}

#pragma mark - M2ScrollableViewObserverObserveDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (_delegate && [_delegate respondsToSelector:@selector(disablePullDownBehaviorByObserver:)]) {
        [_delegate disablePullDownBehaviorByObserver:self];
    }
    _lastOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!_delegate
        || ![_delegate respondsToSelector:@selector(isAlreadyPushUpByObserver:)]
        || ![_delegate respondsToSelector:@selector(pushUpViewsByObserver:)]) {
        return;
    }
    if (scrollView.contentOffset.y - _lastOffsetY > 0
        && scrollView.contentOffset.y >= _offsetHeightThreshold
        && ![_delegate isAlreadyPushUpByObserver:self]) {
        [_delegate pushUpViewsByObserver:self];
    }
    _lastOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate
        && _delegate
        && [_delegate respondsToSelector:@selector(enablePullDownBehaviorByObserver:)]) {
        [_delegate enablePullDownBehaviorByObserver:self];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_delegate
        && [_delegate respondsToSelector:@selector(enablePullDownBehaviorByObserver:)]) {
        [_delegate enablePullDownBehaviorByObserver:self];
    }
}

@end
