//
//  MCommentViewController.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCommentViewController.h"
#import "MCommentView.h"
#import "M2CommentCell.h"

@interface MCommentViewController (){
    MCommentView *_mainView;
}
@end

@implementation MCommentViewController

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
    _mainView = [[MCommentView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(frame), CGRectGetHeight(frame) - 64 - 5 * 2)];
    [self.view addSubview:_mainView];
    
    //
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}

- (void)reloadData{
    NSArray *comments = @[@{
                              M2CC_Key_User: @"阿古斯防御者",
                              M2CC_Key_Comment : @"我是阿古斯之盾！",
                              M2CC_Key_CommentDate : [NSDate date]
                              },
                          @{
                              M2CC_Key_User: @"蓝胖",
                              M2CC_Key_Comment : @"你为什么召唤我！",
                              M2CC_Key_CommentDate : [NSDate dateWithTimeIntervalSinceNow:-60 * 10]
                              },
                          @{
                              M2CC_Key_User: @"战利品储藏者",
                              M2CC_Key_Comment : @"我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？",
                              M2CC_Key_CommentDate : [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 2]
                              },
                          @{
                              M2CC_Key_User: @"大地震击",
                              M2CC_Key_Comment : @"！@#￥%……&＊（）——+！@#￥%……&！@#￥%……&＊（……&＊（！@#￥%……&＊（）！@#￥%……&＊&＊（%￥@！）——",
                              M2CC_Key_ReplyToUser: @"战利品储藏者",
                              M2CC_Key_ReplyToComment: @"我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？我可以需求这装备吗？",
                              M2CC_Key_CommentDate : [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24]
                              },
                          @{
                              M2CC_Key_User: @"奥术飞弹",
                              M2CC_Key_Comment : @"！@#￥%……&！@#￥%……&！@#￥%……&！@#￥%……&",
                              M2CC_Key_ReplyToComment: @"！@#￥%……&……",
                              M2CC_Key_CommentDate : [NSDate dateWithTimeIntervalSinceNow:-60 * 60 * 24 * 2]
                              }
                          ];
    [_mainView reloadData:comments];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
