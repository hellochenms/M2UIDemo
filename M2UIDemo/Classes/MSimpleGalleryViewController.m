//
//  MSimpleGalleryViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSimpleGalleryViewController.h"
#import "MSimpleGalleryView.h"

@interface MSimpleGalleryViewController (){
    MSimpleGalleryView *_mainView;
}

@end

@implementation MSimpleGalleryViewController

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
    _mainView = [[MSimpleGalleryView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 5 * 2)];
    _mainView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_mainView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
