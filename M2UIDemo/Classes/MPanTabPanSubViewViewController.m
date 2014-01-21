//
//  MPanTabPanSubViewViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MPanTabPanSubViewViewController.h"
#import "MSubViewController.h"
#import "MPanTabPanSubViewView.h"

@interface MPanTabPanSubViewViewController (){
    MPanTabPanSubViewView   *_mainView;
    NSMutableArray          *_contentViewControllers;
}
@end

@implementation MPanTabPanSubViewViewController

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
    _mainView = [[MPanTabPanSubViewView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 10 * 2)];
    [self.view addSubview:_mainView];

    // reload data
    [self reloadData];
}

- (void)reloadData{
    NSArray *titles = @[@"详情", @"评论", @"攻略", @"测评", @"资讯", @"美图"];
    int count = [titles count];
    _contentViewControllers = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray *contentViews = [NSMutableArray arrayWithCapacity:count];
    MSubViewController *subViewController = nil;
    for (int i = 0; i < count; i++) {
        subViewController = [MSubViewController new];
        subViewController.subTitle = titles[i];
        [_contentViewControllers addObject:subViewController];
        [contentViews addObject:subViewController.view];
    }
    [_mainView reloadDataWithTitles:titles contentViews:contentViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
