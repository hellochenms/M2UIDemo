//
//  M2ShowFromBottomView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：1.0

#import <UIKit/UIKit.h>

@interface M2ShowFromBottomView : UIView
@property (nonatomic) float     containerHeight;
@property (nonatomic) UIView    *contentView;
- (void)show;
@end
