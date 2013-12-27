//
//  TestCustomCell.m
//  M2UIDemo
//
//  Created by Chen Meisong on 13-12-19.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "TestCustomCell.h"

@interface TestCustomCell()
@property (nonatomic, weak) UIImageView *myImageView;
@property (nonatomic, weak) UILabel *myTitleLabel;
@property (nonatomic, weak) UILabel *mySubTitleLabel;
@end

@implementation TestCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:myImageView];
        self.myImageView = myImageView;
        
        UILabel *myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 180, 20)];
        myTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:myTitleLabel];
        self.myTitleLabel = myTitleLabel;
        
        UILabel *mySubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 180, 20)];
        mySubTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:mySubTitleLabel];
        self.mySubTitleLabel = mySubTitleLabel;
    }
    
    return self;
}

- (void)loadData:(NSString*)title
        subTitle:(NSString*)subTitle
           image:(UIImage*)image{
    self.myTitleLabel.text = title;
    self.mySubTitleLabel.text = subTitle;
    self.myImageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (float)recommendHeight{
    return 60;
}

@end
