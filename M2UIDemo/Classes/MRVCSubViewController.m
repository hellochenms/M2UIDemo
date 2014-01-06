//
//  MRVCSubOneViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MRVCSubViewController.h"

@interface MRVCSubViewController (){
    UIButton *_button;
}
@end

@implementation MRVCSubViewController

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
    _button = [self buttonWithTitle:self.subTitle];
    [self.view addSubview:_button];
}

#pragma mark -
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"hash(%d)  @@%s", [self hash], __func__);
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"hash(%d)  @@%s", [self hash], __func__);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"hash(%d)  @@%s", [self hash], __func__);
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"hash(%d)  @@%s", [self hash], __func__);
}

#pragma mark - button
- (UIButton*)buttonWithTitle:(NSString*)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 300, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"white_rect"] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor grayColor].CGColor;
    button.layer.borderWidth = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (void)refreshButton:(UIButton*)button WithTitle:(NSString*)title{
    [button setTitle:title forState:UIControlStateNormal];
}
- (void)onTapButton:(UIButton*)sender{
    NSLog(@"hash(%d)  @@%s", [self hash], __func__);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter
- (void)setSubTitle:(NSString *)aTitle{
    _subTitle = [aTitle copy];
    if (_button) {
        [self refreshButton:_button WithTitle:_subTitle];
    }
}

@end
