//
//  _tempTestViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "_tempTestViewController.h"
#import <objc/runtime.h>
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
        
        UIButton *button2 = [[UIButton alloc] init];
        button2.frame = CGRectMake(10, 70, 200, 50);
        button2.backgroundColor = [UIColor blueColor];
        [button2 setTitle:@"B" forState:UIControlStateNormal];
        [self.view addSubview:button2];
        
        Method m1 = class_getInstanceMethod([button class], @selector(setBackgroundColor:));
        Method m2 = class_getInstanceMethod([button class], @selector(setBackgroundColor:));
        NSLog(@"m1(%p) m2(%p)  @@%s", m1, m2, __func__);
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
