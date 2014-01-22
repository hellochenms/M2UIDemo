//
//  M2ImageGallery.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2ImageGalleryView_A.h"

#define M2IGV_AnimationDuration 0.25
#define M2IGV_ItemTag           6000

@interface M2ImageGalleryView_A(){
    UIScrollView    *_mainView;
}
@property (nonatomic) float             fullScreenHeight;
@property (nonatomic) NSMutableArray    *items;
@property (nonatomic) BOOL              isFullScreen;
@end

@implementation M2ImageGalleryView_A

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _fullScreenHeight = CGRectGetHeight(frame);
        _items = [NSMutableArray array];
        self.clipsToBounds = YES;
        
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        _mainView.pagingEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [_mainView addGestureRecognizer:tap];
        
        [self addSubview:_mainView];
    }
    
    return self;
}

#pragma mark - setter
- (void)setNotFullScreenHeight:(float)aNotFullScreenHeight{
    _notFullScreenHeight = aNotFullScreenHeight;
    CGRect selfFrame = self.frame;
    selfFrame.size.height = _notFullScreenHeight;
    self.frame = selfFrame;
}

#pragma mark - public
- (void)reloadDataWithImages:(NSArray *)images{
    // clear old
    UIView *oldContainer = nil;
    for (oldContainer in _items) {
        [oldContainer removeFromSuperview];
    }
    [_items removeAllObjects];
    _mainView.contentSize = CGSizeZero;
    
    // build new
    int newCount = [images count];
    if (newCount <= 0) {
        return;
    }
    UIImage *image = nil;
    UIView *newContainer = nil;
    UIImageView *newItem = nil;
    float containerWidth = CGRectGetWidth(_mainView.bounds);
    float containerHeight = CGRectGetHeight(_mainView.bounds);
    float itemWidth = _isLandscape ? containerHeight : containerWidth;
    float itemHeight = _isLandscape ? containerWidth : containerHeight;
    for (int i = 0; i < newCount; i++) {
        newContainer = [[UIView alloc] initWithFrame:CGRectMake(containerWidth * i, 0, containerWidth, containerHeight)];
        newContainer.clipsToBounds = YES;
        
        newItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight)];
        newItem.center = CGPointMake(containerWidth / 2, newItem.center.y);
        newItem.contentMode = UIViewContentModeScaleAspectFill;
        image = [images objectAtIndex:i];
        newItem.image = image;
        newItem.tag = M2IGV_ItemTag;
        [newContainer addSubview:newItem];
        
        [_mainView addSubview:newContainer];
        [_items addObject:newContainer];
    }

    newItem = [_items lastObject];
    _mainView.contentSize = CGSizeMake(CGRectGetMaxX(newItem.frame), CGRectGetHeight(_mainView.bounds));
}

#pragma mark - 
- (void)onTap:(UITapGestureRecognizer *)tap{
    NSLog(@"  @@%s", __func__);
    
    _isFullScreen = !_isFullScreen;
    if (_delegate && [_delegate respondsToSelector:@selector(galleryView:willChangeIsFullScreen:withAnimationDuration:)]) {
        [_delegate galleryView:self willChangeIsFullScreen:_isFullScreen withAnimationDuration:M2IGV_AnimationDuration];
    }

    __weak M2ImageGalleryView_A *weakSelf = self;
    [UIView animateWithDuration:M2IGV_AnimationDuration
                     animations:^{
                         // self
                         CGRect selfFrame = self.frame;
                         selfFrame.size.height = weakSelf.isFullScreen ? weakSelf.fullScreenHeight : weakSelf.notFullScreenHeight;
                         weakSelf.frame = selfFrame;
                         
                         // items
                         if (weakSelf.isLandscape) {
                             UIView *container = nil;
                             UIImageView *item = nil;
                             for (container in weakSelf.items) {
                                 item = (UIImageView *)[container viewWithTag:M2IGV_ItemTag];
                                 if (weakSelf.isFullScreen) {
                                     CGAffineTransform transform = item.transform;
                                     transform = CGAffineTransformTranslate(transform, 0, (CGRectGetHeight(self.bounds) - CGRectGetWidth(self.bounds)) / 2);
                                     transform = CGAffineTransformRotate(transform, M_PI_2);
                                     item.transform = transform;
                                 }else{
                                     item.transform = CGAffineTransformIdentity;
                                 }
                             }
                         }
                     }];
}

@end
