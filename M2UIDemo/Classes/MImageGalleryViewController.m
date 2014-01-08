//
//  MImageGalleryViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MImageGalleryViewController.h"
#import "M2ImageGalleryView.h"

#define MIGVC_ImageCount 4

@interface MImageGalleryViewController ()
@property (nonatomic) M2ImageGalleryView *galleryView;
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
    _galleryView = [[M2ImageGalleryView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 5 * 2)];
    _galleryView.backgroundColor = [UIColor lightGrayColor];
    _galleryView.isLandscape = YES;
    [self.view addSubview:_galleryView];
    
    
    NSMutableArray *images = [NSMutableArray array];
    UIImage *image = nil;
    for (int i = 0; i < MIGVC_ImageCount; i++) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"landscape%d.jpg", i]];
        [images addObject:image];
    }
    __weak MImageGalleryViewController *weakSelf = self;
    double delayInSeconds = 0.6;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.galleryView reloadDataWithImages:images];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
