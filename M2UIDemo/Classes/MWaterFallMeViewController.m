//
//  MWaterFallMeViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-7.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MWaterFallMeViewController.h"
#import "M2WaterFallView.h"

#define MWFMVC_ItemCount 100
#define MWFMVC_WaterFallItemOffset 6000
#define MWFMVC_ButtonOffset 7000

@interface MWaterFallMeViewController ()<M2WaterFallViewDataSource, M2WaterFallViewDelegate>
@property (nonatomic) M2WaterFallView *waterFallView;
@property (nonatomic) NSMutableArray *datas;
@end

@implementation MWaterFallMeViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _datas = [NSMutableArray array];
        for (int i = 0; i < MWFMVC_ItemCount; i++) {
            [_datas addObject:@"chinadragon"];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    CGRect frame = [UIScreen mainScreen].bounds;
    _waterFallView = [[M2WaterFallView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 10)];
    _waterFallView.backgroundColor = [UIColor lightGrayColor];//TODO
    _waterFallView.dataSource = self;
    _waterFallView.delegate = self;
    [self.view addSubview:_waterFallView];
    
    UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame = CGRectMake(CGRectGetWidth(frame) - 120, 5, 120, 50);
    reloadButton.backgroundColor = [UIColor redColor];
    [reloadButton setTitle:@"ReloadData" forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(onTapReload:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - M2WaterFallViewDataSource
- (NSInteger)numberOfItemsForWaterFallView:(M2WaterFallView *)waterFallView{
    return _datas.count;
}
- (UIView*)waterFallView:(M2WaterFallView *)waterFallView viewForIndex:(int)index{
    UIImageView *imageView = [UIImageView new];
    
    // 这两个设置是常规瀑布流显示效果，本控件将设置的职责留给调用方
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    imageView.layer.borderColor = [UIColor blueColor].CGColor;
    imageView.layer.borderWidth = 1;
    imageView.image = [UIImage imageNamed:[_datas objectAtIndex:index]];
    imageView.tag = MWFMVC_WaterFallItemOffset + index;
    imageView.userInteractionEnabled = YES;
    // 注掉的部分只是为了验证item上的事件响应正常
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageView:)];
//    [imageView addGestureRecognizer:tap];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 70, 40);
    button.backgroundColor = [UIColor blueColor];
    [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onTapButton:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = MWFMVC_ButtonOffset + index;
    [imageView addSubview:button];
    
    return imageView;
}
#pragma mark - M2WaterFallViewDelegate
- (void)waterFallView:(M2WaterFallView *)waterFallView didSelectItemAtIndex:(int)index{
    NSLog(@"瀑布流的select事件：index(%d)  @@%s", index, __func__);
}
- (void)waterFallView:(M2WaterFallView *)waterFallView willRemoveView:(UIView *)view forIndex:(int)index{
//    NSLog(@"view(%@)  @@%s", view, __func__);
}

//#pragma mark - 
//- (void)onTapImageView:(UITapGestureRecognizer*)tap{
//    NSLog(@"ImageView的tap事件：index(%d)  @@%s", tap.view.tag - MWFMVC_WaterFallItemOffset, __func__);
//}

#pragma mark - 
- (void)onTapReload:(UIButton*)sender{
    [self.waterFallView reloadData];
}

#pragma mark -
- (void)onTapButton:(UIButton*)sender{
    NSLog(@"ImageView上Button事件：index(%d)  @@%s", sender.tag - MWFMVC_ButtonOffset, __func__);
}

@end
