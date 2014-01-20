//
//  M2InputView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2TextInputView.h"

#define M2TIV_DefaultHeight 150

@interface M2TextInputView()<UITextViewDelegate>
@property (nonatomic) UIButton      *cancelButton;
@property (nonatomic) UIButton      *submitButton;
@property (nonatomic) UITextView    *textView;
@property (nonatomic) float         originY;
@property (nonatomic) float         contentAreaHeight;
@property (nonatomic) UIControl     *coverView;
@end

@implementation M2TextInputView

- (id)initWithFrame:(CGRect)frame{
    return [self initWithHeight:M2TIV_DefaultHeight];
}

- (id)initWithHeight:(CGFloat)height{
    _contentAreaHeight = height;
    CGRect frame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds), _contentAreaHeight + 200);// view在键盘正上方时，和键盘同样速度滑出时，会和键盘分开一小段时间，为避免此问题，将view实际高度增加一个值；
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _originY = CGRectGetMinY(frame);
        
        // self
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
        
        // buttons
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 30)];
        _cancelButton.backgroundColor = [UIColor grayColor];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(onTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
        
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 5 - 70, 5, 70, 30)];
        _submitButton.backgroundColor = [UIColor grayColor];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(onTapSubmitButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitButton];
      
        // text input
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_submitButton.frame) + 5, CGRectGetWidth(frame) - 5 * 2, _contentAreaHeight - CGRectGetMaxY(_submitButton.frame) - 5 - 10)];
        _textView.backgroundColor = [UIColor grayColor];
        _textView.delegate = self;
        [self addSubview:_textView];
        
        // cover
        _coverView = [[UIControl alloc] initWithFrame: [UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_coverView addTarget:self action:@selector(onTapCover) forControlEvents:UIControlEventTouchUpInside];
        _coverView.alpha = 0;
        
        // listen
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

#pragma mark - public
- (void)show{
    UIView *view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    [view addSubview:_coverView];
    [view addSubview:self];
    
    [_textView becomeFirstResponder];
}

#pragma mark - tap cover
- (void)onTapCover{
    [self hide];
    [self removeFromSuperview];
    [_coverView removeFromSuperview];
}

- (void)hide{
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
    frame.origin.y = _originY - (_contentAreaHeight + keyboradHeight);
    __weak M2TextInputView *weakSelf = self;
    _coverView.alpha = 0;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.frame = frame;
                         weakSelf.coverView.alpha = 1;
                     }];
}
- (void)hideWithAnimationDuration:(float)animationDuration{
    CGRect frame = self.frame;
    frame.origin.y = _originY;
    __weak M2TextInputView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.frame = frame;
                         weakSelf.coverView.alpha = 0;
                     } completion:^(BOOL finished) {
                         weakSelf.textView.text = nil;
                     }];
}

#pragma mark -
- (void)onTapCancelButton{
    [self hide];
}
- (void)onTapSubmitButton{
    if ([_delegate respondsToSelector:@selector(inputView:checkText:)]
        && ![_delegate inputView:self checkText:_textView.text]) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(inputView:willSubmitAfterCheckWithText:)]) {
        [_delegate inputView:self willSubmitAfterCheckWithText:_textView.text];
    }
    
    [self hide];
}

#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
