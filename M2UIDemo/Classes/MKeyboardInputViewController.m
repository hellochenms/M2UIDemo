//
//  MKeyboardInputViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-8.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MKeyboardInputViewController.h"
#import "MKeyboardInputView.h"

@interface MKeyboardInputViewController ()<MKeyboardInputViewDelegate>
@property (nonatomic) UIControl *coverView;
@end

@implementation MKeyboardInputViewController

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
    MKeyboardInputView *mainView = [[MKeyboardInputView alloc] initWithFrame:CGRectMake(0, 50, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 50 * 2)];
    mainView.delegate = self;
    [self.view addSubview:mainView];
    
    _coverView = [[UIControl alloc] initWithFrame:mainView.frame];
    _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [_coverView addTarget:self action:@selector(onTapCover) forControlEvents:UIControlEventTouchUpInside];
    _coverView.hidden = YES;
    [self.view addSubview:_coverView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
- (void)onTapCover{
    __weak MKeyboardInputViewController *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.coverView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         weakSelf.coverView.hidden = YES;
                     }];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - MKeyboardInputViewDelegate
- (void)willBeginEditingInkeyboardInputView:(MKeyboardInputView *)keyboardInputView{
    __weak MKeyboardInputViewController *weakSelf = self;
    weakSelf.coverView.alpha = 0;
    weakSelf.coverView.hidden = NO;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.coverView.alpha = 1;
                     }];
}
- (void)willEndEditingInkeyboardInputView:(MKeyboardInputView *)keyboardInputView{
    [self onTapCover];
}
@end
