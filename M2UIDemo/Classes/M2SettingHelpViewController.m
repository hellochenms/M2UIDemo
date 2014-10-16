//
//  M2SettingHelpViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-10-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2SettingHelpViewController.h"

#ifndef isIOS7
#define isIOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#endif

@interface M2SettingHelpViewController ()
@property (nonatomic) NSArray       *imageNames;
@property (nonatomic) UIScrollView  *scrollView;
@property (nonatomic) UIButton      *closeButton;
@property (nonatomic) BOOL          originNavigationBarHidden;
@end

@implementation M2SettingHelpViewController

- (id)init {
    return [self initWithImageNames:nil];
}

- (id)initWithImageNames:(NSArray *)imageNames {
    self = [super init];
    if (self) {
        self.imageNames = imageNames;
        if (isIOS7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        self.view.backgroundColor = [UIColor blackColor];
        
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height -= (isIOS7 ? 0 : 20);
        
        // 图片区
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.pagingEnabled = YES;
        [self.view addSubview:self.scrollView];
        
        double itemWidth = CGRectGetWidth(frame);
        double itemHeight = CGRectGetHeight(frame);
        __weak typeof(self) weakSelf = self;
        __block UIImageView *imageView;
        [self.imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth * idx, 0, itemWidth, itemHeight)];
            imageView.image = [UIImage imageNamed:imageName];
            [weakSelf.scrollView addSubview:imageView];
        }];
        NSInteger count = [self.imageNames count];
        self.scrollView.contentSize = CGSizeMake(itemWidth * count, itemHeight);
        
        // 关闭按钮
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(CGRectGetWidth(frame) - 44 - 10, (isIOS7 ? 20 : 0) + 10, 44, 44);
        [self.closeButton addTarget:self action:@selector(onTapClose) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeButton];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.originNavigationBarHidden = self.navigationController.navigationBarHidden;
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = self.originNavigationBarHidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
- (void)onTapClose {
    if (self.tapCloseHandler) {
        self.tapCloseHandler();
    }
}

@end
