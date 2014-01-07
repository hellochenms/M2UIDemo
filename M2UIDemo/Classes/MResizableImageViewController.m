//
//  MResizableImageViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MResizableImageViewController.h"

@interface MResizableImageViewController ()

@end

@implementation MResizableImageViewController

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
    
    UIImage *originImage = [UIImage imageNamed:@"icon"];
    UIImage *image = nil;
    UIImageView *imageView = nil;
    
    // 默认:直接拉伸
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 90)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = originImage;
    [self.view addSubview:imageView];
    
    // 居中：设置imageViewcontentMode
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 5, 300, 90)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = originImage;
    [self.view addSubview:imageView];
    
    // 平铺
    image = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 5, 300, 90)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    // 局部拉伸
    image = [originImage resizableImageWithCapInsets:UIEdgeInsetsMake(14.5, 14.5, 14.5, 14.5)];// 其实也是平铺，平铺了中间的点
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 5, 300, 90)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.image = image;
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
