//
//  MTVCRootViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MTVCRootViewController.h"
#import "M2MultiRowTabbarView.h"

@interface MTVCRootViewController ()<M2MultiRowTabbarViewDelegate>

@end

@implementation MTVCRootViewController

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
    
    // tabbar
    M2MultiRowTabbarView *tabbarView = [[M2MultiRowTabbarView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), 100)
                                                                         titles:[self numberTitlesWithCount:3]
                                                                 itemCountInRow:2];
    tabbarView.delegate = self;
    tabbarView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:tabbarView];
    
    // content
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tabbarView.frame) + 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 -CGRectGetMaxY(tabbarView.frame) - 10 - 10)];
    contentView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:contentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - M2MultiRowTabbarViewDelegate
- (void)onTapItemWithIndex:(int)index inView:(M2MultiRowTabbarView*)view{
    NSLog(@"tapIndex(%d)  @@%s", index, __func__);
}

#pragma mark - tools
- (NSArray*)numberTitlesWithCount:(int)count{
    if (count <= 0) {
        return nil;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [array addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    return [NSArray arrayWithArray:array];
}

@end
