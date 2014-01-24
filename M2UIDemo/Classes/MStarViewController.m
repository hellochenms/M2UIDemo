//
//  MTapStarViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MStarViewController.h"
#import "MStarView.h"

@interface MStarViewController (){
    MStarView *_mainView;
}
@end

@implementation MStarViewController

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
    _mainView = [[MStarView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 5 * 2)];
    [self.view addSubview:_mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
