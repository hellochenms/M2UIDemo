//
//  M2CommentCell.h
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-16.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//
//  分支：Master
//  版本：1.0
//  特点：实现了评论cell常用接口及高度相关的逻辑，使用者需要定制（数据模型及使用）、UI样式；

#import <UIKit/UIKit.h>

// 真实场景下，这些key肯定不是定义在这的，应该定义在model层；
// 更常见的是，数据不是NSDictionary，而是自定义的DataModel；
// 所以本类中计算height，和reloadData时调整cell内sub view们布局的代码中，部分是需要根据实际情况定制的；
// 但是，计算高度的逻辑是一样的，沿用即可；
#define M2CC_Key_User           @"user"
#define M2CC_Key_Comment        @"comment"
#define M2CC_Key_CommentDate    @"date"
#define M2CC_Key_ReplyToUser    @"replyToUser"
#define M2CC_Key_ReplyToComment @"replyToComment"

@protocol M2CommentCellDelegate;

@interface M2CommentCell : UITableViewCell
+ (CGFloat)heightOfCellForData:(NSDictionary *)data
               withCommentFont:(UIFont *)commentFont
            andReplyTargetFont:(UIFont *)replyFont;
@property (nonatomic)       NSIndexPath                 *indexPath;
@property (nonatomic, weak) id<M2CommentCellDelegate>   delegate;
- (void)reloadData:(NSDictionary *)data;
@end

@protocol M2CommentCellDelegate <NSObject>
- (void)didTapReplyButtonOfCommentCell:(M2CommentCell *)cell;
@end
