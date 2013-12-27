//
//  M2StatusBarToast.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-10.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "M2StatusBarToast.h"

@interface M2StatusBarToast(){
    UILabel *_textLabel;
}
@property (nonatomic) UIView  *containerView;
@property (nonatomic) BOOL    isShowing;
@end

@implementation M2StatusBarToast

+ (M2StatusBarToast*)sharedInstance{
    static M2StatusBarToast *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [M2StatusBarToast new];
    });
    
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.windowLevel = UIWindowLevelStatusBar + 1;
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.hidden = NO;
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.frame.size.width, self.frame.size.height)];
        _containerView.backgroundColor = M2SBT_BgColor;
        [self addSubview:_containerView];
        
        _textLabel = [[UILabel alloc] initWithFrame:_containerView.bounds];
        _textLabel.font = [UIFont systemFontOfSize: 12.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        [_containerView addSubview:_textLabel];
        
        [self adjustRotate:self.frame];
        // notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUIDeviceOrientationDidChangeNotification:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

- (void)showText:(NSString*)text{
    _textLabel.text = text;
    if (_isShowing) {
        return;
    }
    _isShowing = YES;

    __weak M2StatusBarToast *weakSelf = self;
    [UIView animateWithDuration:0.382
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.containerView.frame = CGRectMake(0, 0, _containerView.bounds.size.width, 20);
                     }
                     completion:^(BOOL finished) {
                         [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:1.236];
                     }];
}
- (void)hide{
    __weak M2StatusBarToast *weakSelf = self;
    [UIView animateWithDuration:0.382
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.containerView.frame = CGRectMake(0, -20, _containerView.bounds.size.width, 20);
                     }
                     completion:^(BOOL finished) {
                         weakSelf.isShowing = NO;
                     }];
}

#pragma mark - rotate
- (void)onUIDeviceOrientationDidChangeNotification:(NSNotification*)notification{
    CGRect frame = [UIApplication sharedApplication].statusBarFrame;
    [self adjustRotate:frame];
}
- (void)adjustRotate:(CGRect)frame{
    CGAffineTransform transform = CGAffineTransformIdentity;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation == UIInterfaceOrientationPortrait) {
        transform = CGAffineTransformIdentity;
    }else if (orientation == UIInterfaceOrientationPortraitUpsideDown){
        transform = CGAffineTransformMakeRotation(M_PI);
    }else if (orientation == UIInterfaceOrientationLandscapeLeft){
        transform = CGAffineTransformMakeRotation(M_PI / 2.0 * 3);
    }else if (orientation == UIInterfaceOrientationLandscapeRight){
        transform = CGAffineTransformMakeRotation(M_PI / 2.0);
    }
    self.alpha = 0.0;
    self.transform = transform;
    self.frame = frame;
    _containerView.frame = (_isShowing ? self.bounds : CGRectMake(0, -20, self.bounds.size.width, self.bounds.size.height));
    _textLabel.frame = _containerView.bounds;
    [UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration
                     animations:^{
                         self.alpha = 1.0;
                     }];
    
}

#pragma mark - public
+ (void)showText:(NSString*)text{
    [[M2StatusBarToast sharedInstance] showText:text];
}

@end
