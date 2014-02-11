//
//  M2AutoRotateImageView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A；
//  版本：1.0；
//  特点：只支持竖屏View，横屏图片（width大于height的图片）会被旋转为竖屏（-1/2 * M_PI）显示，竖屏图片保持不变；

#import <UIKit/UIKit.h>
@protocol M2AutoRotateImageViewProtocol;
@protocol M2AutoRotateImageViewDelegate <NSObject>
// @注意：实现了<M2AutoRotateImageViewProtocol>的View在image加载完毕后需要调用delegate的didLoadImageFinishFromView：；
- (void)didLoadImageFinishFromView:(UIView<M2AutoRotateImageViewProtocol> *)view;
@end

@interface M2AutoRotateImageView : UIView<M2AutoRotateImageViewDelegate>
@property (nonatomic) UIView<M2AutoRotateImageViewProtocol> *imageView;
@end

@protocol M2AutoRotateImageViewProtocol <NSObject>
@property (nonatomic) UIImage *image;
@optional
@property (nonatomic) id<M2AutoRotateImageViewDelegate> delegate;
- (void)didChangedViewFrameFromView:(M2AutoRotateImageView *)view;
@end


