//
//  MKeyboardInputView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MKeyboardInputView.h"
#import "M2InputView.h"
#import "M2Toast.h"

@interface MKeyboardInputView()<M2InputViewDelegate>{
    M2InputView *_inputView;
    UIButton    *_button;
}
@property (nonatomic) UIControl *coverView;
@end

@implementation MKeyboardInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = YES;
        
        //
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(10, 10, CGRectGetWidth(frame) - 10 * 2, 50);
        _button.backgroundColor = [UIColor blueColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitle:@"评论" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        //
        _coverView = [[UIControl alloc] initWithFrame: self.bounds];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_coverView addTarget:self action:@selector(onTapCover) forControlEvents:UIControlEventTouchUpInside];
        _coverView.hidden = YES;
        [self addSubview:_coverView];
        
        //
        _inputView = [[M2InputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), 120)];
        _inputView.delegate = self;
        [self addSubview:_inputView];
    }
    return self;
}

#pragma mark -
- (void)onTapButton{
    [_inputView show];
}
- (void)onTapCover{
    [_inputView hide];
}

#pragma mark - M2InputViewDelegate
- (void)inputView:(M2InputView *)inputView willChangeStateWithWillShow:(BOOL)willShow{
    __weak MKeyboardInputView *weakSelf = self;
    if (willShow) {
        weakSelf.coverView.alpha = 0;
        weakSelf.coverView.hidden = NO;
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.coverView.alpha = 1;
                         }];
    }else{
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.coverView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.coverView.hidden = YES;
                         }];
    }
}
- (BOOL)inputView:(M2InputView *)inputView checkText:(NSString*)text{
    if (text.length <= 0) {
        [M2Toast showText:@"内容不能为空"];
        return NO;
    }
    return YES;
}
- (void)inputView:(M2InputView *)inputView submitWithText:(NSString*)text{
    NSLog(@"submit(%@)  @@%s", text, __func__);
}

@end
