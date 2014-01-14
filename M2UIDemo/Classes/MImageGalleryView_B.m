//
//  MImageGalleryView_B.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MImageGalleryView_B.h"
#import "M2GalleryView.h"
#import "MIGalleryViewCell_B.h"

@interface MImageGalleryView_B()<M2GalleryViewDataSource, M2GalleryViewDelegate> {
    M2GalleryView   *_galleryView;
    NSArray         *_imageNames;
}
@property (nonatomic) UIButton  *backButton;
@property (nonatomic) UILabel   *toolBarView;
@end

@implementation MImageGalleryView_B
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageNames = @[@"landscape_0.jpg", @"portrait_0.jpg", @"portrait_1.jpg", @"landscape_1.jpg"];
        
        //
        self.clipsToBounds = YES;
        
        //
        _galleryView = [[M2GalleryView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) withFullScreenHeight:CGRectGetHeight(frame)];
        _galleryView.backgroundColor = [UIColor blackColor];
        _galleryView.dataSource = self;
        _galleryView.delegate = self;
        UIPageControl *pageControl = [[UIPageControl new] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_galleryView.bounds), 30)];
        _galleryView.pageControl = pageControl;
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
        [self addSubview:_toolBarView];
    }
    return self;
}

#pragma mark - M2GalleryViewDataSource
- (NSInteger)numberOfItemsInGalleryView:(M2GalleryView *)galleryView{
    return [_imageNames count];
}
- (M2GalleryViewCell *)galleryView:(M2GalleryView *)galleryView itemAtIndex:(NSInteger)index{
    MIGalleryViewCell_B *view = [[MIGalleryViewCell_B alloc] initWithFrame: CGRectMake(0, 0, CGRectGetWidth(_galleryView.bounds), _galleryView.fullScreenHeight)];
    view.imageName = [_imageNames objectAtIndex:index];
    
    return view;
}

#pragma mark - M2GalleryViewDelegate
- (void)galleryView:(M2GalleryView *)galleryView willChangeIsFullScreen:(BOOL)isFullScreen withAnimationDuration:(float)animationDuration{
    CGRect backButtonFrame = [self backButtonFrameWithIsFullScreen:isFullScreen];
    CGRect toolBarViewFrame = [self toolBarViewFrameWithIsFullScreen:isFullScreen];
    __weak MImageGalleryView_B *weakSelf = self;
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
    float height = CGRectGetHeight(self.bounds) - _galleryView.originHeight;
    return CGRectMake(10, (isFullScreen ? CGRectGetHeight(self.bounds) : CGRectGetHeight(self.bounds) - height), CGRectGetWidth(self.bounds) - 10 * 2, height);
}
@end
