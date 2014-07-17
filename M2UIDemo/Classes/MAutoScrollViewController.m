//
//  MAutoScrollViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MAutoScrollViewController.h"
#import "M2AutoScrollView.h"

@interface MAutoScrollViewController ()<M2AutoScrollViewDataSource, M2AutoScrollViewDelegate>
@property (nonatomic) M2AutoScrollView *autoScrollView;
@end

@implementation MAutoScrollViewController

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
    self.autoScrollView = [[M2AutoScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    self.autoScrollView.backgroundColor = [UIColor lightGrayColor];
    self.autoScrollView.dataSource = self;
    self.autoScrollView.delegate = self;
    [self.view addSubview:self.autoScrollView];
    
}

#pragma mark - M2AutoScrollViewDataSource
- (NSInteger)numberOfCellsInAutoScrollView:(M2AutoScrollView *)autoScrollView{
    return 2;
}
- (UIView *)autoScrollView:(M2AutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index{
    UILabel *cell = [UILabel new];
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:index / 5.0];
    cell.text = [NSString stringWithFormat:@"%d", index];
    
    return cell;
}

#pragma mark - M2AutoScrollViewDelegate
- (void)autoScrollView:(M2AutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index{
    NSLog(@"index变化（%d）  %s", index, __func__);
}
- (void)autoScrollView:(M2AutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"点击index（%d）  %s", index, __func__);
}

#pragma mark - 
- (void)dealloc{
    [self.autoScrollView invalidate];
}

@end
