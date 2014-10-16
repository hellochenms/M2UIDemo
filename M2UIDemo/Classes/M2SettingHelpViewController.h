//
//  M2SettingHelpViewController.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-10-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface M2SettingHelpViewController : UIViewController
@property (nonatomic, readonly) UIButton *closeButton;
@property (nonatomic, copy) void (^tapCloseHandler)(void);
- (id)initWithImageNames:(NSArray *)imageNames;
@end
