//
//  M2Toast.h
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-10.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define M2T_Width   220
#define M2T_Height  40
#define M2T_Font    ([UIFont systemFontOfSize: 15.0])

@interface M2Toast : UIView
+ (void)showText:(NSString*)text;
@end
