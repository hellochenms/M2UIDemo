//
//  MShowFullInfoView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-6.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MShowFullInfoView.h"
#import "M2ExtensibleInfoView.h"

@interface MShowFullInfoView()<M2ExtensibleInfoViewDelegate>{
    M2ExtensibleInfoView *_showFullInfoView;
}
@property (nonatomic) UIScrollView *mainView;
@property (nonatomic) UIView *belowAreaContainerView;
@end

@implementation MShowFullInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
        
        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _mainView.showsVerticalScrollIndicator = NO;
        [self addSubview:_mainView];
        
        _showFullInfoView = [[M2ExtensibleInfoView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(frame) - 5 * 2, 0)];
        _showFullInfoView.backgroundColor = [UIColor grayColor];
        _showFullInfoView.maxNumberOfLinesWhenNotExtend = 5;
        _showFullInfoView.delegate = self;
        [_mainView addSubview:_showFullInfoView];
        
        _belowAreaContainerView = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_showFullInfoView.frame) + 10, CGRectGetWidth(frame) - 5 * 2, 200)];
        _belowAreaContainerView.backgroundColor = [UIColor grayColor];
        [_mainView addSubview:_belowAreaContainerView];
        
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(5, 5, CGRectGetWidth(_belowAreaContainerView.bounds) - 5 * 2, CGRectGetHeight(_belowAreaContainerView.bounds) / 3)];
        view1.backgroundColor = [UIColor blueColor];
        [_belowAreaContainerView addSubview:view1];
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(view1.frame) + 5, CGRectGetWidth(_belowAreaContainerView.bounds) - 5 * 2, CGRectGetHeight(_belowAreaContainerView.bounds) / 3)];
        view2.backgroundColor = [UIColor blueColor];
        [_belowAreaContainerView addSubview:view2];
        
        // contentSize
        _mainView.contentSize = CGSizeMake(CGRectGetWidth(_mainView.bounds), CGRectGetMaxY(_belowAreaContainerView.frame) + 5);
    }
    return self;
}

- (void)reloadData:(NSDictionary*)data{
    [_showFullInfoView reloadData:@"    当我十七岁的时候, 我读到了一句话:“如果你把每一天都当作生命中最后一天去生活的话,那么有一天你会发现你是正确的。”这句话给我留下了深刻的印象。从那时开始,过了33年,我在每天早晨都会对着镜子问自己:“如果今天是我生命中的最后一天, 你会不会完成你今天想做的China事情呢？”当答案连续很多次被给予“不是”的时候, 我知道自己需要改变某些事情了。\n    “记住你即将死去”是我一生中遇到的最重要箴言。它帮我指明了生命中重要的选择。因为几乎所有的事情, 包括所有的荣誉、所有的骄傲、所有对难堪和失败的恐惧,这些在死亡面前都会消失。我看到的是留下的真正重要的东西。你有时候会思考你将会失去某些东西,“记住你即将死去”是我知道的避免这些想法的最好办法。你已经赤身裸体了, 你没有理由不去跟随自己的心一起跳动。\n\n    没有人愿意死, 即使人们想上天堂, 人们也不会为了去那里而死。但是死亡是我们每个人共同的终点。从来没有人能够逃脱它。也应该如此。 因为死亡就是生命中最好的一个发明。它将旧的清除以便给新的让路。你们现在是新的, 但是从现在开始不久以后, 你们将会逐渐的变成旧的然后被清除。我很抱歉这很戏剧性, 但是这十分的真实。\n    你们的时间很有限, 所以不要将他们浪费在重复其他人的生活上。不要被教条束缚,那意味着你和其他人思考的结果一起生活。不要被其他人喧嚣的观点掩盖你真正的内心的声音。还有最重要的是, 你要有勇气去听从你直觉和心灵的指示——它们在某种程度上知道你想要成为什么样子，所有其他的事情都是次要的。"];
}

#pragma mark - M2ShowFullInfoViewDelegate
- (void)extensibleInfoView:(M2ExtensibleInfoView *)extensibleInfoView willExtendToFrame:(CGRect)frame animationDuration:(float)animationDuration{
    CGRect belowAreaFrame = CGRectMake(CGRectGetMinX(_belowAreaContainerView.frame), CGRectGetMaxY(frame) + 10, CGRectGetWidth(_belowAreaContainerView.frame), CGRectGetHeight(_belowAreaContainerView.frame));
     _mainView.contentSize = CGSizeMake(CGRectGetWidth(_mainView.bounds), CGRectGetMaxY(belowAreaFrame) + 5);
    __weak MShowFullInfoView *weakSelf = self;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         weakSelf.belowAreaContainerView.frame = belowAreaFrame;
                     }];

}

@end
