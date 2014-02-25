//
//  MAdapterView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "M2AutoRotateImageView.h"

@interface MAdapterView : UIView<M2AutoRotateImageViewProtocol>
@property (nonatomic) UIImage *image;
@property (nonatomic, weak) id<M2AutoRotateImageViewDelegate> delegate;
- (void)loadImage;
@end
