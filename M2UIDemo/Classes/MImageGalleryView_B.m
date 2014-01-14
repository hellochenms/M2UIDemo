//
//  MImageGalleryView_B.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-14.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MImageGalleryView_B.h"
#import "M2GalleryView.h"

@interface MImageGalleryView_B()<M2GalleryViewDataSource> {
    M2GalleryView   *_galleryView;
    NSArray         *_imageNames;
}
@end

@implementation MImageGalleryView_B

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageNames = @[@"landscape_0.jpg", @"portrait_0.jpg", @"portrait_1.jpg", @"landscape_1.jpg"];
        
        //
        _galleryView = [[M2GalleryView alloc] initWithFrame:CGRectMake(0, 0, 320, 400)];
        _galleryView.datasource = self;
        [self addSubview:_galleryView];
    }
    return self;
}

#pragma mark - M2GalleryViewDataSource
- (NSInteger)numberOfItemsInGalleryView:(M2GalleryView *)galleryView{
    return [_imageNames count];
}
- (UIView *)galleryView:(M2GalleryView *)galleryView itemAtIndex:(NSInteger)index{
    UIImageView *view = [UIImageView new];
    view.image = [UIImage imageNamed:[_imageNames objectAtIndex:index]];
    view.contentMode = UIViewContentModeScaleAspectFill;
    
    return view;
}
@end
