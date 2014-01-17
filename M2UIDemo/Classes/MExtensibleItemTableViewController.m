//
//  MExtensibleItemTableViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-17.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MExtensibleItemTableViewController.h"
#import "MExtensibleItemTableView.h"
#import "MSubViewController.h"

@interface MExtensibleItemTableViewController ()<MExtensibleItemTableViewDelegate>{
    MExtensibleItemTableView *_mainView;
}
@end

@implementation MExtensibleItemTableViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = [UIScreen mainScreen].bounds;
    _mainView = [[MExtensibleItemTableView alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 10 * 2)];
    _mainView.delegate = self;
    [self.view addSubview:_mainView];
    
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

- (void)reloadData{
    NSArray *data = @[@{MEITV_Key_Title: @"攻略",
                        MEITV_Key_Items: @[@"攻略0", @"攻略1"]
                          },
                      @{MEITV_Key_Title: @"测评",
                        MEITV_Key_Items: @[@"测评0", @"测评1"]
                        },
                      @{MEITV_Key_Title: @"资讯"
                        },
                      @{MEITV_Key_Title: @"美图"
                        }
                      ];
    [_mainView reloadData: data];
}

#pragma mark - MExtensibleItemTableViewDelegate
- (void)didSelectSection:(NSInteger)section inView:(MExtensibleItemTableView *)view{
    MSubViewController *subViewController = [MSubViewController new];
    subViewController.someTitle = [NSString stringWithFormat:@"section(%d)", section];
    [self.navigationController pushViewController:subViewController animated:YES];
}
- (void)didSelectRow:(NSInteger)row inSection:(NSInteger)section inView:(MExtensibleItemTableView *)view{
    MSubViewController *subViewController = [MSubViewController new];
    subViewController.someTitle = [NSString stringWithFormat:@"section(%d) row(%d)", section, row];
    [self.navigationController pushViewController:subViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
