//
//  M2CommentInputViewB.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-17.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master
//  版本：2.0
//  分支特征：样式需要使用者定制

#import <UIKit/UIKit.h>

@protocol M2CommentInputViewDelegate;

@interface M2CommentInputView : UIView
@property (nonatomic, weak)     id<M2CommentInputViewDelegate>  delegate;
- (id)initWithHeight:(CGFloat)height;
- (void)show;
- (void)showWithReplyToUserName:(NSString *)userName;
@end

@protocol M2CommentInputViewDelegate <NSObject>
@optional
- (BOOL)inputView:(M2CommentInputView *)inputView checkText:(NSString*)text;
- (void)inputView:(M2CommentInputView *)inputView willSubmitAfterCheckWithText:(NSString*)text;
@end