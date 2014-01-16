//
//  M2ShowFullInfoView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2ExtensibleInfoView.h"

#define M2SFIV_TitleLabelHeight 30
#define M2SFIV_Default_maxNumberOfLinesWhenNotOpenning 5
#define M2SFIV_AnimationDuration 0.25

@interface M2ExtensibleInfoView()
@property (nonatomic)       UIView      *extendTapView;
@end

@implementation M2ExtensibleInfoView

- (id)initWithFrame:(CGRect)frame
{
    frame.size.height = M2SFIV_TitleLabelHeight;
    
    self = [super initWithFrame:frame];
    if (self) {
        _maxNumberOfLinesWhenNotExtend = M2SFIV_Default_maxNumberOfLinesWhenNotOpenning;
        self.clipsToBounds = YES;
        
        // Initialization code
        // 标题
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), M2SFIV_TitleLabelHeight)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.text = @"内容提要";
        [self addSubview:_titleLabel];
        
        // 信息
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(frame) - 5 * 2, 0)];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.numberOfLines = 0;
        _infoLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _infoLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_infoLabel];
        
        
        // 展开事件区
        _extendTapView = [[UIView alloc] initWithFrame: CGRectMake(0, CGRectGetHeight(frame) - 20, 80, 20)];
        _extendTapView.hidden = YES;
        [self addSubview: _extendTapView];
        // 展开Label前的省略号
        _ellipsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 10, CGRectGetHeight(_extendTapView.frame))];
        _ellipsisLabel.backgroundColor = [UIColor clearColor];
        _ellipsisLabel.font = [UIFont systemFontOfSize:12];
        _ellipsisLabel.text = @"...";
        [_extendTapView addSubview:_ellipsisLabel];
        // 展开Label
        _extendLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ellipsisLabel.frame), 0, 50, CGRectGetHeight(_extendTapView.frame))];
        _extendLabel.backgroundColor = [UIColor clearColor];
        _extendLabel.font = [UIFont systemFontOfSize:12];
        _extendLabel.textColor = [UIColor blueColor];
        _extendLabel.text = @"显示更多";
        [_extendTapView addSubview:_extendLabel];
        // tap事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapExtend:)];
        [_extendTapView addGestureRecognizer:tap];
    }
    
    return self;
}

#pragma mark - public
- (void)reloadData:(NSString*)text{
    _infoLabel.text = text;
    [self adjustHeightsWithIsUserTap:NO];
}

#pragma mark - button event
- (void)onTapExtend:(UITapGestureRecognizer *)tap{
    _extendTapView.hidden = YES;
    [self adjustHeightsWithIsUserTap:YES];
}

#pragma adjust layout
- (void)adjustHeightsWithIsUserTap:(BOOL)isUserTap{
    float infoLabelHeight = [self heightOfLabel:_infoLabel];
    CGRect infoLabelFrame = CGRectMake(CGRectGetMinX(_infoLabel.frame), CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_infoLabel.frame), infoLabelHeight);
    CGRect selfFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(infoLabelFrame));
    CGRect extendTapFrame = _extendTapView.frame;
    if (!isUserTap) {
        int maxHeight = (int)[self heightOfLabel:_infoLabel withNumberOfLines:_maxNumberOfLinesWhenNotExtend];
        int more = (int)CGRectGetHeight(infoLabelFrame) - maxHeight;// 用int型和0比较，float直接和0比较可能有问题
        if (more > 0) {
            infoLabelFrame.size.height -= more;
            selfFrame.size.height -= more;
            extendTapFrame.origin.y = CGRectGetMaxY(infoLabelFrame);
            selfFrame.size.height += CGRectGetHeight(extendTapFrame);
            _extendTapView.hidden = NO;
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(extensibleInfoView:willExtendToFrame:animationDuration:)]) {
        [_delegate extensibleInfoView:self willExtendToFrame:selfFrame animationDuration: M2SFIV_AnimationDuration];
    }
    
    // 获得信息时不需要动画
    if (!isUserTap) {
        self.frame = selfFrame;
        _infoLabel.frame = infoLabelFrame;
        _extendTapView.frame = extendTapFrame;
    }
    // 用户点击时需要动画
    else{
        __weak M2ExtensibleInfoView *weakSelf = self;
        _extendTapView.userInteractionEnabled = NO;
        [UIView animateWithDuration:M2SFIV_AnimationDuration
                         animations:^{
                             weakSelf.frame = selfFrame;
                             weakSelf.infoLabel.frame = infoLabelFrame;
                             weakSelf.extendTapView.frame = extendTapFrame;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.extendTapView.userInteractionEnabled = YES;
                         }];
    }
}

#pragma mark - tools
- (float)heightOfLabel:(UILabel *)label{
    if (label.text.length <= 0) {
        return CGRectGetHeight(label.bounds);
    }
    return [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(CGRectGetWidth(label.bounds), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
}
- (float)heightOfLabel:(UILabel*)label withNumberOfLines:(int)numberOfLines{
    NSMutableString *string = [NSMutableString stringWithString:@""];
    for (int i = 0; i < numberOfLines; i++) {
        [string appendString:@"\n"];
    }
    CGSize size = [string sizeWithFont:label.font constrainedToSize:CGSizeMake(CGRectGetWidth(label.bounds), MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    return size.height;
}

@end
