//
//  M2CommentInputView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CommentInputView.h"

@interface M2CommentInputView()<UITextViewDelegate>{
    UILabel *_repleyToUserLabel;
}
@property (nonatomic)       UITextView  *textView;
@property (nonatomic)       float       baseY;
@property (nonatomic)       float       baseHeight;
@end

@implementation M2CommentInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1;
        
        _baseY = CGRectGetMinY(frame);
        _baseHeight = CGRectGetHeight(frame);
        
        // 回复目标
        _repleyToUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
        _repleyToUserLabel.backgroundColor = [UIColor clearColor];
        _repleyToUserLabel.font = [UIFont systemFontOfSize:12];
        _repleyToUserLabel.textColor = [UIColor whiteColor];
        [self addSubview:_repleyToUserLabel];
        
        // 提交
        _submitButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - 5 - 70, 5, 70, 30)];
        _submitButton.backgroundColor = [UIColor grayColor];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(onTapSubmitButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_submitButton];
        
        // text input
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_submitButton.frame) + 5, CGRectGetWidth(frame) - 5 * 2, CGRectGetHeight(frame) - CGRectGetMaxY(_submitButton.frame) - 5)];
        _textView.backgroundColor = [UIColor grayColor];
        _textView.delegate = self;
        [self addSubview:_textView];
        
        // listen
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

#pragma mark - public
- (void)showWithReplyToUserName:(NSString *)userName{
    if (userName.length <= 0) {
        _repleyToUserLabel.text = @"回复";
    }else{
        _repleyToUserLabel.text = [NSString stringWithFormat:@"回复：%@", userName];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:willChangeStateWithIsWillShow:)]) {
        [_delegate inputView:self willChangeStateWithIsWillShow:YES];
    }
    [_textView becomeFirstResponder];
}
- (void)hide{
    if (_delegate && [_delegate respondsToSelector:@selector(inputView:willChangeStateWithIsWillShow:)]) {
        [_delegate inputView:self willChangeStateWithIsWillShow:NO];
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
    __weak M2CommentInputView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.frame = frame;
                     }];
}
- (void)hideWithAnimationDuration:(float)animationDuration{
    CGRect frame = self.frame;
    frame.origin.y = _baseY;
    __weak M2CommentInputView *weakSelf = self;
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
