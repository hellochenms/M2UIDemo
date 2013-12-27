//
//  CenterToastViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-10.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "CenterToastViewController.h"
#import "M2Toast.h"

@interface CenterToastViewController ()

@end

@implementation CenterToastViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)loadView{
    self.view = [UIView new];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 70, 300, 50);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"显示中央提示框" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)onTapButton:(UIButton*)button{
   [M2Toast showText:[NSString stringWithFormat:@"M2Toast:%d", arc4random() % 100]];
}


@end
