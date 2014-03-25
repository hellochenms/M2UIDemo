//
//  MLoadingViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-25.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MLoadingCoverViewController.h"
#import "M2LoadingCoverView.h"

@interface MLoadingCoverViewController ()
@property (nonatomic) M2LoadingCoverView *loadingCoverView;
@end

@implementation MLoadingCoverViewController

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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, CGRectGetWidth(frame) - 10 * 2, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"加载数据" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onTapButton{
    if (!_loadingCoverView) {
        _loadingCoverView = [M2LoadingCoverView new];
    }
    [_loadingCoverView show];
    [self performSelector:@selector(loadFinish) withObject:nil afterDelay:2];
}

- (void)loadFinish{
    [_loadingCoverView hide];
}

@end
