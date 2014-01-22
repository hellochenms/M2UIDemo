//
//  M2SimpleGalleryViewCell.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2SimpleGalleryViewCell.h"

@implementation M2SimpleGalleryViewCell

#pragma mark - public
- (void)didLoadImageFinish{
    //  加载image完毕isDidLoadImageFinish置YES
    self.isDidLoadImageFinish = YES;
    //  加载image完毕通知delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(didLoadImageFinishByCell:)]) {
        [self.delegate didLoadImageFinishByCell:self];
    }
}
- (void)didChangedCellFrame{}

@end
