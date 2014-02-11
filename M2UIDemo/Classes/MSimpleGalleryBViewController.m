//
//  MSimpleGalleryBViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSimpleGalleryBViewController.h"
#import "MSimpleGalleryBView.h"

@interface MSimpleGalleryBViewController (){
    MSimpleGalleryBView *_mainView;
}

@end

@implementation MSimpleGalleryBViewController

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
    _mainView = [[MSimpleGalleryBView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 5 * 2)];
    _mainView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
