//
//  MCommentView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MCommentView.h"
#import "M2CommentCell.h"
#import "M2TextInputView.h"

@interface MCommentView()<UITableViewDataSource, UITableViewDelegate, M2CommentCellDelegate>{
    NSArray         *_comments;
    UITableView     *_commentTableView;
    M2TextInputView *_textInputView;
}
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
        
        // 评论输入框
        _textInputView = [[M2TextInputView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), 150)];
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
    [_textInputView show];
}

#pragma mark - comment event
- (void)onTapCommentButton{
    [_textInputView show];
}

@end
