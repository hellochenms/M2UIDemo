//
//  M2InputView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2InputViewDelegate;

@interface M2TextInputView : UIView
@property (nonatomic, readonly) UIButton *cancelButton;
@property (nonatomic, readonly) UIButton *submitButton;
@property (nonatomic, weak) id<M2InputViewDelegate> delegate;
- (void)show;
- (void)hide;
@end

@protocol M2InputViewDelegate <NSObject>
- (void)inputView:(M2TextInputView *)inputView willChangeStateWithIsWillShow:(BOOL)willShow;
- (BOOL)inputView:(M2TextInputView *)inputView checkText:(NSString*)text;
- (void)inputView:(M2TextInputView *)inputView willSubmitAfterCheckWithText:(NSString*)text;
@end