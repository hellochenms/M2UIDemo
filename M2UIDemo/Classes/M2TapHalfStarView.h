//
//  M2TapHalfStarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：1.0
//  特点：1、只支持点击设置星级；

#import <UIKit/UIKit.h>

@protocol M2TapHalfStarViewDelegate;

@interface M2TapHalfStarView : UIView
@property (nonatomic, weak) id<M2TapHalfStarViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
        leftNormalImageName:(NSString*)leftNormalImageName
        leftSelectedImageName:(NSString*)leftSelectedImageName
        rightNormalImageName:(NSString*)rightNormalImageName
        rightSelectedImageName:(NSString*)rightSelectedImageName
        starCount:(NSInteger)starCount;
@property (nonatomic) float grade;
@end

@protocol M2TapHalfStarViewDelegate <NSObject>
- (void)halfStarView:(M2TapHalfStarView*)halfStarView didSelectedForGrade:(float)grade;
@end