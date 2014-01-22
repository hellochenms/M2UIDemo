//
//  MSimpleGalleryViewCell.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MSimpleGalleryViewCell.h"

@interface MSimpleGalleryViewCell()
@property (nonatomic) UIImageView *customImageView;
@end

@implementation MSimpleGalleryViewCell

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(frame) - 10 * 2, CGRectGetHeight(frame) - 10 * 2)];
        _customImageView.layer.borderColor = [UIColor blueColor].CGColor;
        _customImageView.layer.borderWidth = 1;
        _customImageView.clipsToBounds = YES;
        _customImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_customImageView];
        
        // TODO：伪装image获取成功；
        [self performSelector:@selector(didLoadImageFinish) withObject:nil afterDelay:0.5 + arc4random() % 10 / 10.0];
    }
    return self;
}

#pragma mark - setter/getter
- (UIImage*)image{
    return _customImageView.image; // 1、required：mage的getter
}
- (UIImageView*)imageView{
    return _customImageView; // optional: 实现imageView的getter
}

#pragma mark -
- (void)didLoadImageFinish{
    // 设置image
    _customImageView.image = [UIImage imageNamed:self.imageName];
    // 2、required：调用父类didLoadImageFinish方法；
    [super didLoadImageFinish];
}

#pragma mark - override
- (void)didChangedCellFrame{
    _customImageView.frame = CGRectMake(10, 10, CGRectGetWidth(self.bounds) - 10 * 2, CGRectGetHeight(self.bounds) - 10 * 2);
}

@end
