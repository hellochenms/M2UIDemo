//
//  _tempTestViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "_tempTestViewController.h"
#import "_tempTestView.h"
@interface _tempTestViewController ()
@property (nonatomic) _tempTestView *mainView;
@end

@implementation _tempTestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.origin.y = 50;
        frame.size.height = 300;
        _mainView = [[_tempTestView alloc] initWithFrame:frame];
        [self.view addSubview:_mainView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


@end
