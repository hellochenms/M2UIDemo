//
//  MTapStarView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-24.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MStarView.h"
#import "M2TapStarView.h"
#import "M2TapHalfStarView.h"

@interface MStarView()<M2TapStarViewDelegate, M2TapHalfStarViewDelegate>
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
        
        M2TapHalfStarView *halfStarView = [[M2TapHalfStarView alloc] initWithStarCount:6];
        [halfStarView setupWithFrame:CGRectMake(10, 60, 300, 20)
                 LeftNormalImageName:@"common_star_left_normal"
               leftSelectedImageName:@"common_star_left_selected"
                rightNormalImageName:@"common_star_right_normal"
              rightSelectedImageName:@"common_star_right_selected"];
        
        halfStarView.grade = 3.5;
        halfStarView.delegate = self;
        [self addSubview:halfStarView];
    }
    return self;
}

#pragma mark - M2TapStarViewDelegate
- (void)starView:(M2TapStarView*)starView didSelectedForGrade:(NSInteger)grade{
    NSLog(@"grade(%d)  @@%s", grade, __func__);
}

#pragma mark - M2TapHalfStarViewDelegate
- (void)halfStarView:(M2TapHalfStarView*)halfStarView didSelectedForGrade:(float)grade{
    NSLog(@"half: grade(%.1f)  @@%s", grade, __func__);
}
@end
