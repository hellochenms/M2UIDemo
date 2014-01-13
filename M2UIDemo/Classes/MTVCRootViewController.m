//
//  MTVCRootViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MTVCRootViewController.h"
#import "M2MultiRowTabBarView.h"
#import "MRVCSubViewController.h"

#define MTVCRVC_SubViewControllerCount 3

@interface MTVCRootViewController ()<M2MultiRowTabbarViewDelegate>{
    NSMutableArray *_subViewControllers;
}
@property (nonatomic) M2MultiRowTabBarView *tabbarView;
@property (nonatomic) int lastIndex;
@end

@implementation MTVCRootViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _subViewControllers = [NSMutableArray array];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGRect frame = [UIScreen mainScreen].bounds;
    
    // tabbar
    _tabbarView = [[M2MultiRowTabBarView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), 100)
                                                                         titles:[self numberTitlesWithCount:MTVCRVC_SubViewControllerCount]
                                                                 itemCountInRow:2];
    _tabbarView.delegate = self;
    _tabbarView.backgroundColor = [UIColor blueColor];
    _tabbarView.disableIndexs = @[@(1)];
    [self.view addSubview:_tabbarView];
    
    // content
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tabbarView.frame) + 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 -CGRectGetMaxY(_tabbarView.frame) - 10 - 10)];
    containerView.backgroundColor = [UIColor lightGrayColor];
    containerView.clipsToBounds = YES;
    [self.view addSubview:containerView];
    
    // build sub viewControllers
    MRVCSubViewController *subViewController = nil;
    for (int i = 0; i < MTVCRVC_SubViewControllerCount; i++) {
        subViewController = [MRVCSubViewController new];
        subViewController.subTitle = [NSString stringWithFormat:@"SubViewController(%d)", i];
        subViewController.view.backgroundColor = randomColor;
        [_subViewControllers addObject:subViewController];
    }
    
    // manage sub viewControllers
    subViewController = [_subViewControllers objectAtIndex:0];
    [self addChildViewController:subViewController];
    [containerView addSubview:subViewController.view];
    [subViewController didMoveToParentViewController:self];
    _lastIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - M2MultiRowTabbarViewDelegate
- (void)tabBarView:(M2MultiRowTabBarView *)tableView didSelectRowAtIndex:(int)index{
    NSLog(@"tapIndex(%d)  @@%s", index, __func__);
    if (index == _lastIndex) {
        // 有的需求可能刷新当前界面，类似下面代码；本示例只简单忽略；
        // MRVCSubViewController *subViewController = [_subViewControllers objectAtIndex:_lastIndex];
        // [subViewController reloadData];
        return;
    }
    _tabbarView.userInteractionEnabled = NO;
    MRVCSubViewController *fromViewController = [_subViewControllers objectAtIndex:_lastIndex];
    MRVCSubViewController *toViewController = [_subViewControllers objectAtIndex:index];
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    // 无动画
    __weak MTVCRootViewController *weakSelf = self;
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0
                               options:UIViewAnimationOptionTransitionNone
                            animations:nil
                            completion:^(BOOL finished) {//TODO:一直有个疑问，动画的block示例中为什么从来不用__block、__weak等
                                [fromViewController removeFromParentViewController];
                                [toViewController didMoveToParentViewController:self];
                                weakSelf.lastIndex = index;
                                weakSelf.tabbarView.userInteractionEnabled = YES;
                            }];
    
    // 自己写动画的效果
//    BOOL isToLeft = index > _lastIndex;
//    CGRect frame = fromViewController.view.frame;
//    toViewController.view.frame = CGRectMake(CGRectGetWidth(frame) * (isToLeft ? 1 : -1), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
//    __weak MTVCRootViewController *weakSelf = self;
//    [self transitionFromViewController:fromViewController
//                      toViewController:toViewController
//                              duration:0.25
//                               options:UIViewAnimationOptionTransitionNone
//                            animations:^{
//                                fromViewController.view.frame = CGRectMake(CGRectGetWidth(frame)  * (isToLeft ? -1 : 1), CGRectGetMinY(frame), CGRectGetWidth(frame), CGRectGetHeight(frame));
//                                toViewController.view.frame = frame;
//                            }
//                            completion:^(BOOL finished) {
//                                [fromViewController removeFromParentViewController];
//                                [toViewController didMoveToParentViewController:self];
//                                weakSelf.lastIndex = index;
//                                weakSelf.tabbarView.userInteractionEnabled = YES;
//                            }];
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
