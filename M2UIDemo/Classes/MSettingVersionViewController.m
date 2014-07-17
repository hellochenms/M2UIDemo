//
//  MSettingVersionViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-15.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSettingVersionViewController.h"

@interface MSettingVersionViewController ()
@end

@implementation MSettingVersionViewController

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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 300, 30);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:@"检查更新" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)onTapButton{
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSString *newVersion = @"2.2.2";
    if ([version compare:newVersion options:NSLiteralSearch] == NSOrderedAscending) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的应用有更新"
                                                            message:[NSString stringWithFormat:@"您的版本：%@， 新版本：%@", version, newVersion]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
