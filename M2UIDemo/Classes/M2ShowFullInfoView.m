//
//  M2ShowFullInfoView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2ShowFullInfoView.h"

#define M2SFIV_DefaultMaxHeight 80
#define M2SFIV_AnimationDuration 0.25

@interface M2ShowFullInfoView(){
    UILabel *_titleLabel;
}
@property (nonatomic, copy) NSString *info;
@end

@implementation M2ShowFullInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _maxHeight = M2SFIV_DefaultMaxHeight;
        self.clipsToBounds = YES;
        
        // Initialization code
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 30)];//TODO
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"内容提要";
        [self addSubview:_titleLabel];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(frame) - 5 * 2, 0)];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_infoLabel];
        
        _showFullInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _showFullInfoButton.frame = CGRectMake(CGRectGetWidth(frame) - 50 - 5, CGRectGetHeight(frame) - 20 - 5, 50, 20);
        _showFullInfoButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [_showFullInfoButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_showFullInfoButton setTitle:@"显示更多" forState:UIControlStateNormal];
        [_showFullInfoButton addTarget:self action:@selector(onTapShowFullInfo) forControlEvents:UIControlEventTouchUpInside];
        _showFullInfoButton.hidden = YES;
        [self addSubview:_showFullInfoButton];
    }
    
    return self;
}

#pragma mark - public
- (void)reloadData:(NSString*)info{
    self.info = info;
    _infoLabel.text = info;
    [self adjustHeightsWithIsLimitToMaxHeight:YES];
}

#pragma mark - button event
- (void)onTapShowFullInfo{
    _showFullInfoButton.hidden = YES;
    [self adjustHeightsWithIsLimitToMaxHeight:NO];
}

#pragma adjust layout
- (void)adjustHeightsWithIsLimitToMaxHeight:(BOOL)isLimitToMaxHeight{
    float infoLabelHeight = [self heightOfLabel:_infoLabel withText:_info];
    CGRect infoLabelFrame = CGRectMake(CGRectGetMinX(_infoLabel.frame), CGRectGetMinY(_infoLabel.frame), CGRectGetWidth(_infoLabel.frame), infoLabelHeight);
    CGRect frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(infoLabelFrame) + 5);

    if (isLimitToMaxHeight) {
        float more = CGRectGetHeight(frame) - _maxHeight;
        if (more) {
            frame.size.height = _maxHeight;
            infoLabelFrame.size.height -= more;
            _showFullInfoButton.hidden = NO;
        }
    }
    
    __weak M2ShowFullInfoView *weakSelf = self;
    [UIView animateWithDuration:M2SFIV_AnimationDuration
                     animations:^{
                         weakSelf.frame = frame;
                         weakSelf.infoLabel.frame = infoLabelFrame;
                         weakSelf.showFullInfoButton.frame = CGRectMake(CGRectGetWidth(frame) - 50 - 5, CGRectGetHeight(frame) - 20 - 5, 50, 20);
                     }
                     completion:^(BOOL finished) {
                         ;
                     }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(changeToHeight:animationDuration:ofView:)]) {
        [_delegate changeToHeight:CGRectGetHeight(self.bounds) animationDuration:M2SFIV_DefaultMaxHeight ofView:self];
    }
}

#pragma mark - tools
- (float)heightOfLabel:(UILabel*)label withText:(NSString*)text{
    CGSize size = [text sizeWithFont:label.font constrainedToSize:CGSizeMake(CGRectGetWidth(label.bounds), MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    return size.height;
}

@end
