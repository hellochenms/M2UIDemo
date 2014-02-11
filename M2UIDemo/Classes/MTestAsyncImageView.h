//
//  MAsyncImageView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTestAsyncImageView : UIView
@property (nonatomic, readonly) UIImage *image;
- (void)loadImageWithName:(NSString *)name completion:(void (^)(BOOL finished))completion;
@end
