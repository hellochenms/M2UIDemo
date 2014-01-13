//
//  MTMultiRowTabbarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master；
//  特点：只实现了最基本的功能，且Item没有公开，项目需要改造本类以定制；


#import <UIKit/UIKit.h>

#define M2MRTV_Default_ItemCountInRow 3

@protocol M2MultiRowTabbarViewDelegate;

@interface M2MultiRowTabBarView_Master : UIView
- (id)initWithFrame:(CGRect)frame
             titles:(NSArray*)titles
     itemCountInRow:(int)itemCountInRow;
@property (nonatomic, weak) id<M2MultiRowTabbarViewDelegate> delegate;
@end

@protocol M2MultiRowTabbarViewDelegate <NSObject>
- (void)tabBarView:(M2MultiRowTabBarView_Master *)tableView didSelectRowAtIndex:(int)index;
@end