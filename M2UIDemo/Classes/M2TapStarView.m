//
//  M2TapStarView.h
//  M2UIDemo
//
//  Created by Chen Meisong on 13-1-24.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "M2TapStarView.h"

#define M2TSV_DefaultItemCount          5
#define M2TSV_DefaultHorizontalSpace    2

@interface M2TapStarView(){
    UIImage         *_normalImage;
    UIImage         *_selectedImage;
    NSInteger       _count;
    float           _horizontalSpace;
    NSMutableArray  *_items;
    
}
@end

@implementation M2TapStarView
- (id)initWithFrame:(CGRect)frame
    normalImageName:(NSString*)normalImageName
  selectedImageName:(NSString*)selectedImageName{
    return [self initWithFrame:frame
               normalImageName:normalImageName
             selectedImageName:selectedImageName
                     itemCount:M2TSV_DefaultItemCount
               horizontalSpace:M2TSV_DefaultHorizontalSpace];
}

- (id)initWithFrame:(CGRect)frame
    normalImageName:(NSString*)normalImageName
  selectedImageName:(NSString*)selectedImageName
          itemCount:(NSInteger)itemCount
    horizontalSpace:(float)horizontalSpace{
    self = [super initWithFrame:frame];
    if (self) {
        // 参数检查
        if (!normalImageName
            || [@"" isEqualToString:normalImageName]
            || !selectedImageName
            || [@"" isEqualToString:selectedImageName]) {
            NSLog(@"unSelectImgName and selectImgName should not be nil or @\"\"  @@%s", __func__);
            return self;
        }
        _normalImage = [UIImage imageNamed:normalImageName];
        _selectedImage = [UIImage imageNamed:selectedImageName];
        if (!_normalImage || !_selectedImage) {
            NSLog(@"unSelectImg or selectImg do not exist  @@%s", __func__);
            return self;
        }
        
        //
        _count = (itemCount > 0 ? itemCount : M2TSV_DefaultItemCount);
        horizontalSpace = (horizontalSpace > 0 ? horizontalSpace : M2TSV_DefaultHorizontalSpace);
        
        // items
        _items = [NSMutableArray arrayWithCapacity:itemCount];
        float itemWidth = (CGRectGetWidth(frame) - horizontalSpace * (itemCount - 1)) / itemCount;
        float itemHeight = self.bounds.size.height;
        UIImageView *imgView = nil;
        for (int i = 0; i < itemCount; i++) {
            imgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemWidth + horizontalSpace) * i, 0, itemWidth, itemHeight)];
            imgView.image = _normalImage;
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
        float itemAreaWidth = CGRectGetWidth(self.bounds) / _count;
        self.grade = floorf(point.x / itemAreaWidth) + 1;
        // delegate
        if (_delegate && [_delegate respondsToSelector:@selector(starView:didSelectedForGrade:)]) {
            [_delegate starView:self didSelectedForGrade:_grade];
        }
    }
}

#pragma mark - setter
- (void)setGrade:(NSInteger)grade{
    _grade = grade;
    if (_grade < 0) {
        _grade = 0;
    }else if (_grade > _count){
        _grade = _count;
    }
    
    UIImageView *imgView = nil;
    NSInteger selectTailIndex = _grade - 1;
    for (NSInteger i = 0; i < _count; i++) {
        imgView = [_items objectAtIndex:i];
        imgView.image = (i <= selectTailIndex ? _selectedImage : _normalImage);
    }
}

@end
