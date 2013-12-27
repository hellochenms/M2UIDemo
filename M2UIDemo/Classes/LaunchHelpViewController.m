//
//  LaunchHelpViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-12.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "LaunchHelpViewController.h"
#import "M2HelpView.h"

@interface LaunchHelpViewController ()

@end

@implementation LaunchHelpViewController

- (void)loadView{
    self.view = [UIView new];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 70, 300, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"显示启动帮助" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTapButton:(UIButton*)button{
    [M2HelpView showImageNames:@[@"help_phone0.jpg", @"help_phone1.jpg", @"help_phone2.jpg", @"help_phone3.jpg"] inController:self];
}

@end
