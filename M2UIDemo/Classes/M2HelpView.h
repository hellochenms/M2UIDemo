//
//  M2HelpView.h
//  M2Common
//
//  Created by Chen Meisong on 13-7-17.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//
// version:1.1
// 检查Info.plist中的版本号来决定是否显示本帮助页

#import <UIKit/UIKit.h>

@interface M2HelpView : UIView
@property (nonatomic, readonly) UIButton *closeButton;
+ (BOOL)hasShowHelpDone;
- (id)initWithImageNames:(NSArray*)imageNames;
- (void)showInController:(UIViewController*)controller;
@end
