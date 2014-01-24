//
//  MCoverView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCoverView.h"
#import "M2ShowFromBottomView.h"

#define MCV_ButtonTagOffset 6000

@interface MCoverView(){
    M2ShowFromBottomView *_showView;
}
@end

@implementation MCoverView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIButton *showCoverView = [UIButton buttonWithType:UIButtonTypeCustom];
        showCoverView.frame = CGRectMake(100, 10, 120, 50);
        showCoverView.backgroundColor = [UIColor blueColor];
        [showCoverView setTitle:@"Show" forState:UIControlStateNormal];
        [showCoverView addTarget:self action:@selector(OnTapShowCoverButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:showCoverView];
        
        _showView = [M2ShowFromBottomView new];
        _showView.containerHeight = 300;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 300 - 10 * 2)];
        contentView.backgroundColor = [UIColor lightGrayColor];
        _showView.contentView = contentView;
        
        UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sinaButton.frame = CGRectMake(10, 10, CGRectGetWidth(contentView.bounds) - 10 * 2, 50);
        sinaButton.backgroundColor = [UIColor redColor];
        [sinaButton setTitle:@"分享到新浪微博" forState:UIControlStateNormal];
        [sinaButton addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        sinaButton.tag = MCV_ButtonTagOffset;
        [contentView addSubview:sinaButton];
        
        UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        weixinButton.frame = CGRectMake(10, CGRectGetMaxY(sinaButton.frame) + 10, CGRectGetWidth(contentView.bounds)- 10 * 2, 50);
        weixinButton.backgroundColor = [UIColor greenColor];
        [weixinButton setTitle:@"分享到微信" forState:UIControlStateNormal];
        [weixinButton addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
        weixinButton.tag = MCV_ButtonTagOffset + 1;
        [contentView addSubview:weixinButton];
        
    }
    
    return self;
}

#pragma mark -
- (void)OnTapShowCoverButton{
    [_showView show];
}

#pragma mark - 
- (void)onTapButton:(UIButton *)sender{
    NSInteger index = sender.tag - MCV_ButtonTagOffset;
    NSLog(@"分享到%@  @@%s", (index == 0 ? @"新浪微博" : @"微信"), __func__);
}

@end
