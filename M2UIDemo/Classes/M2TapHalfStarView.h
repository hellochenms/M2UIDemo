//
//  M2TapHalfStarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支： B
//  版本： 1.0
//  特点： 1、只支持点击设置星级；
//        2、grade为浮点型，可以输入及输出类似3.5的值；
//        3、支持生成view后在适当的时候用setup方法设置样式，常用于基类生成view，Phone和Pad版的子类中定制样式的场景；

#import <UIKit/UIKit.h>

#define M2THSV_DefaultStarCount 5

@protocol M2TapHalfStarViewDelegate;

@interface M2TapHalfStarView : UIView
@property (nonatomic, weak) id<M2TapHalfStarViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
        leftNormalImageName:(NSString*)leftNormalImageName
        leftSelectedImageName:(NSString*)leftSelectedImageName
        rightNormalImageName:(NSString*)rightNormalImageName
        rightSelectedImageName:(NSString*)rightSelectedImageName
        starCount:(NSInteger)starCount;
- (id)initWithStarCount:(NSInteger)starCount;
- (void)setupWithFrame:(CGRect)frame
   LeftNormalImageName:(NSString*)leftNormalImageName
 leftSelectedImageName:(NSString*)leftSelectedImageName
  rightNormalImageName:(NSString*)rightNormalImageName
rightSelectedImageName:(NSString*)rightSelectedImageName;
@property (nonatomic) float grade;
@end

@protocol M2TapHalfStarViewDelegate <NSObject>
- (void)halfStarView:(M2TapHalfStarView*)halfStarView didSelectedForGrade:(float)grade;
@end