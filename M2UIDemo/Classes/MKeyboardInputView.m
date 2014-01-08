//
//  MKeyboardInputView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MKeyboardInputView.h"

@interface MKeyboardInputView()<UITextFieldDelegate>{
    UITextField *_textField;
    UIButton    *_button;
}
@end

@implementation MKeyboardInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        // Initialization code
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 5, CGRectGetWidth(frame) - 10 * 2, 50)];
        CGRect windowFrame = [UIScreen mainScreen].bounds;
        CGPoint point = [self convertPoint:CGPointMake(0, CGRectGetHeight(windowFrame)) fromView:[UIApplication sharedApplication].keyWindow];
        CGRect frame = _textField.frame;
        frame.origin.y = point.y - 10;
        _textField.backgroundColor = [UIColor blueColor];
        _textField.delegate = self;
        [self addSubview:_textField];
        
        //
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(10, 60, CGRectGetWidth(frame) - 10 * 2, 50);
        _button.backgroundColor = [UIColor blueColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitle:@"评论" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        //
    }
    return self;
}

#pragma mark -
- (void)onTapButton{
    if (_delegate && [_delegate respondsToSelector:@selector(willBeginEditingInkeyboardInputView:)]) {
        [_delegate willBeginEditingInkeyboardInputView:self];
    }
    [_textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(willBeginEditingInkeyboardInputView:)]) {
        [_delegate willBeginEditingInkeyboardInputView:self];
    }
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (_delegate && [_delegate respondsToSelector:@selector(willEndEditingInkeyboardInputView:)]) {
        [_delegate willEndEditingInkeyboardInputView:self];
    }
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
    return YES;
}

@end
