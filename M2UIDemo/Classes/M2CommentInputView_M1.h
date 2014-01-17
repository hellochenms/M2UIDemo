//
//  M2CommentInputView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master
//  版本：1.0
//  特点：样式需要使用者定制

#import <UIKit/UIKit.h>

@protocol M2CommentInputViewDelegate;

@interface M2CommentInputView_M1 : UIView
@property (nonatomic, readonly) UIButton                        *submitButton;
@property (nonatomic, weak)     id<M2CommentInputViewDelegate>  delegate;
- (void)showWithReplyToUserName:(NSString *)userName;
- (void)hide;
@end

@protocol M2CommentInputViewDelegate <NSObject>
@optional
- (void)inputView:(M2CommentInputView_M1 *)inputView willChangeStateWithIsWillShow:(BOOL)willShow;
- (BOOL)inputView:(M2CommentInputView_M1 *)inputView checkText:(NSString*)text;
- (void)inputView:(M2CommentInputView_M1 *)inputView willSubmitAfterCheckWithText:(NSString*)text;
@end
