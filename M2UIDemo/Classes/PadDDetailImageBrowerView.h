//
//  PadDDetailImageBrowerView.h
//  PadDetailPage
//
//  Created by Chen Meisong on 14-3-17.
//  Copyright (c) 2014年 xiong qi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PadDDetailImageBrowerView : UIView
- (id)initWithImageUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex;
- (void)show;
@end
