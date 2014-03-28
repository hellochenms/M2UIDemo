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
@property (nonatomic) M2LoadingCoverView    *loadingCoverView;
@property (nonatomic) UIButton              *cancelButton;
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
    [button setTitle:@"加载" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(10, 70, CGRectGetWidth(frame) - 10 * 2, 50);
    _cancelButton.backgroundColor = [UIColor blueColor];
    [_cancelButton setTitle:@"只有点这个按钮才取消" forState:UIControlStateNormal];
    [_cancelButton addTarget:self action:@selector(onTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancelButton];
    
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
    
    CGRect cancelFrame = _cancelButton.frame;
    cancelFrame.origin.y += (20 + 44);
    [_loadingCoverView showWithCancelFrame:cancelFrame];
}

- (void)onTapCancelButton{
    [_loadingCoverView hide];
}

@end
