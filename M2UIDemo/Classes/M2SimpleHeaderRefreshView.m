//
//  M2SimpleHeaderRefreshView.m
//  M2Common
//
//  Created by Chen Meisong on 14-6-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2SimpleHeaderRefreshView.h"

#define M2SHRV_DateTextPrefix   @"更新于："
#define M2SHRV_DateTextUnknown  @"未知"
#define M2SHRV_TriggerExtra     0

@interface M2SimpleHeaderRefreshView()
@property (nonatomic) UIImageView   *loadingView;
@property (nonatomic) UILabel       *dateLabel;
@property (nonatomic) BOOL          isLoading;

@end

@implementation M2SimpleHeaderRefreshView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _loadingView.image = [UIImage imageNamed:@"m2_72"];
        _loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, _loadingView.center.y);
        [self addSubview:_loadingView];
        
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 200, 15)];
        _dateLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, _dateLabel.center.y);
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.text = [NSString stringWithFormat:@"%@ %@", M2SHRV_DateTextPrefix ,M2SHRV_DateTextUnknown];
        [self addSubview:_dateLabel];
        
        self.alpha = 0;
    }
    
    return self;
}

#pragma mark -
- (void)refreshLayout{
    _loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, _loadingView.center.y);
    _dateLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, _dateLabel.center.y);
}

#pragma mark - public
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self refreshLastUpdateDate];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float insetTop = MIN(MAX(-1 * scrollView.contentOffset.y, 0), CGRectGetHeight(self.bounds));
    self.alpha = insetTop / CGRectGetHeight(self.bounds);
    if (_isLoading) {
        scrollView.contentInset = UIEdgeInsetsMake(insetTop, 0, 0, 0);
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!_isLoading
        && (-1 * scrollView.contentOffset.y)  > CGRectGetHeight(self.bounds) + M2SHRV_TriggerExtra
        && _delegate
        && [_delegate respondsToSelector:@selector(onBeginLoadingInView:)]) {
        _isLoading = YES;
        
        [self startLoadingAnimating];
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                         animations:^{
                             scrollView.contentInset = UIEdgeInsetsMake(weakSelf.bounds.size.height, 0, 0, 0);
                         }];
        if (_delegate && [_delegate respondsToSelector:@selector(onBeginLoadingInView:)]) {
            [_delegate onBeginLoadingInView:self];
        }
    }
}
- (void)endLoading:(UIScrollView*)scrollView isSuccess:(BOOL)isSuccess{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.2
                     animations:^{
                         scrollView.contentInset = UIEdgeInsetsZero;
                     } completion:^(BOOL finished) {
                         [weakSelf stopLoadingAnimating];
                         if (isSuccess) {
                             weakSelf.lastUpdateDate = [NSDate date];
                         }
                         weakSelf.isLoading = NO;
                     }];
}

#pragma mark - 更新时间
- (void)setLastUpdateDate:(NSDate *)lastUpdateDate{
    _lastUpdateDate = lastUpdateDate;
    [self refreshLastUpdateDate];
}
- (void)refreshLastUpdateDate{
    NSString *dateString = [NSString stringWithFormat:@"%@ %@", M2SHRV_DateTextPrefix, (_lastUpdateDate ? [self dateStringFromDate:_lastUpdateDate] : M2SHRV_DateTextUnknown)];
    _dateLabel.text = dateString;
}

#pragma mark - 加载中动画
- (void)startLoadingAnimating{
    CABasicAnimation *rotateAnima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnima.fromValue = [NSNumber numberWithFloat:0];
    rotateAnima.toValue = [NSNumber numberWithFloat: M_PI * 2];
    rotateAnima.duration = 2;
    rotateAnima.repeatCount = MAXFLOAT;
    [_loadingView.layer addAnimation:rotateAnima forKey:@"rotate"];
}
- (void)stopLoadingAnimating{
    [_loadingView.layer removeAnimationForKey:@"rotate"];
}

#pragma mark - 格式时间字符串
- (NSString *)dateStringFromDate:(NSDate *)date{
    NSString *dateString = nil;
    NSDate *now = [NSDate date];
    NSTimeInterval deltaSeconds = [now timeIntervalSince1970] - [date timeIntervalSince1970];
    if (deltaSeconds < 60) {
        dateString = [NSString stringWithFormat:@"刚刚"];
    }
    else if (deltaSeconds < 60 * 60) {
        float minute = floorf(deltaSeconds / 60);
        dateString = [NSString stringWithFormat:@"%.0f分钟前", minute];
    }else if (deltaSeconds < 60 * 60 * 24){
        float hour = floorf(deltaSeconds / 60 / 60);
        dateString = [NSString stringWithFormat:@"%.0f小时前", hour];
    }else{
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyy-MM-dd";
        dateString = [formatter stringFromDate:date];
    }
    
    return dateString;
}

@end
