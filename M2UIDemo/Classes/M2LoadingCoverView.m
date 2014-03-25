//
//  M2LoadingCoverView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-25.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2LoadingCoverView.h"

@interface M2LoadingCoverView()
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation M2LoadingCoverView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
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

- (void)hide{
    [_indicatorView stopAnimating];
    [self removeFromSuperview];
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
