//
//  MKeyboardInputViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MKeyboardInputViewController.h"
#import "MKeyboardInputView.h"

@interface MKeyboardInputViewController (){
    MKeyboardInputView *_mainView;
}
@end

@implementation MKeyboardInputViewController

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
    _mainView = [[MKeyboardInputView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 50 * 2)];
    [self.view addSubview:_mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
