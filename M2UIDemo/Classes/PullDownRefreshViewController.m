//
//  PullDownRefreshViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-2.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "PullDownRefreshViewController.h"
#import "M2BaseRefreshView.h"

#define PDRVC_PageSize 5

@interface PullDownRefreshViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, M2BaseRefreshViewDelegate>{
    UITableView *_tableView;
    M2BaseRefreshView *_refreshView;
}
@property (nonatomic) NSMutableArray *datas;
@end

@implementation PullDownRefreshViewController
- (id)init{
    self = [super init];
    if (self) {
        _datas = [NSMutableArray array];
        [self randomFillDatas:_datas];
    }
    
    return self;
}

- (void)loadView{
    self.view = [UIView new];
    self.view.backgroundColor = randomColor;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    float modifier =  0;
    if (isios7) {
        modifier = 20;
    }
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _refreshView = [[M2BaseRefreshView alloc] initWithFrame:CGRectMake(0, -50, 320, 50)];
    _refreshView.lastUpdateDate = [NSDate date];
    _refreshView.delegate = self;
    [_tableView addSubview:_refreshView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = randomColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [_datas objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_refreshView scrollViewWillBeginDragging:scrollView];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshView scrollViewDidScroll:scrollView];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

#pragma mark - M2BaseRefreshViewDelegate
- (void)onBeginLoadingInView:(M2BaseRefreshView*)view{
    NSLog(@"开始请求数据  @@%s", __func__);
    double delayInSeconds = 3.0;
    __weak PullDownRefreshViewController *weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf temp_refreshData];
    });
}

#pragma mark - 工具方法
- (void)randomFillDatas:(NSMutableArray*)datas{
    if (!datas) {
        return;
    }
    [datas removeAllObjects];
    int num = arc4random() % 10;
    for (int i = 0; i < PDRVC_PageSize; i++) {
        [datas addObject:[NSString stringWithFormat:@"%d", num * i]];
    }
}

#pragma mark - temp
- (void)temp_refreshData{
    [self randomFillDatas:_datas];
    [_tableView reloadData];
    [_refreshView endLoading:_tableView isSuccess:YES];
}


@end
