//
//  M2TapStarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 13-1-24.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：1.0
//  特点：只支持点击设置星级；

#import <UIKit/UIKit.h>

@protocol M2TapStarViewDelegate;

@interface M2TapStarView : UIView

@property (nonatomic, assign) id<M2TapStarViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
    normalImageName:(NSString*)normalImageName
  selectedImageName:(NSString*)selectedImageName;
- (id)initWithFrame:(CGRect)frame
    normalImageName:(NSString*)normalImageName
  selectedImageName:(NSString*)selectedImageName
          itemCount:(int)itemCount
    horizontalSpace:(float)horizontalSpace;
@property (nonatomic) NSInteger grade;
@end

@protocol M2TapStarViewDelegate <NSObject>
- (void)starView:(M2TapStarView*)starView didSelectedForGrade:(NSInteger)grade;
@end
