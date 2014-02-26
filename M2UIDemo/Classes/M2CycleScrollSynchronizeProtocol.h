//
//  M2CycleScrollSynchronizeProtocol.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A
//  版本：1.0
//  可选套件：M2CycleTabBarView、M2CycleTabBarView

#import <Foundation/Foundation.h>

@protocol M2CycleScrollSynchronizeProtocol <NSObject>
- (void)view:(UIView *)view didScrollOffsetX:(float)offsetX itemWidth:(float)itemWidth itemsCountPerPage:(NSInteger)itemsCountPerPage;
@end
