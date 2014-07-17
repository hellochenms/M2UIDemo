//
//  AutoScrollView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2AutoScrollView.h"

static const NSInteger kM2ASV_AutoScrollInterval = 5;

@interface M2AutoScrollView()<UIScrollViewDelegate>
@property (nonatomic) UIScrollView      *scrollView;
@property (nonatomic) NSMutableArray    *cells;
@property (nonatomic) NSInteger         totalCount;
@property (nonatomic) NSInteger         curIndex;
@property (nonatomic) NSTimer           *timer;
@property (nonatomic) BOOL              skipTimerCurLoop;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation M2AutoScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _cells = [NSMutableArray array];
        
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

- (void)setDataSource:(id<M2AutoScrollViewDataSource>)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

- (void)reloadData{
    // clear
    [self.timer invalidate];
    self.timer = nil;
    self.skipTimerCurLoop = NO;
    self.tapRecognizer.enabled = NO;
    
    UIView *cell = nil;
    for (cell in self.cells) {
        [cell removeFromSuperview];
    }
    [self.cells removeAllObjects];
    self.scrollView.contentSize = CGSizeZero;
    
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
    
    if (cellCount  == 1) {
        for (NSInteger i = 0; i < cellCount; i++) {
            cell = [self.dataSource autoScrollView:self cellAtIndex:i];
            NSAssert(cell != nil, @"cell should not be nil!");
            cell.frame = CGRectMake(cellWidth * i, 0, cellWidth, cellHeight);
            [self.scrollView addSubview:cell];
            [self.cells addObject:cell];
        }
        self.scrollView.contentSize = CGSizeMake(cellWidth * cellCount, cellHeight);
    }else{
        for (NSInteger i = 0; i < cellCount; i++) {
            cell = [self.dataSource autoScrollView:self cellAtIndex:i];
            NSAssert(cell != nil, @"cell should not be nil!");
            cell.frame = CGRectMake(cellWidth * (i + 1), 0, cellWidth, cellHeight);
            [self.scrollView addSubview:cell];
            [self.cells addObject:cell];
        }
        UIView *leftAdditionalCell = [self.dataSource autoScrollView:self cellAtIndex:cellCount - 1];
        leftAdditionalCell.frame = CGRectMake(0, 0, cellWidth, cellHeight);
        [self.scrollView addSubview:leftAdditionalCell];
        [self.cells insertObject:leftAdditionalCell atIndex:0];
        UIView *rightAdditionalCell = [self.dataSource autoScrollView:self cellAtIndex:0];
        rightAdditionalCell.frame = CGRectMake(cellWidth * (cellCount + 1), 0, cellWidth, cellHeight);
        [self.scrollView addSubview:rightAdditionalCell];
        [self.cells addObject:rightAdditionalCell];
        self.scrollView.contentSize = CGSizeMake(cellWidth * (cellCount + 2), cellHeight);
        
        self.scrollView.contentOffset = CGPointMake(cellWidth, 0);
    }
    
    self.tapRecognizer.enabled = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kM2ASV_AutoScrollInterval target:self selector:@selector(onTimerFire) userInfo:nil repeats:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.skipTimerCurLoop = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"contentOffsetX(%f)  %s", scrollView.contentOffset.x, __func__);
    if (self.totalCount <= 1) {
        return;
    }
    double cellWidth = CGRectGetWidth(scrollView.bounds);
    double offsetX = scrollView.contentOffset.x;
    if (offsetX < cellWidth * 0.4) {
//        NSLog(@"到达左边界，调整contentOffsetX  %s", __func__);
        [scrollView setContentOffset:CGPointMake(offsetX + cellWidth * self.totalCount, 0)];
    }else if (offsetX > cellWidth * (self.totalCount + 0.6)){
//        NSLog(@"到达右边界，调整contentOffsetX  %s", __func__);
        [scrollView setContentOffset:CGPointMake(offsetX - cellWidth * self.totalCount, 0)];
    }
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
    NSInteger index = offsetX / cellWidth;
    index--;
    if (index == -1) {
        index = self.totalCount - 1;
    }else if (index == self.totalCount){
        index = 0;
    }
    self.curIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoScrollView:didChangeIndexTo:)]) {
        [self.delegate autoScrollView:self didChangeIndexTo:self.curIndex];
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
    [self.scrollView setContentOffset:CGPointMake(targetOffsetX, 0) animated:YES];
    [self changeIndexFromOffsetX:targetOffsetX];
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
