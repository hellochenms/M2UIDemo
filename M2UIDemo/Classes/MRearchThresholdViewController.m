//
//  MRearchThresholdViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-9.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MRearchThresholdViewController.h"
#import "MRearchThresholdView.h"

@interface MRearchThresholdViewController ()

@end

@implementation MRearchThresholdViewController

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
    MRearchThresholdView *view = [[MRearchThresholdView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 10 * 2)];
    [self.view addSubview:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
