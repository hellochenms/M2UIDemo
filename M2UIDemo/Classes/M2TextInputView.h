//
//  M2InputView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master
//  版本：1.0
//  特点：样式需要使用者定制

#import <UIKit/UIKit.h>

@protocol M2TextInputViewDelegate;

@interface M2TextInputView : UIView
@property (nonatomic, readonly) UIButton                        *cancelButton;
@property (nonatomic, readonly) UIButton                        *submitButton;
@property (nonatomic, weak)     id<M2TextInputViewDelegate>     delegate;
- (void)show;
- (void)hide;
@end

@protocol M2TextInputViewDelegate <NSObject>
@optional
- (void)inputView:(M2TextInputView *)inputView willChangeStateWithIsWillShow:(BOOL)willShow;
- (BOOL)inputView:(M2TextInputView *)inputView checkText:(NSString*)text;
- (void)inputView:(M2TextInputView *)inputView willSubmitAfterCheckWithText:(NSString*)text;
@end