//
//  MLoadMoreViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-7-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MLoadMoreViewController.h"
#import "M2LoadMoreView.h"

@interface MLoadMoreViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, M2LoadMoreViewDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UITableViewCell *loadMoreViewCell;
@property (nonatomic) M2LoadMoreView *loadMoreView;
@property (nonatomic) NSMutableArray *datas;

@property (nonatomic) NSInteger temp_pageCount;
@end

@implementation MLoadMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _datas = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.rowHeight = 100;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    self.loadMoreView = [[M2LoadMoreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 50)];
    self.loadMoreView.backgroundColor = [UIColor redColor];
    self.loadMoreView.delegate = self;
    [self.tableView addSubview:self.loadMoreView];
    
    [self reloadData];
}

- (void)reloadData{
    [self.datas addObjectsFromArray:@[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    [self.tableView reloadData];
    self.temp_pageCount++;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.datas count];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.loadMoreView scrollViewDidScroll:scrollView];
}

#pragma mark - M2LoadMoreViewDelegate
- (void)onBeginLoadingMoreInView:(M2LoadMoreView*)view{
    NSLog(@"加载下一页数据  %s", __func__);
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.temp_pageCount < 5) {
            BOOL isSuccess = (arc4random() % 2 == 0);
            if (isSuccess) {
                [weakSelf reloadData];
            }
            [weakSelf.loadMoreView endLoading:weakSelf.tableView isSuccess:isSuccess];
        }else{
            [weakSelf.loadMoreView endLoading:weakSelf.tableView isSuccess:YES];
            weakSelf.loadMoreView.ended = YES;
        }
        
    });
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
