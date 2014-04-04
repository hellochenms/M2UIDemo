//
//  PhoneDHotDetailImageBrowerView.h
//  PhoneDetailPage
//
//  Created by Chen Meisong on 14-2-10.
//  Copyright (c) 2014年 yingmin zhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneDDetailImageBrowerView : UIView
- (id)initWithImageUrls:(NSArray *)urls selectedIndex:(NSInteger)selectedIndex;
- (void)show;
@end
