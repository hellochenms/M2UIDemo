//
//  StatusToastViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-12.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "StatusToastViewController.h"
#import "M2StatusBarToast.h"

@interface StatusToastViewController ()

@end

@implementation StatusToastViewController

- (void)loadView{
    self.view = [UIView new];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 70, 300, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"显示状态条提示框" forState:UIControlStateNormal];
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

#pragma mark -
- (void)onTapButton:(UIButton*)button{
    [M2StatusBarToast showText:[NSString stringWithFormat:@"M2StatusBarToast:%d", arc4random() % 100]];
}


@end
