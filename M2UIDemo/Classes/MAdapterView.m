//
//  MAdapterView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MAdapterView.h"
#import "MTestAsyncImageView.h"

@interface MAdapterView(){
    MTestAsyncImageView *_asyncImageView;
}
@property (nonatomic) BOOL isLoading;
@end

@implementation MAdapterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _asyncImageView = [[MTestAsyncImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_asyncImageView];
    }
    return self;
}

#pragma mark - public
- (void)loadImage{
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    NSString *prefix = arc4random() % 2 == 0 ? @"landscape_" : @"portrait_";
    __weak MAdapterView *weakSelf = self;
    [_asyncImageView loadImageWithName:[NSString stringWithFormat:@"%@%d.jpg", prefix, arc4random() % 4]
                            completion:^(BOOL finished) {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didLoadImageFinishFromView:)]) {
                                    [weakSelf.delegate didLoadImageFinishFromView:weakSelf];
                                    weakSelf.isLoading = NO;
                                }
                            }];
}

#pragma mark - 
- (UIImage *)image{
    return _asyncImageView.image;
}
- (void)didChangedViewFrameFromView:(M2AutoRotateImageView *)view{
    _asyncImageView.frame = self.bounds;
}

@end
