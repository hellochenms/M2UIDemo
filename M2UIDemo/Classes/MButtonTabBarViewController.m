//
//  MButtonTabBarViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-20.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MButtonTabBarViewController.h"
#import "MButtonTabBarView.h"

@interface MButtonTabBarViewController ()

@end

@implementation MButtonTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect frame = [UIScreen mainScreen].bounds;
    MButtonTabBarView *mainView = [[MButtonTabBarView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 10 * 2)];
    [self.view addSubview:mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
