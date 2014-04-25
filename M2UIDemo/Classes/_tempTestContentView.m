//
//  _tempTestContentView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-4-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "_tempTestContentView.h"

@interface _tempTestContentView()
@property (nonatomic) UITextView *textView;
@end

@implementation _tempTestContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor redColor];

        _textView = [[UITextView alloc] initWithFrame:self.bounds];
        _textView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        [self addSubview:_textView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
