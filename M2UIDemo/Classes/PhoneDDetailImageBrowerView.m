//
//  PhoneDHotDetailImageBrowerView.m
//  PhoneDetailPage
//
//  Created by Chen Meisong on 14-2-10.
//  Copyright (c) 2014年 yingmin zhu. All rights reserved.
//

#import "PhoneDDetailImageBrowerView.h"
#import "../../KuaiGame/KuaiGame/CommonDefine.h"
#import "../../CoreUI/CoreUI/AsyncImageView.h"
#import "DDetailAutoRotateImageView.h"
#import "M2AutoRotateImageView.h"
#import "../../CoreUI/CoreUI/CustomPageControl.h"

@interface PhoneDDetailImageBrowerView()<UIScrollViewDelegate>{
    UIScrollView        *_scrollView;
    CustomPageControl   *_pageControl;
    NSArray             *_urls;
}
@end

@implementation PhoneDDetailImageBrowerView
- (id)initWithImageUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex{
    CGRect frame = [[UIScreen mainScreen] bounds];
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
        
        float modifier = 0;
        if (ISIOS7) {
            modifier = 20;
        }
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectMake(0, modifier, CGRectGetWidth(frame), CGRectGetHeight(frame) - 20)];
        mainView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.97];
        [self addSubview:mainView];
        
        // navi区
        UIView *naviBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, modifier, CGRectGetWidth(frame), 44.5)];
        naviBackgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:naviBackgroundView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 44)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = KA_COMMON_FONT_OF_SIZE(18);//TODO
        titleLabel.text = @"屏幕快照";
        [naviBackgroundView addSubview:titleLabel];
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        finishButton.frame = CGRectMake(CGRectGetWidth(frame) - 50 - 10, 0, 50, 44);
        finishButton.titleLabel.font = KA_COMMON_FONT_OF_SIZE(18);//TODO
        [finishButton setTitleColor:COLOR_FROM_3HEX(01, 7a, fd) forState:UIControlStateNormal];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(onTapFinishButton) forControlEvents:UIControlEventTouchUpInside];
        [naviBackgroundView addSubview:finishButton];
        
        UIView *naviBottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, CGRectGetWidth(frame), 0.5)];
        naviBottomLineView.backgroundColor = COLOR_FROM_3HEX(bf, bf, bf);
        [naviBackgroundView addSubview:naviBottomLineView];
        
        // pageControl
        _pageControl = [[CustomPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainView.frame) - 30, CGRectGetWidth(mainView.frame), 30)];
        _pageControl.enabled = NO;
        _pageControl.unSelectedDot = @"detail_pagecontrol_normal";
        _pageControl.selectedDot = @"detail_pagecontrol_selected";
        _pageControl.numberOfPages = [urls count];
        _pageControl.currentPage = 0;
        [mainView addSubview:_pageControl];
        
        // 图片区
        float originY = 75;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(27, originY, CGRectGetWidth(mainView.frame) - 27 * 2, CGRectGetMinY(_pageControl.frame) - originY)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
        [mainView addSubview:_scrollView];
        
        M2AutoRotateImageView *containerView = nil;
        DDetailAutoRotateImageView *contentView = nil;
        float space = 8;
        float itemWidth = CGRectGetWidth(_scrollView.bounds) - space * 2;
        float itemHeight = CGRectGetHeight(_scrollView.bounds);
        int count = [_urls count];
        for (int i = 0; i < count; i++) {
            containerView = [[M2AutoRotateImageView alloc] initWithFrame:CGRectMake(space + (itemWidth + space * 2) * i, 0, itemWidth, itemHeight)];
            contentView = [[DDetailAutoRotateImageView alloc] initWithFrame:containerView.bounds hasBorder:YES];
            containerView.imageView = contentView;
            [_scrollView addSubview:containerView];
            [contentView loadImageFromUrlString:[[urls objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX(containerView.frame) + space, CGRectGetHeight(_scrollView.bounds));
        [_scrollView setContentOffset:CGPointMake((itemWidth + space * 2) * selectedIndex, 0)];
        _pageControl.currentPage = selectedIndex;
    }
    
    return self;
}

#pragma mark - public
- (void)show{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
    
    CGRect frame = self.frame;
    frame.origin.y = 0;
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.frame = frame;
                     }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger)floorf((scrollView.contentOffset.x + 5) / CGRectGetWidth(scrollView.bounds));
    _pageControl.currentPage = index;
}

#pragma mark - onTapFinishButton
- (void)onTapFinishButton{
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds);
    __weak UIView *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                     }];
}

@end
