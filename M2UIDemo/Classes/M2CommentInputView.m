//
//  M2CommentInputViewB.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-17.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2CommentInputView.h"

#define M2CIV_DefaultHeight 150

@interface M2CommentInputView()<UITextViewDelegate>{
    UILabel     *_repleyToUserLabel;
    UIButton    *_submitButton;
}
@property (nonatomic)       UITextView  *textView;
@property (nonatomic)       float       originY;
@property (nonatomic)       float       contentAreaHeight;
@property (nonatomic)       UIControl   *coverView;
@end

@implementation M2CommentInputView

- (id)initWithFrame:(CGRect)frame{
    return [self initWithHeight:M2CIV_DefaultHeight];
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
    [self showWithReplyToUserName:nil];
}
- (void)showWithReplyToUserName:(NSString *)userName{
    if (userName.length <= 0) {
        _repleyToUserLabel.text = @"评论";
    }else{
        _repleyToUserLabel.text = [NSString stringWithFormat:@"回复：%@", userName];
    }
    
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
    __weak M2CommentInputView *weakSelf = self;
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
    __weak M2CommentInputView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.frame = frame;
                         weakSelf.coverView.alpha = 0;
                     } completion:^(BOOL finished) {
                         weakSelf.textView.text = nil;
                     }];
}

#pragma mark -
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