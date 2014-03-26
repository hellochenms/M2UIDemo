//
//  M2TapHalfStarView_A.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-3-26.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2TapHalfStarView_A.h"

@interface M2TapHalfStarView_A()
@property (nonatomic) UIImage           *leftNormalImage;
@property (nonatomic) UIImage           *leftSelectedImage;
@property (nonatomic) UIImage           *rightNormalImage;
@property (nonatomic) UIImage           *rightSelectedImage;
@property (nonatomic) NSInteger         physicalCount;
@property (nonatomic) NSMutableArray    *items;
@end

@implementation M2TapHalfStarView_A
- (id)initWithFrame:(CGRect)frame
leftNormalImageName:(NSString*)leftNormalImageName
leftSelectedImageName:(NSString*)leftSelectedImageName
rightNormalImageName:(NSString*)rightNormalImageName
rightSelectedImageName:(NSString*)rightSelectedImageName
          starCount:(NSInteger)starCount{
    self = [super initWithFrame:frame];
    if (self) {
        // 参数检查
        if ([leftNormalImageName length] <= 0
            || [leftSelectedImageName length] <= 0
            || [rightNormalImageName length] <= 0
            || [rightSelectedImageName length] <= 0){
            NSLog(@"参数非法  @@%s", __func__);
            return self;
        }
        _leftNormalImage = [UIImage imageNamed:leftNormalImageName];
        _leftSelectedImage = [UIImage imageNamed:leftSelectedImageName];
        _rightNormalImage = [UIImage imageNamed:rightNormalImageName];
        _rightSelectedImage = [UIImage imageNamed:rightSelectedImageName];
        if (!_leftNormalImage || !_leftSelectedImage || !_rightNormalImage || !_rightSelectedImage || starCount <= 0) {
            NSLog(@"参数非法  @@%s", __func__);
            return self;
        }
        
        //
        _physicalCount = starCount * 2;
        
        // items
        _items = [NSMutableArray arrayWithCapacity:_physicalCount];
        float itemWidth = CGRectGetWidth(frame) / _physicalCount;
        float itemHeight = self.bounds.size.height;
        UIImageView *imgView = nil;
        for (int i = 0; i < _physicalCount; i++) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, itemHeight)];
            if (i % 2 == 0) {
                imgView.contentMode = UIViewContentModeRight;
                imgView.image = _leftNormalImage;
            }else{
                imgView.contentMode = UIViewContentModeLeft;
                imgView.image = _rightNormalImage;
            }
            [self addSubview:imgView];
            [_items addObject:imgView];
        }
        
        // tap
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapRec];
    }
    
    return self;
}

#pragma mark - tap event
- (void)onTap:(UITapGestureRecognizer*)tapRec{
    if (tapRec.state == UIGestureRecognizerStateEnded) {
        // UI
        CGPoint point = [tapRec locationInView:tapRec.view];
        float itemWidth = CGRectGetWidth(self.bounds) / _physicalCount;
        self.grade = ceil(point.x / itemWidth) / 2.0;
        // delegate
        if (_delegate && [_delegate respondsToSelector:@selector(halfStarView:didSelectedForGrade:)]) {
            [_delegate halfStarView:self didSelectedForGrade:_grade];
        }
    }
}

#pragma mark - setter
- (void)setGrade:(float)grade{
    _grade = grade;
    if (_grade < 0) {
        _grade = 0;
    }else if (_grade > _physicalCount / 2.0){
        _grade = _physicalCount / 2.0;
    }
    
    UIImageView *imgView = nil;
    NSInteger selectTailIndex = round(_grade * 2) - 1;
    for (NSInteger i = 0; i < _physicalCount; i++) {
        imgView = [_items objectAtIndex:i];
        if (i <= selectTailIndex) {
            imgView.image = (i % 2 == 0 ? _leftSelectedImage : _rightSelectedImage);
        }else{
            imgView.image = (i % 2 == 0 ? _leftNormalImage : _rightNormalImage);
        }
    }
}

@end
