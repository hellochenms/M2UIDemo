//
//  MCell3AutoScrollViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCell3AutoScrollViewController.h"
#import "M2Cell3AutoScrollView.h"

@interface MCell3AutoScrollViewController ()<M2Cell3AutoScrollViewDataSource, M2Cell3AutoScrollViewDelegate>
@property (nonatomic) M2Cell3AutoScrollView *autoScrollView;
@end

@implementation MCell3AutoScrollViewController

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
    self.autoScrollView = [[M2Cell3AutoScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    self.autoScrollView.backgroundColor = [UIColor lightGrayColor];
    self.autoScrollView.dataSource = self;
    self.autoScrollView.delegate = self;
    [self.view addSubview:self.autoScrollView];
    
}

#pragma mark - M2AutoScrollViewDataSource
- (NSInteger)numberOfCellsInAutoScrollView:(M2Cell3AutoScrollView *)autoScrollView{
    return 2;
}
- (UIView *)autoScrollView:(M2Cell3AutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index{
    UILabel *cell = [UILabel new];
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:index / 5.0];
    cell.text = [NSString stringWithFormat:@"%d", index];
    
    return cell;
}

#pragma mark - M2AutoScrollViewDelegate
- (void)autoScrollView:(M2Cell3AutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index{
    NSLog(@"index变化（%d）  %s", index, __func__);
}
- (void)autoScrollView:(M2Cell3AutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"点击index（%d）  %s", index, __func__);
}

#pragma mark -
- (void)dealloc{
    [self.autoScrollView invalidate];
}


@end
