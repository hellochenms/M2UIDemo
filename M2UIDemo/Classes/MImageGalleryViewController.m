//
//  MImageGalleryViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MImageGalleryViewController.h"
#import "MImageGalleryView.h"

#define MIGVC_ImageCount 4

@interface MImageGalleryViewController ()
@property (nonatomic) MImageGalleryView *galleryView;
@end

@implementation MImageGalleryViewController

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
    _galleryView = [[MImageGalleryView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 5 * 2)];
    _galleryView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_galleryView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
