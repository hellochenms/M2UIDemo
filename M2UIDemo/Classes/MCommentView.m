//
//  MCommentView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCommentView.h"
#import "M2CommentCell.h"
#import "M2CommentInputView.h"

@interface MCommentView()<UITableViewDataSource, UITableViewDelegate, M2CommentCellDelegate, M2CommentInputViewDelegate>{
    NSArray             *_comments;
    UITableView         *_commentTableView;
    M2CommentInputView  *_textInputView;
}
@property (nonatomic) UIControl *coverView;
@end

@implementation MCommentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // self
        self.backgroundColor = [UIColor lightGrayColor];
        // 评论
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(100, 5, 120, 30);
        commentButton.backgroundColor = [UIColor grayColor];
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(onTapCommentButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:commentButton];
        
        // 评论列表
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, CGRectGetWidth(frame), CGRectGetHeight(frame) - 40)];
        _commentTableView.backgroundColor = [UIColor clearColor];
        _commentTableView.dataSource = self;
        _commentTableView.delegate = self;
        _commentTableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
        [self addSubview:_commentTableView];
        
        // 底部区（只是为了测试随键盘弹出的输入框）
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 50, CGRectGetWidth(frame), 50)];
        bottomView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
        [self addSubview:bottomView];
        
        // 输入时遮罩
        _coverView = [[UIControl alloc] initWithFrame: self.bounds];
        _coverView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_coverView addTarget:self action:@selector(onTapCover) forControlEvents:UIControlEventTouchUpInside];
        _coverView.hidden = YES;
        [self addSubview:_coverView];
        
        // 评论输入框
        _textInputView = [[M2CommentInputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 150)];
        _textInputView.delegate = self;
        [self addSubview:_textInputView];
    }
    return self;
}

#pragma mark - public
- (void)reloadData:(NSArray *)data{
    _comments = data;
    [_commentTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_comments count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    M2CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[M2CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    [cell reloadData:[_comments objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [M2CommentCell heightOfCellForData:[_comments objectAtIndex:indexPath.row]
                              withCommentFont:[UIFont systemFontOfSize:14]
                           andReplyTargetFont:[UIFont systemFontOfSize:12]];
}

#pragma mark - M2CommentCellDelegate
- (void)didTapReplyButtonOfCommentCell:(M2CommentCell *)cell{
    NSLog(@"cell.indexPath(%@)  @@%s", cell.indexPath, __func__);
    [_textInputView showWithReplyToUserName:[[_comments objectAtIndex:cell.indexPath.row] objectForKey:M2CC_Key_User]];
}

#pragma mark - comment event
- (void)onTapCommentButton{
    [_textInputView showWithReplyToUserName:nil];
}
- (void)onTapCover{
    [_textInputView hide];
}

#pragma mark - M2CommentInputViewDelegate
- (void)inputView:(M2CommentInputView *)inputView willChangeStateWithIsWillShow:(BOOL)willShow{
    __weak MCommentView *weakSelf = self;
    if (willShow) {
        weakSelf.coverView.alpha = 0;
        weakSelf.coverView.hidden = NO;
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.coverView.alpha = 1;
                         }];
    }else{
        [UIView animateWithDuration:0.25
                         animations:^{
                             weakSelf.coverView.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             weakSelf.coverView.hidden = YES;
                         }];
    }
}
@end
