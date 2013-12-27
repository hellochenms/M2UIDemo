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

#warning TODO:请根据您帮助图片上开始按钮的位置，修正下述常量

// phone
#define M2HelpView_Phone_CloseButton_Width 130.0
#define M2HelpView_Phone_CloseButton_Height 45.0
#define M2HelpView_Phone_CloseButton_BottomMargin 45.0

// pad横屏
#define M2HelpView_PadLand_CloseButton_Width 300.0
#define M2HelpView_PadLand_CloseButton_Height 80.0
#define M2HelpView_PadLand_CloseButton_BottomMargin 100.0

@interface M2HelpView : UIView
+ (BOOL)hasShowHelpDone;
+ (void)showImageNames:(NSArray*)imageNames inController:(UIViewController*)controller;
@end
