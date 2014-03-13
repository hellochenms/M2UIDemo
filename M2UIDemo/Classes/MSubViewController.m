//
//  MSubViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-17.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSubViewController.h"

@interface MSubViewController (){
    UILabel *_label;
}
@end

@implementation MSubViewController

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
    self.view.backgroundColor = [UIColor lightGrayColor];
	// Do any additional setup after loading the view.
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    [self.view addSubview:_label];
    _label.text = [NSString stringWithFormat:@"子界面：%@", _subTitle];
}

#pragma mark - setter
- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = [subTitle copy];
    _label.text = [NSString stringWithFormat:@"子界面：%@", _subTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
