//
//  MKeyboardInputView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MKeyboardInputViewDelegate;

@interface MKeyboardInputView : UIView
@property (nonatomic, weak) id<MKeyboardInputViewDelegate> delegate;
@end

@protocol MKeyboardInputViewDelegate <NSObject>
- (void)willBeginEditingInkeyboardInputView:(MKeyboardInputView *)keyboardInputView;
- (void)willEndEditingInkeyboardInputView:(MKeyboardInputView *)keyboardInputView;
@end
