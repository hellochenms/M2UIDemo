//
//  M2BaseRefreshView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-2.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "M2BaseRefreshView.h"

#define M2BRV_Hint_Pull         @"下拉可以刷新"
#define M2BRV_Hint_Relase       @"松开即可刷新"
#define M2BRV_Hint_Loading      @"加载中..."
#define M2BRV_DateTextPrefix    @"上次更新："

@interface M2BaseRefreshView()
@property (nonatomic) CALayer                   *arrowImageViewLayer;
@property (nonatomic) UIActivityIndicatorView   *loadingView;
@property (nonatomic) UILabel                   *textLabel;
@property (nonatomic) UILabel                   *dateLabel;
@property (nonatomic) BOOL                      isLoading;

@end

@implementation M2BaseRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        // create
        _arrowImageViewLayer = [CALayer layer];
        _arrowImageViewLayer.frame = CGRectMake(0, 0, 20, 50);
        _arrowImageViewLayer.contents = (id)[UIImage imageNamed:@"refresh_blue_arrow"].CGImage;
        [self.layer addSublayer:_arrowImageViewLayer];
        
        _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadingView.frame = CGRectMake(0, 0, 20, 20);
        [self addSubview:_loadingView];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _textLabel.text = M2BRV_Hint_Pull;
        [self addSubview:_textLabel];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 15)];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.text = [NSString stringWithFormat:@"%@ %@", M2BRV_DateTextPrefix ,@"未知"];
        [self addSubview:_dateLabel];
        
        // layout
        _arrowImageViewLayer.frame = CGRectMake(frame.size.width / 2 - _arrowImageViewLayer.bounds.size.width - 50, frame.size.height / 2 - _arrowImageViewLayer.bounds.size.height / 2, _arrowImageViewLayer.bounds.size.width, _arrowImageViewLayer.bounds.size.height);
        _loadingView.frame = CGRectMake(frame.size.width / 2 - _arrowImageViewLayer.bounds.size.width - 50, frame.size.height / 2 - _loadingView.bounds.size.height / 2, _loadingView.bounds.size.width, _loadingView.bounds.size.height);
        _textLabel.frame = CGRectMake(_arrowImageViewLayer.frame.origin.x + _arrowImageViewLayer.bounds.size.width + 10, 5, _textLabel.bounds.size.width, _textLabel.bounds.size.height);
        _dateLabel.frame = CGRectMake(_textLabel.frame.origin.x, _textLabel.frame.origin.y + _textLabel.frame.size.height, _dateLabel.bounds.size.width, _dateLabel.bounds.size.height);
    }
    
    return self;
}



#pragma mark - public
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"  @@%s", __func__);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"  @@%s", __func__);
    if (_isLoading) {
        float insetTop = MIN(MAX(-1 * scrollView.contentOffset.y, 0), self.bounds.size.height);
        scrollView.contentInset = UIEdgeInsetsMake(insetTop, 0, 0, 0);
        return;
    }
    
    if (!scrollView.isDragging) {
        return;
    }
    
    if (scrollView.contentOffset.y < -1 * self.bounds.size.height - 10) {
        _arrowImageViewLayer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        _textLabel.text = M2BRV_Hint_Relase;
    }else{
        _arrowImageViewLayer.transform = CATransform3DIdentity;
        _textLabel.text = M2BRV_Hint_Pull;
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"  @@%s", __func__);
    if (!_isLoading
        && scrollView.contentOffset.y < -1 * self.bounds.size.height - 10
        && _delegate
        && [_delegate respondsToSelector:@selector(onBeginLoadingInView:)]) {
        _isLoading = YES;
        // UI
        _arrowImageViewLayer.opacity = 0;
        [_loadingView startAnimating];
        _textLabel.text = M2BRV_Hint_Loading;
        __weak M2BaseRefreshView *weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             scrollView.contentInset = UIEdgeInsetsMake(weakSelf.bounds.size.height, 0, 0, 0);
                         }];
        // delegate
        [_delegate onBeginLoadingInView:self];
    }
}

- (void)endLoading:(UIScrollView*)scrollView isSuccess:(BOOL)isSuccess{
    // UI
    __weak M2BaseRefreshView *weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         scrollView.contentInset = UIEdgeInsetsZero;
                     } completion:^(BOOL finished) {
                         weakSelf.arrowImageViewLayer.transform = CATransform3DIdentity;
                         weakSelf.arrowImageViewLayer.opacity = 1;
                         [weakSelf.loadingView stopAnimating];
                         weakSelf.textLabel.text = M2BRV_Hint_Pull;
                         if (isSuccess) {
                             weakSelf.lastUpdateDate = [NSDate date];
                         }
                         weakSelf.isLoading = NO;
                     }];
}

#pragma mark - setter
- (void)setLastUpdateDate:(NSDate *)lastUpdateDate{
    _lastUpdateDate = lastUpdateDate;
    _dateLabel.text = [self refreshLastUpdateDate];
}

#pragma mark -
- (NSString*)refreshLastUpdateDate{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = [NSString stringWithFormat:@"%@ %@", M2BRV_DateTextPrefix, @"yyyy-MM-dd HH:mm:ss"];
    
    return [formatter stringFromDate:_lastUpdateDate];
}

@end
