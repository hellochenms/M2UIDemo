//
//  _tempTestViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "_tempTestViewController.h"
//#import "UIButton+A.h"

@interface _tempTestViewController ()

@end

@implementation _tempTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(10, 10, 200, 50);
        button.backgroundColor = [UIColor blueColor];
        [button setTitle:@"A" forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    return self;
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

@end
