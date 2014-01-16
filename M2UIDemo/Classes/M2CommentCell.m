//
//  M2CommentCell.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#define M2CC_SelfWidth      320
#define M2CC_UserHeight     20
#define M2CC_ReplyWidth     280
#define M2CC_CommentWidth   300

#define M2CC_Margin         5
#define M2CC_Space          5

#import "M2CommentCell.h"

@interface M2CommentCell(){
    UILabel *_userLabel;
    UILabel *_replyTagetLabel;
    UILabel *_commentLabel;
}
@end

@implementation M2CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // self
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 评论者
        _userLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, M2CC_Margin, 160, M2CC_UserHeight)];
        [self.contentView addSubview:_userLabel];
        
        // 回复按钮
        UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        replyButton.frame = CGRectMake(M2CC_SelfWidth - 60 - 5, M2CC_Margin, 60, M2CC_UserHeight);
        [replyButton setTitle:@"回复" forState:UIControlStateNormal];
        [replyButton addTarget:self action:@selector(onTapReplyButton) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:replyButton];
        
        // 回复目标
        _replyTagetLabel = [[UILabel alloc] initWithFrame:CGRectMake((M2CC_SelfWidth - M2CC_ReplyWidth) / 2, CGRectGetMaxY(_userLabel.frame) + M2CC_Space, M2CC_ReplyWidth, 0)];
        _replyTagetLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        _replyTagetLabel.layer.borderWidth = 1;
        _replyTagetLabel.numberOfLines = 0;
        _replyTagetLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _replyTagetLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_replyTagetLabel];
        
        // 评论
        _commentLabel = [[UILabel alloc] initWithFrame:CGRectMake((M2CC_SelfWidth - M2CC_CommentWidth) / 2, CGRectGetMaxY(_replyTagetLabel.frame) + M2CC_Space, M2CC_CommentWidth, 0)];
        _commentLabel.numberOfLines = 0;
        _commentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _commentLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - public
- (void)reloadData:(NSDictionary *)data{
    [self clearOldData];
    [self loadNewData:data];
}
#pragma mark -
- (void)clearOldData{
    // 评论者
    _userLabel.text = nil;
    
    // 回复目标
    _replyTagetLabel.text = nil;
    CGRect replyFrame = _replyTagetLabel.frame;
    replyFrame.size.height = 0;
    _replyTagetLabel.frame = replyFrame;
    // 评论
    _commentLabel.text = nil;
    CGRect commentFrame = _commentLabel.frame;
    commentFrame.size.height = 0;
    _commentLabel.frame = commentFrame;
}

- (void)loadNewData:(NSDictionary *)data{
    // 评论者
    NSString *user = [data objectForKey:M2CC_Key_User];
    if (user.length <= 0) {
        user = @"匿名用户";
    }
    _userLabel.text = user;
    
    // 回复目标
    NSString *replyToUser = [data objectForKey:M2CC_Key_ReplyToUser];
    NSString *replyToComment = [data objectForKey:M2CC_Key_ReplyToComment];
    
    BOOL isReplyExists = NO;
    if (replyToComment.length > 0) {
        isReplyExists = YES;
        if (replyToUser.length <= 0) {
            replyToUser = @"匿名网友";
        }
        _replyTagetLabel.text = [NSString stringWithFormat:@"回复 %@：\n%@", replyToUser, replyToComment];
        CGRect frame = _replyTagetLabel.frame;
        frame.size.height = [M2CommentCell heightOfText:replyToComment WithFont:_replyTagetLabel.font limitToWidth:M2CC_ReplyWidth];
        _replyTagetLabel.frame = frame;
    }
    
    // 评论
    NSString *comment = [data objectForKey:M2CC_Key_Comment];
    if (comment.length > 0) {
        _commentLabel.text = comment;
        CGRect frame = _commentLabel.frame;
        frame.origin.y = CGRectGetMaxY(isReplyExists ? _replyTagetLabel.frame : _userLabel.frame);
        frame.size.height = [M2CommentCell heightOfText:comment WithFont:_commentLabel.font limitToWidth:M2CC_CommentWidth];
        _commentLabel.frame = frame;
    }
    
    // Cell高度
    CGRect frame = self.frame;
    frame.size.height = CGRectGetMaxY(_commentLabel.frame) + M2CC_Margin;
    self.frame = frame;
}

#pragma mark - + public 计算cell高度
+ (CGFloat)heightOfCellForData:(NSDictionary *)data
               withCommentFont:(UIFont *)commentFont
            andReplyTargetFont:(UIFont *)replyFont{
    // 上留白
    CGFloat height = M2CC_Margin;
    
    // 评论者
    height += M2CC_UserHeight;
    
    // 间距
    height += M2CC_Space;
    
    // 回复的目标
    NSString *replyToUser = [data objectForKey:M2CC_Key_ReplyToUser];
    NSString *replyToComment = [data objectForKey:M2CC_Key_ReplyToComment];
    if (replyToComment.length > 0) {
        if (replyToUser.length <= 0) {
            replyToUser = @"匿名网友";
        }
        replyToComment = [NSString stringWithFormat:@"回复 %@：\n%@", replyToUser, replyToComment];
        height += [self heightOfText:replyToComment WithFont:replyFont limitToWidth:M2CC_ReplyWidth];
    }
    
    // 间距
    height += M2CC_Space;
    
    // 评论
    NSString *comment = [data objectForKey:M2CC_Key_Comment];
    if (comment.length > 0) {
        height += [self heightOfText:comment WithFont:commentFont limitToWidth:280];
    }
    
    // 下留白
    height += M2CC_Margin;
    
    return height;
}

#pragma mark - tap event
- (void)onTapReplyButton{
    if (_delegate && [_delegate respondsToSelector:@selector(didTapReplyButtonOfCommentCell:)]) {
        [_delegate didTapReplyButtonOfCommentCell:self];
    }
}

#pragma mark - tools
+ (float)heightOfText:(NSString *)text WithFont:(UIFont *)font limitToWidth:(float)width{
    return [text sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping].height;
}

@end
