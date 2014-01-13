//
//  MTMultiRowTabbarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define M2MRTV_Default_ItemCountInRow 3

@protocol M2MultiRowTabbarViewDelegate;

@interface M2MultiRowTabbarView_V1 : UIView
- (id)initWithFrame:(CGRect)frame
             titles:(NSArray*)titles
     itemCountInRow:(int)itemCountInRow;
@property (nonatomic, weak) id<M2MultiRowTabbarViewDelegate> delegate;
@end

@protocol M2MultiRowTabbarViewDelegate <NSObject>
- (void)onTapItemWithIndex:(int)index inView:(M2MultiRowTabbarView_V1*)view;
@end