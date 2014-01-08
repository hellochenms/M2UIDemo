//
//  M2InputView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2InputView.h"

@interface M2InputView()<UITextViewDelegate>
@property (nonatomic) UITextView   *textView;
@property (nonatomic) float         baseY;
@property (nonatomic) float         baseHeight;
@end

@implementation M2InputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];
        
        _baseY = CGRectGetMinY(frame);
        _baseHeight = CGRectGetHeight(frame);
        
        // buttons
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
        _cancelButton.backgroundColor = [UIColor blueColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 5 - 70, 5, 70, 30)];
        _submitButton.backgroundColor = [UIColor blueColor];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(onTapSubmitButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitButton];
      
        // text input
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_cancelButton.frame) + 5, CGRectGetWidth(frame) - 5 * 2, CGRectGetHeight(frame) - 5 * 3)];
        _textView.backgroundColor = [UIColor blueColor];
        _textView.delegate = self;
        [self addSubview:_textView];
        
        // listen
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

#pragma mark - public
- (void)show{
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:willChangeStateWithWillShow:)]) {
        [_delegate inputView:self willChangeStateWithWillShow:YES];
    }
    [_textView becomeFirstResponder];
}
- (void)hide{
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:willChangeStateWithWillShow:)]) {
        [_delegate inputView:self willChangeStateWithWillShow:NO];
    }
    [_textView resignFirstResponder];
}

#pragma mark - keyboard
- (void)onKeyboardWillShowNotification:(NSNotification*)notification{
    CGRect keyboardFrame = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    float animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self showWithKeyboradHeight:CGRectGetHeight(keyboardFrame) animationDuration:animationDuration];
}
- (void)onKeyboardWillHideNotification:(NSNotification*)notification{
    float animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [self hideWithAnimationDuration:animationDuration];
}

#pragma mark - 
- (void)showWithKeyboradHeight:(float)keyboradHeight animationDuration:(float)animationDuration{
    CGRect frame = self.frame;
    frame.size.height = _baseHeight + keyboradHeight;
    self.frame = frame;
    
    frame.origin.y = _baseY - frame.size.height;
    __weak M2InputView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.frame = frame;
                     }];
}
- (void)hideWithAnimationDuration:(float)animationDuration{
    CGRect frame = self.frame;
    frame.origin.y = _baseY;
    __weak M2InputView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.frame = frame;
                     } completion:^(BOOL finished) {
                         CGRect frame = weakSelf.frame;
                         frame.size.height = weakSelf.baseHeight;
                         weakSelf.frame = frame;
                         //
                         weakSelf.textView.text = nil;
                     }];
}

#pragma mark - 
- (void)onTapCancelButton{
    [self hide];
}
- (void)onTapSubmitButton{
    if (!_delegate){
        return;
    }
    if ([_delegate respondsToSelector:@selector(inputView:checkText:)]
        && ![_delegate inputView:self checkText:_textView.text]) {
            return;
    }
    if ([_delegate respondsToSelector:@selector(inputView:submitWithText:)]) {
        [_delegate inputView:self submitWithText:_textView.text];
    }
    
    [self hide];
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
