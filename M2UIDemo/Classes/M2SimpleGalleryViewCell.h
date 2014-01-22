//
//  M2SimpleGalleryViewCell.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-22.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：A；
//  版本：1.0；
//  配套：M2SimpleGalleryView；

#import <UIKit/UIKit.h>
@protocol M2GalleryViewCellDelegate;

@interface M2SimpleGalleryViewCell : UIView
// required：子类请实现image的getter方法；
@property (nonatomic) UIImage       *image;
// required：您需要在子类的image加载完毕后（类似self.customImageView.image = image之后），调用此方法；
- (void)didLoadImageFinish;

// optional：建议子类实现，cell frame变化时此方法会被调用，子类可能要调整自己的sub view layout；
- (void)didChangedCellFrame;

// 您不需求手动设置下面两个属性；
@property (nonatomic, weak)         id<M2GalleryViewCellDelegate> delegate;
@property (nonatomic) BOOL          isDidLoadImageFinish;
@end

@protocol M2GalleryViewCellDelegate <NSObject>
- (void)didLoadImageFinishByCell:(M2SimpleGalleryViewCell *)cell;
@end


/*
 * 一个M2SimpleGalleryViewCell子类的示例
 *
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _customImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_customImageView];
        
        // TODO：伪装image获取成功；
        [self performSelector:@selector(didLoadImageFinish) withObject:nil afterDelay:0.5 + arc4random() % 50 / 10.0];
    }
    return self;
}

#pragma mark - setter/getter
- (UIImage*)image{
    return _customImageView.image; // 1、required：mage的getter
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
    _customImageView.frame = self.bounds;
}
*/
