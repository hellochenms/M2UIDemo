//
//  MSimpleGalleryBView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSimpleGalleryBView.h"
#import "M2SimpleGalleryView.h"
#import "MSimpleGalleryViewCell.h"

@interface MSimpleGalleryBView()<M2SimpleGalleryViewDataSource, M2SimpleGalleryViewDelegate>{
    NSArray             *_imageNames;
    M2SimpleGalleryView *_galleryView;
}
@end

@implementation MSimpleGalleryBView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageNames = @[@"landscape_0.jpg", @"portrait_0.jpg", @"portrait_1.jpg", @"landscape_1.jpg", @"landscape_0.jpg", @"portrait_0.jpg", @"portrait_1.jpg", @"landscape_1.jpg"];
        
        // self
        self.clipsToBounds = YES;
        
        // gallery
        _galleryView = [[M2SimpleGalleryView alloc] initWithFrame:CGRectMake(0, 0, 320, 200) itemWidth:200];
        _galleryView.backgroundColor = [UIColor blackColor];
        _galleryView.dataSource = self;
        _galleryView.delegete = self;
        [self addSubview:_galleryView];
    }
    return self;
}

#pragma mark - M2SimpleGalleryViewDataSource
- (NSInteger)numberOfItemsInGalleryView:(M2SimpleGalleryView *)galleryView{
    return [_imageNames count];
}
- (M2SimpleGalleryViewCell *)galleryView:(M2SimpleGalleryView *)galleryView itemAtIndex:(NSInteger)index{
    MSimpleGalleryViewCell *view = [MSimpleGalleryViewCell new];
    view.imageName = [_imageNames objectAtIndex:index];
    
    return view;
}

#pragma mark - M2SimpleGalleryViewDelegate
- (void)galleryView:(M2SimpleGalleryView *)galleryView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"index(%d)  @@%s", index, __func__);
}

@end
