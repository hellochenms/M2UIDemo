//
//  M2StatusBarToast.h
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-10.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define M2SBT_BgColor   ([[UIColor blackColor] colorWithAlphaComponent:0.618])

@interface M2StatusBarToast : UIWindow
+ (void)showText:(NSString*)text;
@end
