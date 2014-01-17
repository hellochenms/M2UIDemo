//
//  MExtensibleItemTableView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-17.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MEITV_Key_Title @"title"
#define MEITV_Key_Items @"items"

@protocol MExtensibleItemTableViewDelegate;

@interface MExtensibleItemTableView : UIView
@property (nonatomic, weak) id<MExtensibleItemTableViewDelegate> delegate;
- (void)reloadData:(NSArray *)data;
@end

@protocol MExtensibleItemTableViewDelegate <NSObject>
- (void)didSelectSection:(NSInteger)section inView:(MExtensibleItemTableView *)view;
- (void)didSelectRow:(NSInteger)row inSection:(NSInteger)section inView:(MExtensibleItemTableView *)view;
@end