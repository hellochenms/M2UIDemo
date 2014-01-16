//
//  M2ShowFullInfoView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master
//  版本：1.0

#import <UIKit/UIKit.h>

@protocol M2ExtensibleInfoViewDelegate;

@interface M2ExtensibleInfoView : UIView
@property (nonatomic, readonly) UILabel     *titleLabel;
@property (nonatomic, readonly) UILabel     *infoLabel;
@property (nonatomic, readonly) UILabel     *ellipsisLabel;
@property (nonatomic, readonly) UILabel     *extendLabel;
@property (nonatomic)           int         maxNumberOfLinesWhenNotExtend;
@property (nonatomic, weak)     id<M2ExtensibleInfoViewDelegate> delegate;
- (void)reloadData:(NSString*)text;
@end

@protocol M2ExtensibleInfoViewDelegate <NSObject>
- (void)extensibleInfoView:(M2ExtensibleInfoView *)extensibleInfoView willExtendToFrame:(CGRect)frame animationDuration:(float)animationDuration;
@end
