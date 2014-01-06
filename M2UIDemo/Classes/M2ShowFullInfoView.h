//
//  M2ShowFullInfoView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol M2ShowFullInfoViewDelegate;

@interface M2ShowFullInfoView : UIView
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UILabel *infoLabel;
@property (nonatomic, readonly) UIButton *showFullInfoButton;
@property (nonatomic) float maxHeight;
@property (nonatomic, weak) id<M2ShowFullInfoViewDelegate> delegate;
- (void)reloadData:(NSString*)info;
@end

@protocol M2ShowFullInfoViewDelegate <NSObject>
- (void)changeToHeight:(float)height animationDuration:(float)animationDuration ofView:(M2ShowFullInfoView*)view;
@end
