//
//  M2Cell3AutoScrollView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2Cell3AutoScrollView.h"

static const NSInteger kM2C3ASV_AutoScrollInterval = 5;

@interface M2Cell3AutoScrollView()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView      *scrollView;
@property (nonatomic) NSInteger         totalCount;
@property (nonatomic) NSInteger         curIndex;
@property (nonatomic) NSTimer           *timer;
@property (nonatomic) UIView            *curView;
@property (nonatomic) UIView            *preView;
@property (nonatomic) UIView            *nextView;
@property (nonatomic) BOOL              skipTimerCurLoop;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation M2Cell3AutoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
        
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapMe)];
        _tapRecognizer.enabled = NO;
        [_scrollView addGestureRecognizer:_tapRecognizer];
    }
    
    return self;
}

- (void)setDataSource:(id<M2Cell3AutoScrollViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData{
    // clear
    [self.timer invalidate];
    self.timer = nil;
    self.skipTimerCurLoop = NO;
    self.tapRecognizer.enabled = NO;
    [self.curView removeFromSuperview];
    self.curView = nil;
    [self.preView removeFromSuperview];
    self.preView = nil;
    [self.nextView removeFromSuperview];
    self.nextView = nil;
    self.totalCount = 0;
    self.curIndex = 0;
    
    // check
    if (!self.dataSource
        || ![self.dataSource respondsToSelector:@selector(numberOfCellsInAutoScrollView:)]
        || ![self.dataSource respondsToSelector:@selector(autoScrollView:cellAtIndex:)]) {
        return;
    }
    NSInteger cellCount = [self.dataSource numberOfCellsInAutoScrollView:self];
    if (cellCount <= 0) {
        return;
    }
    self.totalCount = cellCount;
    
    // build
    double cellWidth = CGRectGetWidth(self.scrollView.bounds);
    double cellHeight = CGRectGetHeight(self.scrollView.bounds);
    
    self.curView = [self.dataSource autoScrollView:self cellAtIndex:self.curIndex];
    [self.scrollView addSubview:self.curView];
    self.preView = [self.dataSource autoScrollView:self cellAtIndex:(self.curIndex - 1 + self.totalCount) % self.totalCount];
    [self.scrollView addSubview:self.preView];
    self.nextView = [self.dataSource autoScrollView:self cellAtIndex:(self.curIndex + 1) % self.totalCount];
    [self.scrollView addSubview:self.nextView];
    self.scrollView.contentSize = CGSizeMake(cellWidth * 3, cellHeight);
    [self layout3Cells];
    
    self.tapRecognizer.enabled = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kM2C3ASV_AutoScrollInterval target:self selector:@selector(onTimerFire) userInfo:nil repeats:YES];
}

- (void)layout3Cells{
    double cellWidth = CGRectGetWidth(self.scrollView.bounds);
    CGRect frame = CGRectMake(0, 0, cellWidth, CGRectGetHeight(self.scrollView.bounds));
    
    frame.origin.x = cellWidth;
    self.curView.frame = frame;
    
    frame.origin.x = 0;
    self.preView.frame = frame;
    
    frame.origin.x = cellWidth * 2;
    self.nextView.frame = frame;
    
    self.scrollView.contentOffset = CGPointMake(cellWidth, 0);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.skipTimerCurLoop = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self changeIndexFromOffsetX:scrollView.contentOffset.x];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self changeIndexFromOffsetX:scrollView.contentOffset.x];
}
- (void)changeIndexFromOffsetX:(double)offsetX{
    double cellWidth = CGRectGetWidth(self.scrollView.bounds);
    if (offsetX < 0.4) {
        self.curIndex--;
        self.curIndex = (self.curIndex + self.totalCount) % self.totalCount;
        [self.nextView removeFromSuperview];
        self.nextView = self.curView;
        self.curView = self.preView;
        self.preView = [self.dataSource autoScrollView:self cellAtIndex:(self.curIndex - 1 + self.totalCount) % self.totalCount];
        [self.scrollView addSubview:self.preView];
        [self layout3Cells];
        if (self.delegate && [self.delegate respondsToSelector:@selector(autoScrollView:didChangeIndexTo:)]) {
            [self.delegate autoScrollView:self didChangeIndexTo:self.curIndex];
        }
    }else if (offsetX > cellWidth + 0.6){
        self.curIndex++;
        self.curIndex = self.curIndex % self.totalCount;
        [self.preView removeFromSuperview];
        self.preView = self.curView;
        self.curView = self.nextView;
        self.nextView = [self.dataSource autoScrollView:self cellAtIndex:(self.curIndex + 1) % self.totalCount];
        [self.scrollView addSubview:self.nextView];
        [self layout3Cells];
        if (self.delegate && [self.delegate respondsToSelector:@selector(autoScrollView:didChangeIndexTo:)]) {
            [self.delegate autoScrollView:self didChangeIndexTo:self.curIndex];
        }
    }
}

#pragma mark -
- (void)onTimerFire{
    if (self.skipTimerCurLoop) {
        self.skipTimerCurLoop = NO;
        return;
    }
    double cellWidth = CGRectGetWidth(self.scrollView.bounds);
    double targetOffsetX = self.scrollView.contentOffset.x + cellWidth;
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         [weakSelf.scrollView setContentOffset:CGPointMake(targetOffsetX, 0)];
                     }
                     completion:^(BOOL finished) {
                         [weakSelf changeIndexFromOffsetX:weakSelf.scrollView.contentOffset.x];
                     }];
}

#pragma mark -
- (void)onTapMe{
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoScrollView:didSelectCellAtIndex:)]) {
        [self.delegate autoScrollView:self didSelectCellAtIndex:self.curIndex];
    }
}

#pragma mark - public
- (void)invalidate{
    [self.timer invalidate];
}

- (void)dealloc{
    self.scrollView.delegate = nil;
}

@end
