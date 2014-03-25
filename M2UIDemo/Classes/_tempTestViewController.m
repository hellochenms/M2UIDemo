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
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 50, 50);
    _button.backgroundColor = [UIColor blueColor];
    [_button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipe];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
}

- (void)onTapButton{
    [self.view addSubview:_button];
    NSLog(@"  @@%s", __func__);
}

- (void)onSwipe:(UISwipeGestureRecognizer *)swipe{
    NSLog(@"%d  @@%s", swipe.direction, __func__);
}

@end
