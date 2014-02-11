//
//  MSimpleGalleryView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSimpleGalleryView.h"
#import "M2SimpleGalleryView_A.h"
#import "MSimpleGalleryViewCell.h"

@interface MSimpleGalleryView()<M2SimpleGalleryViewDataSource>{
    NSArray             *_imageNames;
    M2SimpleGalleryView_A *_galleryView;
}
@end

@implementation MSimpleGalleryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageNames = @[@"landscape_0.jpg", @"portrait_0.jpg", @"portrait_1.jpg", @"landscape_1.jpg"];
        
        // self
        self.clipsToBounds = YES;
        
        // gallery
        _galleryView = [[M2SimpleGalleryView_A alloc] initWithFrame:CGRectMake(0, 0, 320, 200) itemWidth:130];
        _galleryView.backgroundColor = [UIColor blackColor];
        _galleryView.dataSource = self;
        [self addSubview:_galleryView];
    }
    return self;
}

#pragma mark - M2SimpleGalleryViewDataSource
- (NSInteger)numberOfItemsInGalleryView:(M2SimpleGalleryView_A *)galleryView{
    return [_imageNames count];
}
- (M2SimpleGalleryViewCell *)galleryView:(M2SimpleGalleryView_A *)galleryView itemAtIndex:(NSInteger)index{
    MSimpleGalleryViewCell *view = [MSimpleGalleryViewCell new];
    view.imageName = [_imageNames objectAtIndex:index];
    
    return view;
}

@end
