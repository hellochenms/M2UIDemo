//
//  MShowFullInfoView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MShowFullInfoView.h"
#import "M2ShowFullInfoView.h"

@interface MShowFullInfoView()<M2ShowFullInfoViewDelegate>{
    M2ShowFullInfoView *_showFullInfoView;
}
@property (nonatomic) UIView *belowAreaContainerView;
@end

@implementation MShowFullInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        _showFullInfoView = [[M2ShowFullInfoView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 5 * 2, 60)];
        _showFullInfoView.backgroundColor = [UIColor grayColor];
        _showFullInfoView.maxHeight = 90;
        _showFullInfoView.delegate = self;
        [self addSubview:_showFullInfoView];
        
        _belowAreaContainerView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_showFullInfoView.frame) + 10, CGRectGetWidth(frame) - 5 * 2, 200)];
        _belowAreaContainerView.backgroundColor = [UIColor blueColor];
        [self addSubview:_belowAreaContainerView];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(_belowAreaContainerView.bounds) - 5 * 2, CGRectGetHeight(_belowAreaContainerView.bounds) / 3)];
        view1.backgroundColor = [UIColor redColor];
        [_belowAreaContainerView addSubview:view1];
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(view1.frame) + 5, CGRectGetWidth(_belowAreaContainerView.bounds) - 5 * 2, CGRectGetHeight(_belowAreaContainerView.bounds) / 3)];
        view2.backgroundColor = [UIColor redColor];
        [_belowAreaContainerView addSubview:view2];
    }
    return self;
}

- (void)reloadData:(NSDictionary*)data{
    [_showFullInfoView reloadData:@"啊实打实大啊\n实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实大啊实打实\n大啊实打实大"];
}

#pragma mark - M2ShowFullInfoViewDelegate
- (void)changeToHeight:(float)height animationDuration:(float)animationDuration ofView:(M2ShowFullInfoView*)view{
    CGRect frame = CGRectMake(CGRectGetMinX(_belowAreaContainerView.frame), CGRectGetMaxY(_showFullInfoView.frame) + 10, CGRectGetWidth(_belowAreaContainerView.frame), CGRectGetHeight(_belowAreaContainerView.frame));
    __weak MShowFullInfoView *weakSelf = self;
    [UIView animateWithDuration:0.25
                     animations:^{
                         weakSelf.belowAreaContainerView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         ;
                     }];

}

@end
