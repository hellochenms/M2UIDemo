//
//  MTabScrollViewViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MTabScrollViewViewController.h"
#import "MTabScrollViewView.h"
#import "MSubViewController.h"

@interface MTabScrollViewViewController (){
    NSMutableArray *contentViewControllers;
}
@end

@implementation MTabScrollViewViewController

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
    
    // main view
    CGRect frame = [UIScreen mainScreen].bounds;
    MTabScrollViewView *mainView = [[MTabScrollViewView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 10 * 2)];
    [self.view addSubview:mainView];
    
    // subViewControllers
    NSArray *titles = @[@"新闻", @"财经", @"科技", @"轻松一刻"];
    int count = [titles count];
    contentViewControllers = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *contentViews = [NSMutableArray arrayWithCapacity:count];
    MSubViewController *subViewController = nil;
    for (int i = 0; i < count; i++) {
        subViewController = [MSubViewController new];
        subViewController.subTitle = titles[i];
        [contentViewControllers addObject:subViewController];
        [contentViews addObject:subViewController.view];
    }
    
    // init
    mainView.contentViews = contentViews;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
