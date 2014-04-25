//
//  _tempTestView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-4-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "_tempTestView.h"
#import "_tempTestContentView.h"

@interface _tempTestView()
@property (nonatomic) _tempTestContentView *contentView;
@end

@implementation _tempTestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        // Initialization code
        _contentView = [[_tempTestContentView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(self.bounds), 100)];
        [self addSubview:_contentView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification*)notification{
    NSValue *frameValue = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    float animaDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    NSLog(@"keyBoardView:(%@)  @@%s", NSStringFromCGRect([frameValue CGRectValue]), __func__);
    float keyBoardOriginY = CGRectGetMinY([frameValue CGRectValue]);
    
    float originY_ = [self convertPoint:CGPointMake(0, keyBoardOriginY) fromView:[UIApplication sharedApplication].keyWindow].y;
    
    NSLog(@"keyBoardOriginY(%f), originY_(%f)  @@%s", keyBoardOriginY, originY_, __func__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
