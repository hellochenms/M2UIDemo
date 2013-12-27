//
//  TestCustomCell.h
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-19.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestCustomCell : UITableViewCell
+ (float)recommendHeight;
- (void)loadData:(NSString*)title
        subTitle:(NSString*)subTitle
           image:(UIImage*)image;
@end
