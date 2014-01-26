//
//  M2ShowFromBottomView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2ShowFromBottomView.h"

#define MSFBV_DefaultContainerHeight    200
#define MSFBV_AnimationDuration         0.25

@interface M2ShowFromBottomView(){
    float _containerHeight;
}
@property (nonatomic) UIControl *coverView;
@property (nonatomic) UIView    *containerView;
@end

@implementation M2ShowFromBottomView

- (id)initWithFrame:(CGRect)frame{
    frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // cover
        _coverView = [[UIControl alloc] initWithFrame: [UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _coverView.alpha = 0;
        [_coverView addTarget:self action:@selector(onTapCover) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_coverView];
        
        // container
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), MSFBV_DefaultContainerHeight)];
        [self addSubview:_containerView];
    }
    
    return self;
}

#pragma mark - setter
- (void)setContentView:(UIView *)contentView{
    if ([contentView superview]) {
        return;
    }
    if (_contentView) {
        [_contentView removeFromSuperview];
    }
    
    _contentView = contentView;
    
    // 调整container
    _containerHeight = CGRectGetHeight(_contentView.bounds);
    CGRect frame = _containerView.frame;
    frame.size.height = _containerHeight;
    _containerView.frame = frame;
    
    [_containerView addSubview:_contentView];
}
- (void)show{
    if (_delegate && [_delegate respondsToSelector:@selector(willShowView:)]) {
        [_delegate willShowView:self];
    }
    
    UIView *view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view addSubview:self];
    CGRect frame = _containerView.frame;
    frame.origin.y = CGRectGetHeight(self.bounds) - CGRectGetHeight(_containerView.bounds);
    __weak M2ShowFromBottomView *weakSelf = self;
    [UIView animateWithDuration:MSFBV_AnimationDuration
                     animations:^{
                         weakSelf.coverView.alpha = 1;
                         weakSelf.containerView.frame = frame;
                     }];
}
- (void)hide{
    if (_delegate && [_delegate respondsToSelector:@selector(willHideView:)]) {
        [_delegate willHideView:self];
    }
    
    CGRect frame = _containerView.frame;
    frame.origin.y = CGRectGetHeight(self.bounds);
    __weak M2ShowFromBottomView *weakSelf = self;
    [UIView animateWithDuration:MSFBV_AnimationDuration
                     animations:^{
                         weakSelf.containerView.frame = frame;
                         weakSelf.coverView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }
     ];
}

#pragma mark - tap cover
- (void)onTapCover{
    [self hide];
}

@end
