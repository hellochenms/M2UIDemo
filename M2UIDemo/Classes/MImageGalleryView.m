//
//  MImageGalleryView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MImageGalleryView.h"
#import "M2ImageGalleryView.h"

#define MIGV_ImageCount 4

@interface MImageGalleryView()<M2ImageGalleryViewDelegate>{
    M2ImageGalleryView  *_galleryView;
    BOOL                _isLandscape;
}
@property (nonatomic) UIButton  *backButton;
@property (nonatomic) UILabel   *toolBarView;
@end

@implementation MImageGalleryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        _isLandscape = YES;
        
        // build
        _galleryView = [[M2ImageGalleryView alloc] initWithFrame:self.bounds];
        _galleryView.backgroundColor = [UIColor lightGrayColor];
        _galleryView.notFullScreenHeight = 100;
        _galleryView.delegate = self;
        [self addSubview:_galleryView];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = [self backButtonFrameWithIsFullScreen:NO];
        _backButton.backgroundColor = [UIColor blueColor];
        _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backButton setTitle:@"仿返回按钮" forState:UIControlStateNormal];
        [self addSubview:_backButton];
        
        _toolBarView = [[UILabel alloc] initWithFrame:[self toolBarViewFrameWithIsFullScreen:NO]];
        _toolBarView.userInteractionEnabled = YES;
        _toolBarView.backgroundColor = [UIColor blueColor];
        _toolBarView.textAlignment = NSTextAlignmentCenter;
        _toolBarView.font = [UIFont systemFontOfSize:14];
        _toolBarView.textColor = [UIColor whiteColor];
        _toolBarView.text = @"底部其他View";
        
        UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        refreshButton.frame = CGRectMake(CGRectGetWidth(_toolBarView.frame) - 5 - 150, 5, 150, 40);
        refreshButton.layer.borderColor = [UIColor whiteColor].CGColor;
        refreshButton.layer.borderWidth = 1;
        refreshButton.backgroundColor = [UIColor blueColor];
        refreshButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [refreshButton setTitle:@"切换Gallery的横竖屏" forState:UIControlStateNormal];
        [refreshButton addTarget:self action:@selector(onTapRefreshButton) forControlEvents:UIControlEventTouchUpInside];
        [_toolBarView addSubview:refreshButton];
        
        [self addSubview:_toolBarView];
        
        // refresh
        [self refreshGalleryViewWithIsLandscape:YES];
    }
    return self;
}

#pragma mark - M2ImageGalleryViewDelegate
- (void)galleryView:(M2ImageGalleryView *)galleryView willChangeIsFullScreen:(BOOL)isFullScreen withAnimationDuration:(float)animationDuration{
    CGRect backButtonFrame = [self backButtonFrameWithIsFullScreen:isFullScreen];
    CGRect toolBarViewFrame = [self toolBarViewFrameWithIsFullScreen:isFullScreen];
    __weak MImageGalleryView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.backButton.frame = backButtonFrame;
                         weakSelf.toolBarView.frame = toolBarViewFrame;
                     }];
}

#pragma mark - layout
- (CGRect)backButtonFrameWithIsFullScreen:(BOOL)isFullScreen{
    return CGRectMake((isFullScreen ? -80 : 10), 5, 80, 50);
}

- (CGRect)toolBarViewFrameWithIsFullScreen:(BOOL)isFullScreen{
    float height = CGRectGetHeight(self.bounds) - _galleryView.notFullScreenHeight;
    return CGRectMake(10, (isFullScreen ? CGRectGetHeight(self.bounds) : CGRectGetHeight(self.bounds) - height), CGRectGetWidth(self.bounds) - 10 * 2, height);
}

#pragma mark - 
- (void)onTapRefreshButton{
    _isLandscape = !_isLandscape;
    [self refreshGalleryViewWithIsLandscape:_isLandscape];
}

#pragma mark -
- (void)refreshGalleryViewWithIsLandscape:(BOOL)isLandscape{
    NSMutableArray *images = [NSMutableArray array];
    UIImage *image = nil;
    for (int i = 0; i < MIGV_ImageCount; i++) {
        image = [UIImage imageNamed:[NSString stringWithFormat:(isLandscape ? @"landscape_%d.jpg" : @"portrait_%d.jpg"), i]];
        [images addObject:image];
    }
    _galleryView.isLandscape = isLandscape;
    [_galleryView reloadDataWithImages:images];
}

@end
