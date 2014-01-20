//
//  MKeyboardInputView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MKeyboardInputView.h"
#import "M2TextInputView.h"
#import "M2Toast.h"

@interface MKeyboardInputView()<M2TextInputViewDelegate>{
    M2TextInputView *_inputView;
    UIButton    *_button;
}
@property (nonatomic) UIControl *coverView;
@end

@implementation MKeyboardInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.clipsToBounds = YES;
        
        //
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(10, 10, CGRectGetWidth(frame) - 10 * 2, 50);
        _button.backgroundColor = [UIColor blueColor];
        _button.titleLabel.font = [UIFont systemFontOfSize:14];
        [_button setTitle:@"评论" forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
        
        // 输入view
        _inputView = [[M2TextInputView alloc] initWithHeight:120];
        _inputView.delegate = self;
    }
    return self;
}

#pragma mark -
- (void)onTapButton{
    [_inputView show];
}

#pragma mark - M2TextInputViewDelegate
- (BOOL)inputView:(M2TextInputView *)inputView checkText:(NSString*)text{
    if (text.length <= 0) {
        [M2Toast showText:@"内容不能为空"];
        return NO;
    }
    return YES;
}

@end
