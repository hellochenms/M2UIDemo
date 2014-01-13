//
//  M2MultiRowTabbarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-13.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master_A；
//  特点：在实现基本功能的基础上，增加禁用部分items的功能；
//  引用：（Master特点：只实现了最基本的功能，且Item没有公开，项目需要改造本类以定制；）

#import <UIKit/UIKit.h>

#define M2MRTV_Default_ItemCountInRow 3
#define M2MRTV_ItemHorizontalMargin 2
#define M2MRTV_ItemVerticalMargin   2

@protocol M2MultiRowTabbarViewDelegate;

@interface M2MultiRowTabBarView : UIView<UITableViewDelegate>
- (id)initWithFrame:(CGRect)frame
             titles:(NSArray*)titles
     itemCountInRow:(int)itemCountInRow;
@property (nonatomic, weak) id<M2MultiRowTabbarViewDelegate> delegate;
@property (nonatomic) NSArray *disableIndexs;// item is NSNumber;
@end

@protocol M2MultiRowTabbarViewDelegate <NSObject>
- (void)tabBarView:(M2MultiRowTabBarView *)tableView didSelectRowAtIndex:(int)index;
@end
