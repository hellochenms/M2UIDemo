//
//  _tempTestViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "_tempTestViewController.h"
#import <objc/runtime.h>
@interface _tempTestViewController (){
    UIButton *_button;
}
@end

@implementation _tempTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    _button.frame = CGRectMake(0, 0, 50, 50);
//    _button.backgroundColor = [UIColor blueColor];
//    [_button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_button];
    self.view.backgroundColor = [UIColor blackColor];
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityView.frame = CGRectMake(50,50, 20, 20);
    [self.view addSubview:activityView];
    [activityView startAnimating];
    
    NSLog(@"%x", 101038356);
    NSLog(@"%d", 0x0605B914);
}


@end
