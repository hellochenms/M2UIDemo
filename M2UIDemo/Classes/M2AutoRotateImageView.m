//
//  M2AutoRotateImageView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2AutoRotateImageView.h"

@interface M2AutoRotateImageView(){
    UIView *_container;
}
@end

@implementation M2AutoRotateImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
        
        _container = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_container];
    }
    return self;
}

- (void)setImageView:(UIView<M2AutoRotateImageViewProtocol> *)imageView{
    // clear
    [_imageView removeFromSuperview];
    _imageView = imageView;
    if (!_imageView) {
        return;
    }
    
    // add
    [_container addSubview:_imageView];
    if ([_imageView respondsToSelector:@selector(setDelegate:)]) {
        _imageView.delegate = self;
    }
    
    // modify
    if (_imageView.image) {
        [self modifyFrameOfView:_imageView];
        [self tryTransformOfItem:_imageView];
    }
}

// 根据图片宽高比调整item frame
- (void)modifyFrameOfView:(UIView<M2AutoRotateImageViewProtocol> *)imageView{
    float widthHeightFactor = 1;
    if (imageView.image.size.width > 0 && imageView.image.size.height > 0) {
        widthHeightFactor = imageView.image.size.width / imageView.image.size.height;
    }
    float itemWidth = 0;
    float itemHeight = 0;
    float containerWidth = CGRectGetWidth(self.bounds);
    float containerHeight = CGRectGetHeight(self.bounds);
    if (widthHeightFactor <= 1) {
        itemWidth = containerWidth;
        itemHeight = containerHeight;
    }else{
        itemWidth = containerHeight;
        itemHeight = containerWidth;
    }
    imageView.frame = CGRectMake((itemWidth - containerWidth) / 2 * (-1), 0, itemWidth, itemHeight);
    if ([imageView respondsToSelector:@selector(didChangedViewFrameFromView:)]) {
        [imageView didChangedViewFrameFromView:self];
    }
}
// 横屏图片要有旋转处理
- (void)tryTransformOfItem:(UIView<M2AutoRotateImageViewProtocol> *)imageView{
    float itemWidth = CGRectGetWidth(imageView.bounds);
    float itemHeight = CGRectGetHeight(imageView.bounds);
    if (itemWidth <= itemHeight) {
        return;
    }
    float centerYModifier = (itemWidth - itemHeight) / 2;
    CGAffineTransform transform = imageView.transform;
    transform = CGAffineTransformTranslate(transform, 0, centerYModifier);
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    imageView.transform = transform;
}

#pragma mark - M2AutoRotateImageViewDelegate
- (void)didLoadImageFinishFromView:(UIView<M2AutoRotateImageViewDelegate> *)view{
    if (_imageView.image) {
        _imageView.transform = CGAffineTransformIdentity;// 之前没有写这句，如果多次加载不同图片的话，会有影响；
        [self modifyFrameOfView:_imageView];
        [self tryTransformOfItem:_imageView];
    }
}

@end
