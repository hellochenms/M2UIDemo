//
//  MRotateImageView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MRotateImageView.h"
#import "MAdapterView.h"

@interface MRotateImageView(){
    MAdapterView *_contentView;
}
@end

@implementation MRotateImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code        
        M2AutoRotateImageView *containerView = [[M2AutoRotateImageView alloc] initWithFrame:CGRectMake(100, 10, 120, 220)];
        [self addSubview:containerView];
        _contentView = [[MAdapterView alloc] initWithFrame:containerView.bounds];
        containerView.imageView = _contentView;
        [_contentView loadImage];
        
        //
        UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        changeButton.frame = CGRectMake(120, CGRectGetMaxY(containerView.frame) + 20, 80, 50);
        [changeButton setTitle:@"换一张" forState:UIControlStateNormal];
        [changeButton addTarget:self action:@selector(onTapChangeButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:changeButton];
    }
    
    return self;
}

- (void)onTapChangeButton{
    [_contentView loadImage];
}

@end
