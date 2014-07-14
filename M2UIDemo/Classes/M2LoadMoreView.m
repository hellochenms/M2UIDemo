//
//  M2LoadMoreView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2LoadMoreView.h"

@interface M2LoadMoreView()
@property (nonatomic) BOOL loading;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic) UILabel *textLabel;
@property (nonatomic) UIActivityIndicatorView *indicatorView;
@end

@implementation M2LoadMoreView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;//TODO:
        
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMe)];
        _tapRecognizer.enabled = NO;
        [self addGestureRecognizer:_tapRecognizer];
        
        _textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.text = @"加载失败";
        _textLabel.hidden = YES;
        [self addSubview:_textLabel];
        
        float indicatorViewSideLength = CGRectGetHeight(self.bounds);
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, indicatorViewSideLength, indicatorViewSideLength)];
        _indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _indicatorView.center = CGPointMake(ceil(CGRectGetWidth(frame) / 2), ceil(CGRectGetHeight(frame) / 2));
        [self addSubview:_indicatorView];
    }
    
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.ended || self.loading) {
        return;
    }
    if ((scrollView.contentSize.height - (scrollView.contentOffset.y + CGRectGetHeight(scrollView.bounds))) <=(CGRectGetHeight(scrollView.bounds) / 2.0)) {
        self.loading = YES;
//        NSLog(@"准备加载下一页  %s", __func__);
        
        CGRect frame = self.frame;
        frame.origin.y = scrollView.contentSize.height;
        self.frame = frame;
        
        UIEdgeInsets inset = scrollView.contentInset;
        inset.bottom += CGRectGetHeight(self.bounds);
        scrollView.contentInset = inset;
        
        self.textLabel.hidden = YES;
        [self.indicatorView startAnimating];
        
        self.hidden = NO;
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(onBeginLoadingMoreInView:)]) {
            [self.delegate onBeginLoadingMoreInView:self];
        }
    }
}

- (void)endLoading:(UIScrollView*)scrollView isSuccess:(BOOL)isSuccess{
    if (isSuccess) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             weakSelf.alpha = 0;
                             UIEdgeInsets inset = scrollView.contentInset;
                             inset.bottom -= CGRectGetHeight(weakSelf.bounds);
                             scrollView.contentInset = inset;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.hidden = YES;
                             weakSelf.alpha = 1;
                             weakSelf.loading = NO;
                         }];
    } else {
        self.textLabel.hidden = NO;
        self.tapRecognizer.enabled = YES;
    }
    
    [self.indicatorView stopAnimating];
}

#pragma mark - 
- (void)onTapMe{
    self.tapRecognizer.enabled = NO;
    self.textLabel.hidden = YES;
    [self.indicatorView startAnimating];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBeginLoadingMoreInView:)]) {
        [self.delegate onBeginLoadingMoreInView:self];
    }
}

@end
