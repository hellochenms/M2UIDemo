//
//  M2Toast.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-10.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "M2Toast.h"

@interface M2Toast(){
    UILabel *_textLabel;
}
@end

@implementation M2Toast

- (id)init{
    return [self initWithFrame:CGRectMake(0.0, 0.0, M2T_Width, M2T_Height)];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.618];
        CGRect frame = [UIScreen mainScreen].bounds;
        self.center = CGPointMake(frame.size.width / 2.0, frame.size.height / 3.0);
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 5.0, 200.0, 30.0)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = UITextAlignmentCenter;
        _textLabel.font = M2T_Font;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.center = CGPointMake(M2T_Width / 2.0, M2T_Height / 2.0);
        [self addSubview:_textLabel];
        
    }
    return self;
}

#pragma mark - private
- (void)showText:(NSString*)text{
    if ([self superview]) {
        return;
    }
    _textLabel.text = text;
    self.alpha = 0;
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    __weak M2Toast *weakSelf = self;
    [UIView animateWithDuration:0.382
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf performSelector:@selector(hide) withObject:nil afterDelay:1.236];
                     }];
}
- (void)hide{
    __weak M2Toast *weakSelf = self;
    [UIView animateWithDuration:0.382
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakSelf.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
}

#pragma mark - public
+ (void)showText:(NSString*)text{
    M2Toast *toast = [M2Toast new];
    [toast showText:text];
}

@end
