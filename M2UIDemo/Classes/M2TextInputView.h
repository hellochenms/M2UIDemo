//
//  M2InputView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master
//  版本：2.0
//  分支特征：样式需要使用者定制

#import <UIKit/UIKit.h>

@protocol M2TextInputViewDelegate;

@interface M2TextInputView : UIView
@property (nonatomic, weak)     id<M2TextInputViewDelegate>     delegate;
- (id)initWithHeight:(CGFloat)height;
- (void)show;
@end

@protocol M2TextInputViewDelegate <NSObject>
@optional
- (BOOL)inputView:(M2TextInputView *)inputView checkText:(NSString*)text;
- (void)inputView:(M2TextInputView *)inputView willSubmitAfterCheckWithText:(NSString*)text;
@end