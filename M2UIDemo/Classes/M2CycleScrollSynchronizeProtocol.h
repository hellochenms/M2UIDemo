//
//  M2CycleScrollSynchronizeProtocol.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol M2CycleScrollSynchronizeProtocol <NSObject>
- (void)view:(UIView *)view didScrollOffsetX:(float)offsetX itemWidth:(float)itemWidth itemsCountPerPage:(NSInteger)itemsCountPerPage;
@end
