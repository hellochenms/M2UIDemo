//
//  M2WaterFallView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2WaterFallView.h"

#define M2WFV_ItemOffset 6000
#define M2WFV_BaseHeight 100
#define M2WFV_MaxHeightModifier 200
#define M2WFV_ClientViewTag 7000

@interface M2WaterFallView(){
    UIScrollView *_mainView;
    UIView *_lowestView;
    UIView *_justHigherThanLowestView;
}
@property (nonatomic) NSMutableArray *views;
@end

@implementation M2WaterFallView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //
        _views = [NSMutableArray array];
        
        //
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        [self addSubview:_mainView];
        
        //
        __weak M2WaterFallView *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reloadData];
        });
    }
    return self;
}

#pragma mark - public
- (void)reloadData{
    // clear old
    int oldCount = [_views count];
    BOOL isNeedNotityDelegate = (_delegate && [_delegate respondsToSelector:@selector(waterFallView:willRemoveView:forIndex:)]);
    UIView *oldItemContainer = nil;
    for (int i = 0; i < oldCount; i++) {
        oldItemContainer = [_views objectAtIndex:i];
        if (isNeedNotityDelegate) {
            [_delegate waterFallView:self willRemoveView:[oldItemContainer viewWithTag:M2WFV_ClientViewTag] forIndex:i];
            [oldItemContainer removeFromSuperview];
        }
    }
    _lowestView = nil;
    _justHigherThanLowestView = nil;
    
    // build new
    if (!_dataSource
        || ![_dataSource respondsToSelector:@selector(numberOfItemsForWaterFallView:)]
        || ![_dataSource respondsToSelector:@selector(waterFallView:viewForIndex:)]) {
        return;
    }
    int newCount = [_dataSource numberOfItemsForWaterFallView:self];
    if (newCount <= 0) {
        return;
    }
    UIView *newItemContainer = nil;
    UIView *clientView = nil;
    UITapGestureRecognizer *tap = nil;
    for (int i = 0; i < newCount; i++) {
        // container
        newItemContainer = [UIView new];
        if (i < newCount - 1) {
            [self modifyFrameOfItem:newItemContainer];
        }else{
            [self modifyFrameOfLastItem:newItemContainer];
        }
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapItem:)];
        [newItemContainer addGestureRecognizer:tap];
        newItemContainer.tag = M2WFV_ItemOffset + i;
        
        // client view
        clientView = [_dataSource waterFallView:self viewForIndex:i];
        clientView.frame = newItemContainer.bounds;
        clientView.tag = M2WFV_ClientViewTag;
        [newItemContainer addSubview:clientView];
        
        [_mainView addSubview:newItemContainer];
        [_views addObject:newItemContainer];
    }
    
    _mainView.contentSize = CGSizeMake(CGRectGetWidth(_mainView.bounds), CGRectGetMaxY(_lowestView.frame));
}

#pragma mark - 
- (void)modifyFrameOfItem:(UIView*)item{
    float width = CGRectGetWidth(self.bounds) / 2;
    float height = [self randomHeight];
    if (!_lowestView) {
        item.frame = CGRectMake(0, 0, width, height);
        _lowestView = item;
    }else if (!_justHigherThanLowestView){
        item.frame = CGRectMake(width, 0, width, height);
        _justHigherThanLowestView = item;
        [self tryModifyLowestView];
    }else{
        item.frame = CGRectMake(CGRectGetMinX(_justHigherThanLowestView.frame), CGRectGetMaxY(_justHigherThanLowestView.frame), width, height);
        _justHigherThanLowestView = item;
        [self tryModifyLowestView];
    }
}
// 最后一个的底部要和倒数第2个对齐，单独处理
- (void)modifyFrameOfLastItem:(UIView*)item{
    float width = CGRectGetWidth(self.bounds) / 2;
    float height = 0;
    if (!_lowestView) {
        height = [self randomHeight];
        item.frame = CGRectMake(0, 0, width, height);
        _lowestView = item;
    }else if (!_justHigherThanLowestView){
        height = CGRectGetHeight(_lowestView.frame);
        item.frame = CGRectMake(width, 0, width, height);
        _justHigherThanLowestView = item;
    }else{
        height = CGRectGetMaxY(_lowestView.frame) - CGRectGetMaxY(_justHigherThanLowestView.frame);
        item.frame = CGRectMake(CGRectGetMinX(_justHigherThanLowestView.frame), CGRectGetMaxY(_justHigherThanLowestView.frame), width, height);
        _justHigherThanLowestView = item;
    }
}

- (void)tryModifyLowestView{
    if (CGRectGetMaxY(_justHigherThanLowestView.frame) > CGRectGetMaxY(_lowestView.frame)) {
        UIView *temp = _lowestView;
        _lowestView = _justHigherThanLowestView;
        _justHigherThanLowestView = temp;
    }
}

#pragma mark - tap event
- (void)onTapItem:(UITapGestureRecognizer*)tap{
    if (_delegate && [_delegate respondsToSelector:@selector(waterFallView:didSelectItemAtIndex:)]) {
        [_delegate waterFallView:self didSelectItemAtIndex:tap.view.tag - M2WFV_ItemOffset];
    }
}

#pragma mark - tools
- (float)randomHeight{
    return M2WFV_BaseHeight + arc4random() % M2WFV_MaxHeightModifier;
}

@end
