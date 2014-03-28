//
//  M2LoadingCoverView_B.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-28.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2LoadingCoverView_B.h"

@interface M2LoadingCoverView_B()
@property (nonatomic) UIActivityIndicatorView   *indicatorView;
@property (nonatomic) CGRect                    cancelFrame;
@end

@implementation M2LoadingCoverView_B

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.8];
        
        CGFloat indicatorSideLength = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 40 : 20);
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, indicatorSideLength, indicatorSideLength)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:_indicatorView];
        
        //
        [self adjustRotate];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUIDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
    return self;
}

#pragma mark - public
- (void)show{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    [_indicatorView startAnimating];
}

- (void)showInSuperView:(UIView *)superView cancelFrame:(CGRect)cancelFrame{
    _cancelFrame = cancelFrame;
    [superView addSubview:self];
    [_indicatorView startAnimating];
}

- (void)hide{
    [_indicatorView stopAnimating];
    [self removeFromSuperview];
}

#pragma mark - override
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(_cancelFrame, point)) {
//        NSLog(@"loadingCover：点击cancel区  @@%s", __func__);
        return NO;
    }
    return [super pointInside:point withEvent:event];
}

#pragma mark -
- (void)onUIDeviceOrientationDidChangeNotification:(NSNotification*)notification{
    [self adjustRotate];
}
- (void)adjustRotate{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    CGRect frame = [UIScreen mainScreen].bounds;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        frame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetWidth(frame));
    }
    self.frame = frame;
    _indicatorView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, CGRectGetHeight(self.bounds) / 3.0);
}

@end
