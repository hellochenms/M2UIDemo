//
//  MAutoScrollViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MAutoScrollViewController.h"
//#import "M2AutoScrollView.h"
#import "M2ButtonControlAutoScrollView.h"

@interface MAutoScrollViewController ()<M2ButtonControlAutoScrollViewDataSource, M2ButtonControlAutoScrollViewDelegate>//<M2AutoScrollViewDataSource, M2AutoScrollViewDelegate>
//@property (nonatomic) M2AutoScrollView *autoScrollView;
@property (nonatomic) M2ButtonControlAutoScrollView *buttonControlAutoScrollView;
@property (nonatomic) NSInteger count;
@property (nonatomic) NSMutableArray *colors;
@end

@implementation MAutoScrollViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.count = 5;
        self.colors = [NSMutableArray array];
        for (NSInteger i = 0; i < self.count; i++) {
            [self.colors addObject:randomColor];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.autoScrollView = [[M2AutoScrollView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
//    self.autoScrollView.backgroundColor = [UIColor lightGrayColor];
//    self.autoScrollView.dataSource = self;
//    self.autoScrollView.delegate = self;
//    [self.view addSubview:self.autoScrollView];
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 200)];
    container.clipsToBounds = YES;
    container.backgroundColor = [UIColor blueColor];
    [self.view addSubview:container];
    
    self.buttonControlAutoScrollView = [[M2ButtonControlAutoScrollView alloc] initWithFrame:CGRectMake(50, 0, 200, 200)];
    self.buttonControlAutoScrollView.backgroundColor = [UIColor lightGrayColor];
    self.buttonControlAutoScrollView.dataSource = self;
    self.buttonControlAutoScrollView.delegate = self;
    self.buttonControlAutoScrollView.scrollClipToBounds = NO;
    [container addSubview:self.buttonControlAutoScrollView];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 60, 30);
    leftButton.backgroundColor = [UIColor brownColor];
    [leftButton setTitle:@"left" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onTapLeft) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(CGRectGetWidth(container.bounds) - 60, 0, 60, 30);
    rightButton.backgroundColor = [UIColor brownColor];
    [rightButton setTitle:@"right" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onTapRight) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:rightButton];
}

#pragma mark - user event
- (void)onTapLeft {
    [self.buttonControlAutoScrollView turnPageLeft];
}
- (void)onTapRight {
    [self.buttonControlAutoScrollView turnPageRight];
}

#pragma mark - M2AutoScrollViewDataSource, M2AutoScrollViewDelegate
/*
- (NSInteger)numberOfCellsInAutoScrollView:(M2AutoScrollView *)autoScrollView{
    return 4;
}
- (UIView *)autoScrollView:(M2AutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index{
    UILabel *cell = [UILabel new];
    cell.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:index / 5.0];
    cell.text = [NSString stringWithFormat:@"%d", index];
    
    return cell;
}
- (void)autoScrollView:(M2AutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index{
    NSLog(@"index变化（%d）  %s", index, __func__);
}
- (void)autoScrollView:(M2AutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"点击index（%d）  %s", index, __func__);
}
 */

#pragma mark - M2ButtonControlAutoScrollViewDataSource, M2ButtonControlAutoScrollViewDelegate
- (NSInteger)numberOfCellsInAutoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView{
    return [self.colors count];
}
- (UIView *)autoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView cellAtIndex:(NSInteger)index{
    UILabel *cell = [UILabel new];
    cell.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [self.colors objectAtIndex:index];
    cell.text = [NSString stringWithFormat:@"%d", index];
    
    return cell;
}
- (void)autoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView didChangeIndexTo:(NSInteger)index{
    NSLog(@"index变化（%d）  %s", index, __func__);
}
- (void)autoScrollView:(M2ButtonControlAutoScrollView *)autoScrollView didSelectCellAtIndex:(NSInteger)index{
    NSLog(@"点击index（%d）  %s", index, __func__);
}

#pragma mark - 
- (void)dealloc{
//    [self.autoScrollView invalidate];
    [self.buttonControlAutoScrollView invalidate];
}

@end
