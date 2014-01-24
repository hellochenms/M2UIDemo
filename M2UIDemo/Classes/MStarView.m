//
//  MTapStarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MStarView.h"
#import "M2TapStarView.h"

@interface MStarView()<M2TapStarViewDelegate>
@end

@implementation MStarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        M2TapStarView *starView = [[M2TapStarView alloc] initWithFrame:CGRectMake(10, 10, 300, 20)
                                                       normalImageName:@"_temp_star_normal"
                                                     selectedImageName:@"_temp_star_selected"
                                                            itemCount:7
                                                       horizontalSpace:10];
        starView.delegate = self;
        [self addSubview:starView];
    }
    return self;
}

#pragma mark - M2TapStarViewDelegate
- (void)starView:(M2TapStarView*)starView didSelectedForGrade:(NSInteger)grade{
    NSLog(@"grade(%d)  @@%s", grade, __func__);
}

@end
