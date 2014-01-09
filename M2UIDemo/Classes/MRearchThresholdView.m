//
//  MRearchThresholdView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MRearchThresholdView.h"
#import "MScrollableView.h"
#import "M2ScrollableViewObserver.h"

#define MRTV_HiddenHeightWhenPushUp 250

@interface MRearchThresholdView()<M2ScrollableViewObserverResultDelegate>
@property (nonatomic) UIView                    *aboveView;
@property (nonatomic) MScrollableView           *scrollableView;
@property (nonatomic) M2ScrollableViewObserver  *scrollObserver;
@property (nonatomic) BOOL                      isAlreadyPushUp;
@property (nonatomic) float                     yWhenPanBegin;
@end

@implementation MRearchThresholdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        // Initialization code
        _aboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 300)];
        _aboveView.backgroundColor = [UIColor blackColor];
        _aboveView.layer.borderColor = [UIColor blueColor].CGColor;
        _aboveView.layer.borderWidth = 1;
        UIPanGestureRecognizer *aboveViewPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onAboveViewPan:)];
        [_aboveView addGestureRecognizer:aboveViewPan];
        
        UILabel *remainPartWhenPushUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MRTV_HiddenHeightWhenPushUp, CGRectGetWidth(_aboveView.frame), CGRectGetHeight(_aboveView.frame) - MRTV_HiddenHeightWhenPushUp)];
        remainPartWhenPushUpLabel.backgroundColor = [UIColor whiteColor];
        remainPartWhenPushUpLabel.textAlignment = NSTextAlignmentCenter;
        remainPartWhenPushUpLabel.font = [UIFont systemFontOfSize:14];
        remainPartWhenPushUpLabel.text = @"上部View被推上去后剩余的部分";
        [_aboveView addSubview:remainPartWhenPushUpLabel];
        [self addSubview:_aboveView];
        
        //
        _scrollableView = [[MScrollableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_aboveView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetHeight(_aboveView.bounds))];
        _scrollableView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_scrollableView];
        
        // observer
        _scrollObserver = [M2ScrollableViewObserver new];
        _scrollableView.observerDelegate = _scrollObserver; //作为它的delegate，观察这个view
        _scrollObserver.delegate = self; // 结果报告给自己的delegate
        
    }
    return self;
}

#pragma mark - M2ScrollableViewObserverResultDelegate
- (BOOL)isAlreadyPushUpByObserver:(M2ScrollableViewObserver *)observer{
    return self.isAlreadyPushUp;
}
- (void)disablePullDownBehaviorByObserver:(M2ScrollableViewObserver *)observer{
//    NSLog(@"开始推移，禁止下拉  @@%s", __func__);
    _aboveView.userInteractionEnabled = NO;
}
- (void)pushUpViewsByObserver:(M2ScrollableViewObserver *)observer{
    [self moveViewWithIsUp:YES];
}
- (void)enablePullDownBehaviorByObserver:(M2ScrollableViewObserver *)observer{
    _aboveView.userInteractionEnabled = YES;
//    NSLog(@"结束滑动，允许下拉  @@%s", __func__);
}

#pragma mark - move views
- (void)moveViewWithIsUp:(BOOL)isUp{
    _isAlreadyPushUp = isUp;
    float deltaHeight = isUp ? MRTV_HiddenHeightWhenPushUp : -MRTV_HiddenHeightWhenPushUp;
    if (isUp) {
        [_scrollableView changeFrameByDeltaHeight:deltaHeight];
    }
    
    float offsetY = isUp ? -MRTV_HiddenHeightWhenPushUp : MRTV_HiddenHeightWhenPushUp;
    CGRect aboveFrame = _aboveView.frame;
    aboveFrame.origin.y += offsetY;
    CGRect scrollableFrame = _scrollableView.frame;
    scrollableFrame.origin.y += offsetY;
    
    __weak MRearchThresholdView *weakSelf = self;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.aboveView.frame = aboveFrame;
                         weakSelf.scrollableView.frame = scrollableFrame;
                     }
                     completion:^(BOOL finished) {
                         if (!isUp) {
                             [weakSelf.scrollableView changeFrameByDeltaHeight:deltaHeight];
                         }
                         weakSelf.userInteractionEnabled = YES;
                     }];
}

#pragma mark - pan
- (void)onAboveViewPan:(UIPanGestureRecognizer*)pan{
    CGPoint point = CGPointZero;
    if (pan.state == UIGestureRecognizerStateBegan) {
        point = [pan translationInView:pan.view];
        _yWhenPanBegin = point.y;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        point = [pan translationInView:pan.view];
//        NSLog(@"point.y(%f)  @@%s", point.y, __func__);
    }else if (pan.state == UIGestureRecognizerStateEnded){
        point = [pan translationInView:pan.view];
        if (_isAlreadyPushUp
            && point.y > _yWhenPanBegin) {
            [self moveViewWithIsUp:NO];
        }
//        NSLog(@"point.y(%f), _yWhenPanBegin(%f)   @@%s", point.y, _yWhenPanBegin, __func__);
        _yWhenPanBegin = 0;
    }
}


@end
