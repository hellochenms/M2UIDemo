//
//  PadDDetailImageBrowerView.m
//  PadDetailPage
//
//  Created by Chen Meisong on 14-3-17.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import "PadDDetailImageBrowerView.h"
#import "../../KuaiGame/KuaiGame/CommonDefine.h"
#import "../../CoreUI/CoreUI/AsyncImageView.h"
#import "../../PhoneDetailPage/PhoneDetailPage/DDetailAutoRotateImageView.h"
#import "../../PhoneDetailPage/PhoneDetailPage/M2AutoRotateImageView.h"

@interface PadDDetailImageBrowerView()<UIScrollViewDelegate>
@property (nonatomic) UIView        *naviView;
@property (nonatomic) UILabel       *titleLabel;
@property (nonatomic) UIScrollView  *scrollView;
@property (nonatomic) NSArray       *urls;
@property (nonatomic) NSTimer       *timer;
@end

@implementation PadDDetailImageBrowerView
- (id)initWithImageUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds) - (ISIOS7 ? 0 : 20));
    frame.origin.y = CGRectGetHeight(frame);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _urls = urls;
        if ([_urls count] <= 0) {
            return self;
        }
        if (selectedIndex < 0 || selectedIndex > [_urls count] - 1) {
            selectedIndex = 0;
        }
        
        self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.96];
        
        // 导航区
        _naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), (ISIOS7 ? 20 :0) + 44)];
        _naviView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.96];
        [self addSubview:_naviView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_naviView.bounds) - 44, CGRectGetWidth(_naviView.bounds), 44)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = KA_COMMON_FONT_OF_SIZE(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = [NSString stringWithFormat:@"%d/%d", selectedIndex + 1, [_urls count]];
        [_naviView addSubview:_titleLabel];
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(CGRectGetWidth(frame) - 66, CGRectGetHeight(_naviView.bounds) - 44, 66, 44);
        finishButton.titleLabel.font = KA_COMMON_FONT_OF_SIZE(18);;
        [finishButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(onTapFinishButton) forControlEvents:UIControlEventTouchUpInside];
        [_naviView addSubview:finishButton];
        
        // 图片区
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        M2AutoRotateImageView *containerView = nil;
        DDetailAutoRotateImageView *contentView = nil;
        float itemWidth = CGRectGetWidth(_scrollView.bounds);
        float itemHeight = CGRectGetHeight(_scrollView.bounds);
        int count = [_urls count];
        for (int i = 0; i < count; i++) {
            containerView = [[M2AutoRotateImageView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight) isImagePortrait:NO];
            contentView = [[DDetailAutoRotateImageView alloc] initWithFrame:containerView.bounds];
            containerView.imageView = contentView;
            [_scrollView addSubview:containerView];
            [contentView loadImageFromUrlString:[[_urls objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(containerView.frame), CGRectGetHeight(_scrollView.bounds));
        [_scrollView setContentOffset:CGPointMake(itemWidth * selectedIndex, 0)];
        
        //
        [self bringSubviewToFront:_naviView];
        
        //
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMe)];
        [self addGestureRecognizer:tapRec];
        
        //
        [self startAutoHideTimer];
    }
    
    return self;
}

#pragma mark - public
- (void)show{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    __weak UIView *weakKeyView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakKeyView.userInteractionEnabled = NO;
                         weakSelf.frame = frame;
                     } completion:^(BOOL finished) {
                         weakKeyView.userInteractionEnabled = YES;
                     }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger)floorf((scrollView.contentOffset.x + 5) / CGRectGetWidth(scrollView.bounds));
    _titleLabel.text = [NSString stringWithFormat:@"%d/%d", index + 1, [_urls count]];
}

#pragma mark - event
- (void)onTapFinishButton{
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetWidth([UIScreen mainScreen].bounds);
    __weak UIView *weakKeyView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakKeyView.userInteractionEnabled = NO;
                         weakSelf.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                         weakKeyView.userInteractionEnabled = YES;
                     }];
}

- (void)onTapMe{
    [self changeNaviViewHideStatus:!_naviView.hidden];
}

#pragma mark - tools
- (void)changeNaviViewHideStatus:(BOOL)willHide{
    __weak typeof(self) weakSelf = self;
    if (willHide) {
        [_timer invalidate];
        [UIView animateWithDuration:0.5
                         animations:^{
                             weakSelf.naviView.alpha = 0;
                         } completion:^(BOOL finished) {
                             weakSelf.naviView.hidden = YES;
                         }];
    }else{
        _naviView.alpha = 0;
        _naviView.hidden = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             weakSelf.naviView.alpha = 1;
                         } completion:^(BOOL finished) {
                             [weakSelf startAutoHideTimer];
                         }];
    }
}

- (void)startAutoHideTimer{
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:4.5
                                              target:self
                                            selector:@selector(autoHide)
                                            userInfo:nil
                                             repeats:NO];
}

- (void)autoHide{
    [self changeNaviViewHideStatus:YES];
}


#pragma mark - dealloc
- (void)dealloc{
    [_timer invalidate];
}

@end
