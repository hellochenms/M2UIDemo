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

@interface MRearchThresholdView()<M2ScrollableViewObserverResultDelegate>{
    UIView                      *_aboveView;
    MScrollableView             *_scrollableView;
    M2ScrollableViewObserver    *_scrollableViewObserver;
    float                       _heightModifier;
    float                       _yWhenPanBegin;
}
@property (nonatomic) UIView                    *mainView;
@property (nonatomic) BOOL                      isAlreadyPushUp;
@end

@implementation MRearchThresholdView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        // Initialization code
        _mainView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_mainView];
        
        _aboveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 300)];
        _aboveView.backgroundColor = [UIColor blackColor];
        _aboveView.layer.borderColor = [UIColor blueColor].CGColor;
        _aboveView.layer.borderWidth = 1;
        [_mainView addSubview:_aboveView];
        
        UILabel *remainPartWhenPushUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_aboveView.frame) - 60, CGRectGetWidth(_aboveView.frame), 60)];
        remainPartWhenPushUpLabel.backgroundColor = [UIColor whiteColor];
        remainPartWhenPushUpLabel.textAlignment = NSTextAlignmentCenter;
        remainPartWhenPushUpLabel.font = [UIFont systemFontOfSize:14];
        remainPartWhenPushUpLabel.text = @"上部View被推上去后剩余的部分";
        [_aboveView addSubview:remainPartWhenPushUpLabel];
        
        
        // scroll View
        _scrollableView = [[MScrollableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_aboveView.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - CGRectGetHeight(_aboveView.bounds))];
        _scrollableView.backgroundColor = [UIColor lightGrayColor];
        _scrollableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [_mainView addSubview:_scrollableView];
        
        // observer
        // scrollView上滑观察者
        _scrollableViewObserver = [M2ScrollableViewObserver new];
        _scrollableViewObserver.delegate = self;
        _scrollableView.observer = _scrollableViewObserver;
        // tabBar上推下拉识别
        UIPanGestureRecognizer *panRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [_aboveView addGestureRecognizer:panRec];
        _heightModifier = CGRectGetMinY(_aboveView.frame) + CGRectGetMinY(remainPartWhenPushUpLabel.frame) - 20;
    }
    return self;
}

#pragma mark - M2ScrollableViewObserverResultDelegate
- (BOOL)isAlreadyPushUpByObserver:(M2ScrollableViewObserver *)observer{
    return _isAlreadyPushUp;
}
- (void)disablePullDownBehaviorByObserver:(M2ScrollableViewObserver *)observer{
    NSLog(@"请暂时禁用下拉行为  @@%s", __func__);
    _aboveView.userInteractionEnabled = NO;
}
- (void)pushUpViewsByObserver:(M2ScrollableViewObserver *)observer{
    NSLog(@"请上推View  @@%s", __func__);
    [self moveToTop:YES];
}
- (void)enablePullDownBehaviorByObserver:(M2ScrollableViewObserver *)observer{
    NSLog(@"请恢复禁用下拉行为  @@%s", __func__);
    _aboveView.userInteractionEnabled = YES;
}

#pragma mark - pan
- (void)onPan:(UIPanGestureRecognizer*)pan{
    CGPoint point = CGPointZero;
    if (pan.state == UIGestureRecognizerStateBegan) {
        point = [pan translationInView:pan.view];
        _yWhenPanBegin = point.y;
    }else if (pan.state == UIGestureRecognizerStateChanged){
        point = [pan translationInView:pan.view];
    }else if (pan.state == UIGestureRecognizerStateEnded){
        point = [pan translationInView:pan.view];
        if (_isAlreadyPushUp
            && point.y > _yWhenPanBegin) {
            [self moveToTop:NO];
        }else if (!_isAlreadyPushUp && point.y < _yWhenPanBegin){
            [self moveToTop:YES];
        }
        _yWhenPanBegin = 0;
    }
}

#pragma mark - 推移view
- (void)moveToTop:(BOOL)toTop{
    if (toTop) {
        _isAlreadyPushUp = YES;
    }
    CGRect mainFrame = _mainView.frame;
    
    if (toTop) {
        mainFrame.origin.y -= _heightModifier;
        mainFrame.size.height += _heightModifier;
    }else{
        mainFrame.origin.y += _heightModifier;
        mainFrame.size.height -= _heightModifier;
    }
    __weak MRearchThresholdView *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.mainView.frame = mainFrame;
                     } completion:^(BOOL finished) {
                         if (!toTop){
                             weakSelf.isAlreadyPushUp = NO;
                         }
                     }];
}


@end
